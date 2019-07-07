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
    input       [3      :0]     alucont,
    output reg  [WIDTH-1:0]     result
    );
    
    wire    [WIDTH-1:0]     b2, sum, slt;
    wire    [2      :0]     alucontx;
    
    assign  b2  =   alucont[2] ? ~b : b;
    assign  sum =   a + b2 + alucont[2];
    assign  slt =   sum[WIDTH-1];
    
    assign  alucontx = {alucont[3], alucont[1:0]};
    
    always @(*)
        case (alucontx)
            3'b000: result <= a & b;
            3'b001: result <= a | b;
            3'b010: result <= sum;
            3'b011: result <= slt;
            3'b100: result <= b << a;       // sll
            3'b101: result <= b >> a;       // srl
            default:    result <= 32'b0;    // control never reach here
        endcase
endmodule
