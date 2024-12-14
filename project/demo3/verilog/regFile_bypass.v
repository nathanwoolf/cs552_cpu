/*
   CS/ECE 552, Fall '22
   Homework #3, Problem #2
  
   This module creates a wrapper around the 8x16b register file, to do
   do the bypassing logic for RF bypassing.
*/
module regFile_bypass #(
   parameter N = 16
) (
   // Outputs
   read1Data, read2Data, err,
   // Inputs
   clk, rst, read1RegSel, read2RegSel, writeRegSel, writeData, writeEn
   );

   input        clk, rst;
   input [2:0]  read1RegSel;
   input [2:0]  read2RegSel;
   input [2:0]  writeRegSel;
   input [15:0] writeData;
   input        writeEn;

   output [15:0] read1Data;
   output [15:0] read2Data;
   output        err;

   wire [N-1:0] internalRead1Data, internalRead2Data;

   regFile #(.WIDTH(N)) reg_file (
      .read1Data(internalRead1Data),
      .read2Data(internalRead2Data),
      .err(err),
      .clk(clk),
      .rst(rst),
      .read1RegSel(read1RegSel),
      .read2RegSel(read2RegSel),
      .writeRegSel(writeRegSel),
      .writeData(writeData),
      .writeEn(writeEn)
   );

    // Bypass logic for read1Data
    assign read1Data = (writeEn & (writeRegSel == read1RegSel)) ? writeData : internalRead1Data;

    // Bypass logic for read2Data
    assign read2Data = (writeEn & (writeRegSel == read2RegSel)) ? writeData : internalRead2Data;

endmodule
