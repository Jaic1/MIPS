`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/06 15:08:13
// Design Name: 
// Module Name: alucontrol
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


module alucontrol(
    input       [1:0]       aluop,
    input       [5:0]       funct,
    output reg  [2:0]       alucont
    );
    
    always @(*)
        case (aluop)
            2'b00: alucont  <=  3'b010;             // add for lw, sw
            2'b01: alucont  <=  3'b110;             // sub for beq
            2'b10:
                case (funct)                        // RTYPE instructions
                    6'b100000: alucont  <=  3'b010; // add
                    6'b100010: alucont  <=  3'b110; // sub    
                    6'b100100: alucont  <=  3'b000; // AND
                    6'b100101: alucont  <=  3'b001; // OR
                    6'b101010: alucont  <=  3'b111; // slt
                    default:   alucont  <=  3'b101; // control never reach here
                 endcase
            2'b11: alucont  <=  3'b000;             // AND for andi
        endcase
endmodule
