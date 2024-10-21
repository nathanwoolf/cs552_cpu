/*
   CS/ECE 552 Spring '22
  
   Filename        : fetch.v
   Description     : This is the module for the overall fetch stage of the processor.
*/
`default_nettype none
module fetch ( input clk, 
               input rst, 
               input halt, 
               input [15:0]   pc, 
               output [15:0]  next_pc, 
               output reg [15:0]  instr, 
               output err);

   // TODO: Your code here
   wire sum_cout;
   wire halt_dff;
   wire [15:0]instr_fetch;

   // create latch for halt signal 
   // -> will take in halt from control block and latch it internally
   dff HALT(.q(halt_dff), .d(halt), .clk(clk), .rst(rst));

   //want to use a latch for the pc to hold value
   wire pc_latch;           
   register PC(.clk(clk), .rst(rst), .data_in(pc), .data_out(pc_latch), .write_en(1'b1), .err(err));

   //increment pc by two
   cla_16b ADDTWO(.sum(next_pc), .c_out(sum_cout), .a(pc_latch), .b(16'h0002), .c_in(1'b0));

   // instantiate program memory given to us in memeory2c.v
   // high level description: 
   //    read the instruction at pc to inst_fetch
   //    use halt bit to enable/dump memory file
   //    hard code write to zero (were only reading here)
   memeory2c instruction_mem(.data_out(instr_fetch), .data_in(16'b0), .addr(pc_latch), .enable(~halt_dff), .wr(1'b0), .createdump(halt_dff), .clk(clk), .rst(rst)); 

   assign instr = (halt_dff) ? 16'h0000 : instr_fetch;
   
endmodule
`default_nettype wire
