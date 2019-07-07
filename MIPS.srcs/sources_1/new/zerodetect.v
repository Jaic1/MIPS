`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/07 10:50:16
// Design Name: 
// Module Name: zerodetect
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


module zerodetect #(parameter WIDTH = 32) (
    input   [WIDTH-1:0]     a,
    output                  y
    );
    
    assign  y = (a == 0);
    
endmodule
