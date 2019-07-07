`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/06 17:04:38
// Design Name: 
// Module Name: flopen
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


module flopen #(parameter WIDTH = 32) (
    input                     clk, en,
    input       [WIDTH-1:0]   d,
    output reg  [WIDTH-1:0]   q
    );
    
    always @(posedge clk)
        if (en) q <= d;
endmodule
