`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/06 10:01:25
// Design Name: 
// Module Name: datapath
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


module datapath #(parameter ADR_WIDTH = 16, WIDTH = 32, REGBITS = 5) (
    input                           clk, reset,
    input   [WIDTH-1 : 0]           memdata,
    input                           memtoreg, iord, pcen,
    input                           regwrite, 
    input   [1:0]                   regdst, pcsource, alusrca,
    input   [2:0]                   alusrcb,
    input                           irwrite,
    input   [3:0]                   alucont,
    output                          zero,
    output  [31:0]                  instr,
    output  [ADR_WIDTH-1 : 0]       adr,
    output  [WIDTH-1 : 0]           writedata   // represent b at the same time
    );
    
    // const parameter
    localparam CONST_ZERO = 32'b0000;
    localparam CONST_FOUR = 32'b0100;
    localparam CONST_EIGH = 32'b1000;
    localparam ADR_ZERO   = 5'b00000;   // address of register $zero
    localparam ADR_RA     = 5'b11111;   // address of register $ra
    
    wire    [REGBITS-1 : 0]    ra1, ra2, wa;
    wire    [WIDTH-1   : 0]    md, rd1, rd2, wd, a, src1, src2, aluresult, aluout;
    wire    [15        : 0]    offset;
    wire    [WIDTH-1   : 0]    offset32, offset32x, offset32x2, jpc;
    wire    [WIDTH-1   : 0]    shamt32;
    wire    [WIDTH-1   : 0]    pc, nextpc;
    
    // shamt
    assign shamt32    = {24'h000000, 3'b000, instr[10:6]};
    
    // offset extended to 32bit
    assign offset     = instr[15:0];
    assign offset32   = {16'h0000, offset};                                            // no   sign, no shift, for reg
    assign offset32x  = {offset[15] ? 16'hffff : 16'h0000, offset};                    // with sign, no shift, for reg
    assign offset32x2 = {offset[15] ? {12'hfff, 2'b11} : {14'b0}, offset, 2'b00};      // with sign, shifted,  for pc                   
    
    // shift target by 2
    assign jpc = {pc[31:28], instr[25:0], 2'b00};
    
    // register file address fields
    assign ra1 = instr[REGBITS+20 : 21];    // register rs address
    assign ra2 = instr[REGBITS+15 : 16];    // register rt address
    // choose write register address (rt, rd, or $ra)
    mux4    #(REGBITS)          regwritemux(ra2, instr[REGBITS+10 : 11], ADR_RA, ADR_ZERO,
                                            regdst,
                                            wa);   
    
    // ir, load and store instructions
    flopen  #(WIDTH)            ir(clk, irwrite, memdata, instr);
    
    // other datapath
    flopenr #(WIDTH)            pcreg(clk, reset, pcen, nextpc, pc);
    flop    #(WIDTH)            mdr(clk, memdata, md);
    flop    #(WIDTH)            areg(clk, rd1, a);
    flop    #(WIDTH)            wrd(clk, rd2, writedata);       // same as breg
    flop    #(WIDTH)            res(clk, aluresult, aluout);
    
    // split parameters into 3 lines: input, control, output
    mux2    #(ADR_WIDTH)        adrmux(pc[ADR_WIDTH-1:0], aluout[ADR_WIDTH-1:0],
                                       iord, 
                                       adr);
    mux4    #(WIDTH)            src1mux(pc, a, shamt32, CONST_ZERO, 
                                        alusrca, 
                                        src1);
    mux8    #(WIDTH)            src2mux(writedata, CONST_FOUR, offset32x, offset32x2, 
                                        offset32, CONST_EIGH, CONST_ZERO, CONST_ZERO,
                                        alusrcb, 
                                        src2);
    mux4    #(WIDTH)            pcmux(aluresult, aluout, jpc, a,
                                      pcsource,
                                      nextpc);
    mux2    #(WIDTH)            wdmux(aluout, md,
                                      memtoreg,
                                      wd);
    
    regfile #(WIDTH, REGBITS)   rf(clk, regwrite,
                                   ra1, ra2, wa,
                                   wd, rd1, rd2);
    
    alu     #(WIDTH)            alunit(src1, src2, alucont, aluresult);
    zerodetect
            #(WIDTH)            zd(aluresult, zero);

endmodule
