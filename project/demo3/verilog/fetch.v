/*
   CS/ECE 552 Spring '22
  
   Filename        : fetch.v
   Description     : This is the module for the overall fetch stage of the processor.
*/
`default_nettype none
module fetch ( input wire clk, 
               input wire rst, 
               input wire halt, 
               input wire branch_or_jump,
               input wire NOP,
               input wire [15:0]PC, 
               input wire [15:0]pc_plus_two,
               input wire MW_align_err_m,
               output wire [15:0]pc_inc, 
               output wire [15:0]instr,
               output wire valid, 
               output wire err,
               output wire align_err_i);

   // TODO: Your code here

   wire [15:0]sel_PC;
   // input PC
   assign sel_PC = branch_or_jump ? PC : pc_plus_two;

   //want to use a latch for the pc to hold value
   wire [15:0]pc_latch;
   register PCBLOCK(.clk(clk), .rst(rst), .data_in(sel_PC), .data_out(pc_latch), .write_en(~halt & ~(NOP ^ branch_or_jump)), .err(err));   //TODO what to do with 

   //increment pc by two
   wire sum_cout;
   cla_16b ADDTWO(.sum(pc_inc), .c_out(sum_cout), .a(pc_latch), .b(16'h0002), .c_in(1'b0)); // TODO c_out is err?

   // instantiate program memory given to us in memory2c.v
   // high level description: 
   //    read the instruction at pc to inst_fetch
   //    use halt bit to enable/dump memory file
   //    hard code write to zero (were only reading here)
   memory2c_align instruction_mem(.data_out(instr), .data_in(16'b0), .addr(pc_latch), .enable(1'b1), .wr(1'b0), .createdump(halt | MW_align_err_m), .clk(clk), .rst(rst), .err(align_err_i)); 

   assign valid = 1'b1;
   
endmodule
`default_nettype wire
