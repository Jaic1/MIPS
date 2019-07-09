`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/09 16:15:15
// Design Name: 
// Module Name: keyboard
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


module keyboard(
    input              clk,
    input              PS2Clk,
    input              PS2Data,
    inout              cpuvalid,
    output reg  [7:0]  cpudata
    );
    reg         cpuvalid_tri = 0;
    assign      cpuvalid = cpuvalid_tri ? 1'b1 : 1'bz;
    wire        valid;
    assign      valid = cpuvalid;
    
    reg         CLK50MHZ = 0;
    reg         releasex = 0;
    
    wire        flag;
    wire [15:0] keycode;
    wire [7:0]  asciicode;       
    
    always @(posedge clk)
        CLK50MHZ <= ~CLK50MHZ;
    
    PS2Receiver uut (
        .clk     (CLK50MHZ),
        .kclk    (PS2Clk),
        .kdata   (PS2Data),
        .keycode (keycode),
        .oflag   (flag)
    );
    
    bin2ascii conv (.I(keycode[7:0]), .O(asciicode));
    
    // check if there is F0, once keycode is updated
    always @(keycode)
        begin
            if (keycode[15:8] == 8'hf0)
                releasex <= 1'b1;
            else
                releasex <= 1'b0;
        end
        
    always @(posedge clk)
        begin
        if (flag == 1'b1 && releasex == 1'b1 && valid == 1'b0)
            begin
                cpuvalid_tri   <=  1'b1;
                cpudata        <=  asciicode;
            end
        else
            cpuvalid_tri <= 1'b0;
        end
        
endmodule
