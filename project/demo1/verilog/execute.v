/*
   CS/ECE 552 Spring '22
  
   Filename        : execute.v
   Description     : This is the overall module for the execute stage of the processor.
*/
`default_nettype none
module execute (  input [15:0]aluA, 
                  input [15:0]aluB, 
                  input invA, 
                  input invB, 
                  input cin, 
                  input [2:0]aluOp, 
                  output [15:0]aluOut,
                  output [15:0]writeData, 
                  );

   // TODO: branch logic

   // TODO: set if equal/less than/produce carry out logic -> mux with alu out based on setIf control sig
   
endmodule
`default_nettype wire
