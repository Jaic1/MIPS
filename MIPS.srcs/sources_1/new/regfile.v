`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/07 10:50:16
// Design Name: 
// Module Name: regfile
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


module regfile #(parameter WIDTH = 32, REGBITS = 5) (
    input                   clk,
    input                   regwrite,
    input   [REGBITS-1:0]   ra1, ra2, wa,
    input   [WIDTH-1  :0]   wd,
    output  [WIDTH-1  :0]   rd1, rd2
    );
    
    reg     [WIDTH-1  :0]   RAM[(1<<REGBITS)-1 : 0];
    
    // 3-ported register file
    // read two ports combinationally
    // write third port on rising edge of clock
    // register 0 hardwired to 0
    always @(posedge clk)
        if (regwrite) RAM[wa] <= wd;
        
    assign rd1 = ra1 ? RAM[ra1] : 0;
    assign rd2 = ra2 ? RAM[ra2] : 0;
    
endmodule
