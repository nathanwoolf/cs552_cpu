/*
   CS/ECE 552 Spring '22
  
   Filename        : wb.v
   Description     : This is the module for the overall Write Back stage of the processor.
*/
`default_nettype none
module wb (  input regSrc,
             input [15:0]PC,
             input [15:0]readData,
             input [15:0]aluOut,
             input [15:0]specOpsOut,
             output [15:0]writeData);

   // 4:1 Mux selecting write back data
   mux4_1_16b ALUSOURCE(.sel(regSrc), .inp0(PC), .inp1(readData), .inp2(aluOut), .inp3(specOpsOut), .out(writeData));

endmodule
`default_nettype wire
