/*
   CS/ECE 552 Spring '22
  
   Filename        : decode.v
   Description     : This is the module for the overall decode stage of the processor.
*/
`default_nettype none
module decode (input clk, 
               input rst, 
               input [15:0]instr, 
               output aluSrc, 
               output zeroExt, 
               output memToReg, 
               output regWrite, 
               output memRead, 
               output memWrite, 
               output jump, 
               output immSource, 
               output [2:0]aluOp, 
               output invA, 
               output invB, 
               output cin, 
               output brControl); 

   // TODO: Your code here
   
   // control module signals
   wire [1:0]aluSrc;
   wire zeroExt; 
   wire memToReg;
   wire regWrite; 
   wire memRead; 
   wire memWrite;
   wire jump; 
   wire immSource; 
   wire [2:0]aluOp; 
   wire invA; 
   wire invB; 
   wire cin; 
   wire [1:0]brControl; 
   
   // instatiate control module
   control CONTROLSIGS(.opcode(instr[15:11]), )

endmodule
`default_nettype wire
