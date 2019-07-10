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
    input              clk,
    input     [15:0]   sw,
    input              PS2Clk, PS2Data,
    output    [15:0]   led
    );
    wire     reset;
    assign   reset = sw[15];
    
    wire memread, memwrite;
    wire [ADR_WIDTH-1 : 0] adr;
    wire [WIDTH-1 : 0] memdata, writedata;
    wire               keyboard_valid;
    wire  [7:0]        keyboard_data;
    
    // instantiate mips cpu core
    mips #(ADR_WIDTH, WIDTH, REGBITS) cpu(clk, reset, memdata,
                                          memread, memwrite, adr, writedata);
    
    // external memory for code, data and IO devices
    exmemory #(ADR_WIDTH, WIDTH) exmem(clk, sw, memread, memwrite, adr, writedata, keyboard_data,
                                       keyboard_valid,
                                       led, memdata);
    
    // I/O device interface
    keyboard keyboard(clk, PS2Clk, PS2Data, keyboard_valid, keyboard_data);
    
endmodule