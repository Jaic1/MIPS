`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/06 09:21:30
// Design Name: 
// Module Name: mips
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


module mips #(parameter ADR_WIDTH = 16, WIDTH = 32, REGBITS = 5) (
    input                       clk, reset,
    input [WIDTH-1 : 0]         memdata,
    output                      memread, memwrite,
    output [ADR_WIDTH-1 : 0]    adr,
    output [WIDTH-1 : 0]        writedata
    );
    
    // data modified: irwrite
    wire irwrite;
    wire zero, memtoreg, iord, pcen, regwrite, regdst;
    wire [1:0] aluop, pcsource, alusrca;
    wire [2:0] alusrcb;
    wire [3:0] alucont;
    wire [WIDTH-1:0] instr;
    
    controller cont(clk, reset, instr[31:26], instr[5:0], zero,
                    memread, memwrite, memtoreg, iord,
                    pcen,
                    regwrite, regdst,
                    pcsource, aluop, alusrca,
                    alusrcb,
                    irwrite);
                    
    alucontrol ac(aluop, instr[5:0], alucont);
    
    datapath #(ADR_WIDTH, WIDTH, REGBITS) dp(
                clk, reset,
                memdata, 
                memtoreg, iord, pcen,
                regwrite, regdst, 
                pcsource, alusrca, 
                alusrcb, 
                irwrite, 
                alucont, 
                zero, 
                instr, 
                adr, 
                writedata);
    
endmodule
