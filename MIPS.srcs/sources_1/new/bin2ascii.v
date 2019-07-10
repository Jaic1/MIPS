`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/09 16:19:43
// Design Name: 
// Module Name: bin2ascii
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


module bin2ascii (
    input      [7:0]   I,
    output reg [7:0]   O
    );
    
    always @(I)
        case (I)
            8'h1c: O <= 8'h61;      //  a
            8'h32: O <= 8'h62;      //  b
            8'h21: O <= 8'h63;      //  c
            8'h23: O <= 8'h64;      //  d
            8'h24: O <= 8'h65;      //  e
            8'h2b: O <= 8'h66;      //  f
            8'h34: O <= 8'h67;      //  g
            8'h33: O <= 8'h68;      //  h
            8'h43: O <= 8'h69;      //  i
            8'h3b: O <= 8'h6a;      //  j
            8'h42: O <= 8'h6b;      //  k
            8'h4b: O <= 8'h6c;      //  l
            8'h3a: O <= 8'h6d;      //  m
            8'h31: O <= 8'h6e;      //  n
            8'h44: O <= 8'h6f;      //  o
            8'h4d: O <= 8'h70;      //  p
            8'h15: O <= 8'h71;      //  q
            8'h2d: O <= 8'h72;      //  r
            8'h1b: O <= 8'h73;      //  s
            8'h2c: O <= 8'h74;      //  t
            8'h3c: O <= 8'h75;      //  u
            8'h2a: O <= 8'h76;      //  v
            8'h1d: O <= 8'h77;      //  w
            8'h22: O <= 8'h78;      //  x
            8'h35: O <= 8'h79;      //  y
            8'h1a: O <= 8'h7a;      //  z
            
            8'h45: O <= 8'h30;      //  0
            8'h16: O <= 8'h31;      //  1
            8'h1e: O <= 8'h32;      //  2
            8'h26: O <= 8'h33;      //  3
            8'h25: O <= 8'h34;      //  4
            8'h2e: O <= 8'h35;      //  5
            8'h36: O <= 8'h36;      //  6
            8'h3d: O <= 8'h37;      //  7
            8'h3e: O <= 8'h38;      //  8
            8'h46: O <= 8'h39;      //  9
            default: O <= 8'h00;    // default
        endcase
endmodule
