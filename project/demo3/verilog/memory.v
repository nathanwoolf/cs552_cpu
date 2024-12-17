/*
   CS/ECE 552 Spring '22
  
   Filename        : memory.v
   Description     : This module contains all components in the Memory stage of the 
                     processor.
*/
`default_nettype none
module memory (input wire clk,
               input wire rst,
               input wire stall,
               input wire memWrite,
               input wire memRead,
               input wire [15:0]aluOut,
               input wire [15:0]writeData,
               input wire halt,
               input wire memAccess,
               output wire [15:0]readData, 
               output wire stall_m,
               output wire align_err_m);

   wire enable;
   // assign enable = ~halt & memAccess & ~MW_align_err_m;
//    assign enable = ~halt & ~stall & (memAccess);
   assign enable = memAccess & ~stall & ~halt;

//    memory2c data_mem( .data_out(readData), .data_in(writeData), .addr(aluOut), 
//                               .enable(enable), .wr(memWrite), .createdump(halt), 
//                               .clk(clk), .rst(rst));

//    memory2c_align data_mem( .data_out(readData), .data_in(writeData), .addr(aluOut), 
//                               .enable(enable), .wr(memWrite), .createdump(halt), 
//                               .clk(clk), .rst(rst), .err(align_err_m));
 
   // stallmem data_mem(.DataOut(readData), .Done(done), .Stall(stall_m), .CacheHit(CacheHit), .DataIn(writeData), .Addr(aluOut), 
                              // .Wr(memWrite), .Rd(memRead), .createdump(halt), .clk(clk), .rst(rst), .err()); 

    wire done, CacheHit;

    mem_system data_mem(.DataOut(readData), .Done(done), .Stall(stall_m), .CacheHit(CacheHit), .DataIn(writeData), .Addr(aluOut), 
                              .Wr(memWrite), .Rd(memRead & ~halt), .createdump(halt), .clk(clk), .rst(rst), .err(align_err_m)); 

endmodule
`default_nettype wire