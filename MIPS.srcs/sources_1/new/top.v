`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/05 15:38:00
// Design Name: 
// Module Name: top
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


module top #(parameter ADR_WIDTH = 16, WIDTH = 32, REGBITS = 5) (
    
    );
    reg clk;
    reg reset;
    
    wire memread, memwrite;
    wire [ADR_WIDTH-1 : 0] adr;
    wire [WIDTH-1 : 0] memdata, writedata;
    
    // instantiate mips cpu core
    mips #(ADR_WIDTH, WIDTH, REGBITS) cpu(clk, reset, memdata,
                                            memread, memwrite, adr, writedata);
    
    // external memory for code, data and IO devices
    exmemory #(ADR_WIDTH, WIDTH) exmem(clk, memread, memwrite, adr, writedata,
                                        memdata);
    
    // test bench
    localparam PERIOD = 20;
    
    initial begin
        clk = 1;
        reset = 1;
        #(5);
        reset = 0;
        #(PERIOD * 100) $stop;
    end
    
    always begin
        #(PERIOD / 2) clk = ~clk;
    end
    
endmodule