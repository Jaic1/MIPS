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
    output reg  [3:0]       alucont
    );
    
    always @(*)
        case (aluop)
            2'b00: alucont  <=  4'b0010;             // add for lw, sw
            2'b01: alucont  <=  4'b0110;             // sub for beq
            2'b10:
                case (funct)                        // RTYPE instructions
                    6'b100000: alucont  <=  4'b0010; // add
                    6'b100010: alucont  <=  4'b0110; // sub    
                    6'b100100: alucont  <=  4'b0000; // AND
                    6'b100101: alucont  <=  4'b0001; // OR
                    6'b101010: alucont  <=  4'b0111; // slt
                    6'b000000: alucont  <=  4'b1000; // sll
                    6'b000010: alucont  <=  4'b1001; // srl
                    default:   alucont  <=  4'b0101; // control never reach here
                 endcase
            2'b11: alucont  <=  4'b0000;             // AND for andi
        endcase
endmodule
