/*
   CS/ECE 552 Spring '22
  
   Filename        : wb.v
   Description     : This is the module for the overall Write Back stage of the processor.
*/
`default_nettype none
module wb (  input wire [1:0]regSrc,
             input wire [15:0]PC,
             input wire [15:0]readData,
             input wire [15:0]aluOut,
             input wire [15:0]specOps,
             output wire [15:0]writeData);

   // 4:1 Mux selecting write back data
   mux4_1_16b WRITEBACK(.sel(regSrc), .inp0(PC), .inp1(readData), .inp2(aluOut), .inp3(specOps), .out(writeData));

endmodule
`default_nettype wire