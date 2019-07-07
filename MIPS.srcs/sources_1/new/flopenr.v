`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/06 17:04:38
// Design Name: 
// Module Name: flopenr
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


module flopenr #(parameter WIDTH = 32) (
    input                     clk, reset, en,
    input       [WIDTH-1:0]   d,
    output reg  [WIDTH-1:0]   q
    );
    
    always @(posedge clk)
        if (reset)      q <= 0;
        else if (en)    q <= d;
endmodule
