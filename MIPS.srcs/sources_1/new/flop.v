`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/06 16:53:36
// Design Name: 
// Module Name: flop
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


module flop #(parameter WIDTH = 32) (
    input                     clk,
    input       [WIDTH-1:0]   d,
    output reg  [WIDTH-1:0]   q
    );
    
    always @(posedge clk)
        q <= d;
endmodule
