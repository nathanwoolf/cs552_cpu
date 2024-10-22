/*
   CS/ECE 552 Spring '22
  
   Filename        : fetch.v
   Description     : This is the module for the overall fetch stage of the processor.
*/
`default_nettype none
module fetch ( input wire clk, 
               input wire rst, 
               input wire halt, 
               input wire [15:0]  PC, 
               output wire [15:0]  next_pc, 
               output wire [15:0]  instr, 
               output wire err);

   // TODO: Your code here
   wire sum_cout;

   // create latch for halt signal 
   // -> will take in halt from control block and latch it internally
   // TODO ask Nathan about halt flop
   //dff HALT(.q(halt_dff), .d(halt), .clk(clk), .rst(rst));

   //want to use a latch for the pc to hold value
   wire [15:0]pc_latch;
   register PCBLOCK(.clk(clk), .rst(rst), .data_in(PC), .data_out(pc_latch), .write_en(1'b1), .err(err));

   //increment pc by two
   cla_16b ADDTWO(.sum(next_pc), .c_out(sum_cout), .a(pc_latch), .b(16'h0002), .c_in(1'b0)); // TODO c_out is err?

   // instantiate program memory given to us in memory2c.v
   // high level description: 
   //    read the instruction at pc to inst_fetch
   //    use halt bit to enable/dump memory file
   //    hard code write to zero (were only reading here)
   memory2c instruction_mem(.data_out(instr), .data_in(16'b0), .addr(pc_latch), .enable(~halt), .wr(1'b0), .createdump(halt), .clk(clk), .rst(rst)); 

   
endmodule
`default_nettype wire
