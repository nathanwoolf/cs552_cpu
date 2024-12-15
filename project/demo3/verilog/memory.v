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
               input wire memRead,
               input wire [15:0]aluOut,
               input wire [15:0]writeData,
               input wire halt,
               input wire memAccess,
               input wire MW_align_err_m,
               output wire [15:0]readData,
               output wire align_err_m);

   // TODO We do not use memRead currently.


   wire enable;
   // assign enable = ~halt & memAccess & ~MW_align_err_m;
   assign enable = ~halt;

   memory2c instruction_mem( .data_out(readData), .data_in(writeData), .addr(aluOut), 
                              .enable(enable), .wr(memWrite), .createdump(halt), 
                              .clk(clk), .rst(rst));

   // memory2c_align instruction_mem( .data_out(readData), .data_in(writeData), .addr(aluOut), 
   //                            .enable(enable), .wr(memWrite), .createdump(halt | MW_align_err_m), 
   //                            .clk(clk), .rst(rst), .err(align_err_m));

   // stallmem instruction_mem( .data_out(readData), .data_in(writeData), .addr(aluOut), 
   //                            .enable(enable), .wr(memWrite), .createdump(halt | MW_align_err_m), 
   //                            .clk(clk), .rst(rst));


endmodule
`default_nettype wire