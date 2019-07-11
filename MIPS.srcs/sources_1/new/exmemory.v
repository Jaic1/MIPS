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
    input      [WIDTH-1     : 0]  writedata,
    input                         keyboardvalid,
    output                        cpuvalid,
    input      [7           : 0]  ckdata,
    output     [15          : 0]  led,
    output reg [WIDTH-1     : 0]  memdata
    );
    
    reg  [WIDTH-1 : 0]      ROM[1023:0];
    reg  [WIDTH-1 : 0]      RAM[1023:0];
    reg  [WIDTH-1 : 0]      IOR;
    reg  [WIDTH-1 : 0]      IOW[2:0];
    wire [ADR_WIDTH-1 : 0]  adrword;
    assign adrword = adr >> 2;
    
    // initialize ROM    
    initial 
    begin
        $readmemh("memfile.dat", ROM);
    end
    
    // read or write bytes using big endian
    always @(posedge clk)
        if(memwrite)
            if(adrword < 1024) ROM[adrword] <= writedata;
            else if (adrword < 2048) RAM[adrword-1024] <= writedata;
            else if (adrword >= 16380 && adrword < 16384)
                case (adrword - 16380)
                    0: IOW[0] <= writedata;
                    1: IOW[1] <= writedata;
                    2: IOW[2] <= writedata;
                    default: ;
                endcase
                
    always @(*)
        if(adrword < 1024) memdata <= ROM[adrword];
        else if (adrword < 2048) memdata <= RAM[adrword-1024];
        else if (adrword >= 16380 && adrword < 16384)
            case (adrword - 16380)
                3: memdata <= IOR;
                default: ;
            endcase 
    
    // bind I/O ports
    // sw
    always @(posedge clk)
        IOR[15:0] <= sw[15:0];           // 0xfffd, 0xfffc - sw[15:0]
    
    // led
    assign led[15:0] = IOW[0][15:0];     // 0xfff1, 0xfff0 - led[15:0]    
    
    // keyboard
    assign cpuvalid = IOW[1][0];

    always @(keyboardvalid)
        IOR[24] <= keyboardvalid;
    
    always @(ckdata)
        IOR[23:16] <= ckdata;
        
endmodule
