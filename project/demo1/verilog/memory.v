/*
   CS/ECE 552 Spring '22
  
   Filename        : memory.v
   Description     : This module contains all components in the Memory stage of the 
                     processor.
*/
`default_nettype none
module memory (input wire clk,
               input wire rst,
               input wire memWrite,
               input wire [15:0]aluResult,
               input wire [15:0]writeData,
               output wire [15:0]readData);

   // TODO enable vs wr? what do we do here?
   memory2c instruction_mem( .data_out(readData), .data_in(writeData), .addr(aluResult), 
                              .enable(1'b0), .wr(memWrite), .createdump(1'b0), 
                              .clk(clk), .rst(rst)); 


endmodule
`default_nettype wire
