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
	input      [5:0]			 op,
	input                        zero,
	output     reg               memread, memwrite, alusrca, memtoreg, iord,
	output                       pcen,
	output     reg               regwrite, regdst,
	output     reg  [1:0]        pcsource, aluop,
	output     reg  [2:0]        alusrcb,
	output     reg               irwrite
    );
    
    reg [3:0]   state, nextstate;
    reg         pcwrite, pcwritecond;
    parameter   FETCH    =   4'b0001;       // 1
    parameter   DECODE   =   4'b0010;       // 2
    parameter   MEMADR   =   4'b0011;       // 3
    parameter   LWRD     =   4'b0100;       // 4
    parameter   LWWR     =   4'b0101;       // 5
    parameter   SWWR     =   4'b0110;       // 6
    parameter   RTYPEEX  =   4'b0111;       // 7
    parameter   RTYPEWR  =   4'b1000;       // 8
    parameter   BEQEX    =   4'b1001;       // 9
    parameter   JEX      =   4'b1010;       // 10
    parameter   ANDIEX   =   4'b1011;       // 11
    parameter   ANDIWR   =   4'b1100;       // 12
    
    parameter   LW       =   6'b100011;
    parameter   SW       =   6'b101011;
    parameter   RTYPE    =   6'b000000;
    parameter   BEQ      =   6'b000100;
    parameter   J        =   6'b000010;
    parameter   ANDI     =   6'b001100;
    
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
                            RTYPE:      nextstate   <=  RTYPEEX;
                            BEQ:        nextstate   <=  BEQEX;
                            J:          nextstate   <=  JEX;
                            ANDI:       nextstate   <=  ANDIEX;
                            default:    nextstate   <=  FETCH;  // control never reach here
                        endcase
            MEMADR:     case (op)
                            LW:         nextstate   <=  LWRD;
                            SW:         nextstate   <=  SWWR;
                            default:    nextstate   <=  FETCH;  // control never reach here
                        endcase
            LWRD:       nextstate   <=  LWWR;
            LWWR:       nextstate   <=  FETCH;
            SWWR:       nextstate   <=  FETCH;
            RTYPEEX:    nextstate   <=  RTYPEWR;
            RTYPEWR:    nextstate   <=  FETCH;
            BEQEX:      nextstate   <=  FETCH;
            JEX:        nextstate   <=  FETCH;
            ANDIEX:     nextstate   <=  ANDIWR;
            ANDIWR:     nextstate   <=  FETCH;
            default:    nextstate   <=  FETCH;  // control never reach here
        endcase
    end
    
    // send control signal
    always @(*) begin
        // initial signal outputs
        irwrite     <=  0;
        pcwrite     <=  0;          pcwritecond     <=  0;
        regwrite    <=  0;          regdst          <=  0;
        memread     <=  0;          memwrite        <=  0;
        alusrca     <=  0;          alusrcb         <=  3'b000;
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
                alusrca     <=  1;      // choose register A
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
               alusrca      <=  1;      // choose register A and B(default)
               aluop        <=  2'b10;  // RTYPE: utilize funct
            end
            
            RTYPEWR: begin
                regdst      <=  1;      // choose register rt
                regwrite    <=  1;
            end
            
            BEQEX: begin
                alusrca     <=  1;
                aluop       <=  2'b01;
                pcwritecond <=  1;
                pcsource    <=  2'b01;  // beq offset+pc already in aluout
            end
            
            JEX: begin
                pcwrite     <=  1;
                pcsource    <=  2'b10;  // choose j target
            end
            
            ANDIEX: begin
                alusrca     <=  1;
                alusrcb     <=  3'b100;
                aluop       <=  2'b11;
            end
            
            ANDIWR: begin
                regwrite    <=  1;
            end
        endcase
    end
 
    // PC enable
    assign pcen = pcwrite | (pcwritecond & zero);   
    
endmodule
