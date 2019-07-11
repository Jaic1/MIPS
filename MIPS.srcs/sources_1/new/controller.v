`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/06 10:34:18
// Design Name: 
// Module Name: controller
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module controller(
	input					     clk, reset,
	input      [5:0]			 op, funct,
	input                        zero,
	output     reg               memread, memwrite, memtoreg, iord,
	output                       pcen,
	output     reg               regwrite, 
	output     reg  [1:0]        regdst, pcsource, aluop, alusrca,
	output     reg  [2:0]        alusrcb,
	output     reg               irwrite
    );
    
    // state
    reg [4:0]   state, nextstate;
    reg         pcwrite, pcwritecond, pcwritecond_notzero;
    parameter   FETCH    =   5'b00001;       // 1
    parameter   DECODE   =   5'b00010;       // 2
    parameter   MEMADR   =   5'b00011;       // 3
    parameter   LWRD     =   5'b00100;       // 4
    parameter   LWWR     =   5'b00101;       // 5
    parameter   SWWR     =   5'b00110;       // 6
    parameter   RTYPEEX  =   5'b00111;       // 7
    parameter   RTYPEWR  =   5'b01000;       // 8
    parameter   BEQEX    =   5'b01001;       // 9
    parameter   JEX      =   5'b01010;       // 10
    parameter   ANDIEX   =   5'b01011;       // 11
    parameter   ANDIWR   =   5'b01100;       // 12
    parameter   SHAMT    =   5'b01101;       // 13
    parameter   BNEEX    =   5'b01110;       // 14
    parameter   JALCAL   =   5'b01111;       // 15
    parameter   JALEX    =   5'b10000;       // 16
    parameter   JR       =   5'b10001;       // 17
    parameter   ADDIEX   =   5'b10010;       // 18
    parameter   ADDIWR   =   5'b10011;       // 19
    
    // op
    parameter   LW       =   6'b100011;     // 0x23
    parameter   SW       =   6'b101011;     // 0x2b
    parameter   RTYPE    =   6'b000000;     // 0x00
    parameter   BEQ      =   6'b000100;     // 0x04
    parameter   BNE      =   6'b000101;     // 0x05
    parameter   J        =   6'b000010;     // 0x02
    parameter   JAL      =   6'b000011;     // 0x03
    parameter   ANDI     =   6'b001100;     // 0x0c
    parameter   ADDI     =   6'b001000;     // 0x08
    
    // state register
    always @(posedge clk)
        if(reset) state <= FETCH;
        else state <= nextstate;
        
    // update nextstate
    always @(*) begin
        case (state)
            FETCH:      nextstate   <=  DECODE;
            DECODE:     case (op)
                            LW:         nextstate   <=  MEMADR;
                            SW:         nextstate   <=  MEMADR;
                            RTYPE:      case (funct)
                                            6'b000000:  nextstate   <=  SHAMT;      // sll
                                            6'b000010:  nextstate   <=  SHAMT;      // srl
                                            6'b001000:  nextstate   <=  JR;         // jr
                                            default:    nextstate   <=  RTYPEEX;
                                        endcase
                            BEQ:        nextstate   <=  BEQEX;
                            BNE:        nextstate   <=  BNEEX;
                            J:          nextstate   <=  JEX;
                            JAL:        nextstate   <=  JALCAL;
                            ANDI:       nextstate   <=  ANDIEX;
                            ADDI:       nextstate   <=  ADDIEX;
                            default:    nextstate   <=  FETCH;  // control never reach here
                        endcase
            MEMADR:     case (op)
                            LW:         nextstate   <=  LWRD;
                            SW:         nextstate   <=  SWWR;
                            default:    nextstate   <=  FETCH;  // control never reach here
                        endcase
            LWRD:       nextstate   <=  LWWR;
            RTYPEEX:    nextstate   <=  RTYPEWR;
            ANDIEX:     nextstate   <=  ANDIWR;
            SHAMT:      nextstate   <=  RTYPEWR;
            JALCAL:     nextstate   <=  JALEX;
            ADDIEX:     nextstate   <=  ADDIWR;
            default:    nextstate   <=  FETCH;
        endcase
    end
    
    // send control signal
    always @(*) begin
        // initial signal outputs
        irwrite     <=  0;          pcwritecond_notzero <= 0;
        pcwrite     <=  0;          pcwritecond     <=  0;
        regwrite    <=  0;          regdst          <=  2'b00;
        memread     <=  0;          memwrite        <=  0;
        alusrca     <=  2'b00;      alusrcb         <=  3'b000;
        aluop       <=  2'b00;      pcsource        <=  2'b00;
        iord        <=  0;          memtoreg        <=  0;
        case (state)
            FETCH: begin
                memread     <=  1;
                irwrite     <=  1;
                alusrcb     <=  3'b001;
                pcwrite     <=  1;
            end
            
            DECODE: begin
                alusrcb     <=  3'b011;  // calculate beq offset+pc beforehand
            end
            
            MEMADR: begin
                alusrca     <=  2'b01;   // choose register A
                alusrcb     <=  3'b010;  // choose instr's imme(to be added with register rs)
            end
            
            LWRD: begin
               memread      <=  1;
               iord         <=  1;
            end
            
            LWWR: begin
                regwrite    <=  1;
                memtoreg    <=  1;
            end
            
            SWWR: begin
                memwrite    <=  1;
                iord        <=  1;
            end
            
            RTYPEEX: begin
                alusrca      <=  2'b01;  // choose register A and B(default)
                aluop        <=  2'b10;  // RTYPE: utilize funct
            end
            
            RTYPEWR: begin
                regdst      <=  2'b01;  // choose register rt
                regwrite    <=  1;
            end
            
            BEQEX: begin
                alusrca     <=  2'b01;
                aluop       <=  2'b01;
                pcwritecond <=  1;
                pcsource    <=  2'b01;  // beq offset+pc already in aluout
            end
            
            BNEEX: begin
                alusrca     <=  2'b01;
                aluop       <=  2'b01;
                pcwritecond_notzero <= 1;
                pcsource    <=  2'b01;  // bne, similar to beq
            end
            
            JEX: begin
                pcwrite     <=  1;
                pcsource    <=  2'b10;  // choose j target
            end
            
            JALCAL: begin
                alusrcb     <=  3'b001; // choose CONST_FOUR to add PC
            end
            
            JALEX: begin
                regdst      <=  2'b10;
                regwrite    <=  1;
                pcwrite     <=  1;
                pcsource    <=  2'b10;  // choose j target
            end
            
            ANDIEX: begin
                alusrca     <=  2'b01;
                alusrcb     <=  3'b100;
                aluop       <=  2'b11;
            end
            
            ANDIWR: begin
                regwrite    <=  1;
            end
            
            SHAMT: begin
                alusrca     <=  2'b10;  // choose shamt and register B(default)
                aluop       <=  2'b10;  // RTYPE: utilize funct
            end
            
            JR: begin
                pcwrite     <=  1;
                pcsource    <=  2'b11;  // choose output of register A
            end
            
            ADDIEX: begin
                alusrca     <=  2'b01;
                alusrcb     <=  3'b010;
                aluop       <=  2'b00;    
            end
            
            ADDIWR: begin
                regwrite    <=  1;
            end
        endcase
    end
 
    // PC enable
    assign pcen = pcwrite | (pcwritecond & zero) | (pcwritecond_notzero & (~zero));   
    
endmodule
