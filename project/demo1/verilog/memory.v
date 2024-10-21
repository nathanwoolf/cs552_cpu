/*
   CS/ECE 552 Spring '22
  
   Filename        : memory.v
   Description     : This module contains all components in the Memory stage of the 
                     processor.
*/
`default_nettype none
module memory (input clk,
               input rst,
               input memWrt,
               input [15:0]aluOut,
               input [15:0]writeData,
               output [15:0]readData);

   // TODO enable vs wr? what do we do here?
   memeory2c instruction_mem( .data_out(readData), .data_in(writeData), .addr(aluOut), 
                              .enable(1'b0), .wr(memWrt), .createdump(halt_dff), 
                              .clk(clk), .rst(rst)); 


endmodule
`default_nettype wire
