`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/07 10:50:16
// Design Name: 
// Module Name: alu
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


module alu #(parameter WIDTH = 32) (
    input       [WIDTH-1:0]     a, b,
    input       [2      :0]     alucont,
    output reg  [WIDTH-1:0]     result
    );
    
    wire    [WIDTH-1:0]     b2, sum, slt;
    
    assign  b2  =   alucont[2] ? ~b : b;
    assign  sum =   a + b2 + alucont[2];
    assign  slt =   sum[WIDTH-1];
    
    always @(*)
        case (alucont[1:0])
            2'b00: result <= a & b;
            2'b01: result <= a | b;
            2'b10: result <= sum;
            2'b11: result <= slt;
        endcase
endmodule
