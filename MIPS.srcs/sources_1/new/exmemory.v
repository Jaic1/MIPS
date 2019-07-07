`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/05 15:40:08
// Design Name: 
// Module Name: exmemory
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


module exmemory #(parameter ADR_WIDTH = 16, WIDTH = 32) (
    input clk,
    input memread, memwrite,
    input [ADR_WIDTH-1 : 0] adr,
    input [WIDTH-1 : 0] writedata,
    output reg [WIDTH-1 : 0] memdata
    );
    
    reg  [WIDTH-1 : 0]  RAM[(1 << (ADR_WIDTH-2)) - 1 : 0];
    wire [WIDTH-1 : 0]  word;
    
    initial 
    begin
        $readmemh("memfile.mem", RAM);
    end
    
    // read or write bytes using big endian
    always @(posedge clk)
        if(memwrite) begin
            RAM[adr>>2] <= writedata;        
        end
                
    assign word = RAM[adr>>2];
    always @(*)
        memdata <= word;
    
endmodule
