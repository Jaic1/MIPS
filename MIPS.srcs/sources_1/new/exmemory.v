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
    input                         clk,
    input      [15:0]             sw,
    input                         memread, memwrite,
    input      [ADR_WIDTH-1 : 0]  adr,
    input      [WIDTH-1 : 0]      writedata,
    input      [7:0]              keyboard_data,
    inout                         keyboard_valid,
    output     [15:0]             led,
    output reg [WIDTH-1 : 0]      memdata
    );
    
    reg  [WIDTH-1 : 0]  RAM[(1 << (ADR_WIDTH-2)) - 1 : 0];
    wire [WIDTH-1 : 0]  word;
    
    // initialize ROM    
    initial 
    begin
        $readmemh("memfile.mem", RAM);
    end
    
    // bind I/O ports
    // sw
    always @(sw)
        begin
            RAM[16383][15:8] <= sw[15:8];     // 0xfffd - sw[15:8]
            RAM[16383][7:0]  <= sw[7:0];      // 0xfffc - sw[7:0]
        end
    
    // led
    assign led[15:8] = RAM[16380][15:8];      // 0xfff1 - led[15:8]    
    assign led[7:0]  = RAM[16380][7:0];       // 0xfff0 - led[7:0]
    
    // keyboard
    reg    keyboard_valid_tri = 0, keyboard_edge = 1;
    assign keyboard_valid = keyboard_valid_tri ? RAM[16383][24] : 1'bz;
    always @(posedge clk)
        if (keyboard_valid == 1'b1 && RAM[16383][24] == 1'b0)
            if (keyboard_edge == 1'b1) begin
                keyboard_edge  <= 1'b0;
                RAM[16383][24] <= 1'b1;
            end else begin
                keyboard_valid_tri <= 1'b1;
                keyboard_edge <= 1'b1;
            end
        else
            keyboard_valid_tri <= 1'b0;
            
    always @(keyboard_data)
        RAM[16383][23:16] <= keyboard_data;    // 0xfffe - keyboard_data in ascii form
    
    
    // read or write bytes using big endian
    always @(posedge clk)
        if(memwrite) begin
            RAM[adr>>2] <= writedata;        
        end
                
    assign word = RAM[adr>>2];
    always @(*)
        memdata <= word;
    
endmodule
