/*
   CS/ECE 552 Spring '22
  
   Filename        : execute.v
   Description     : This is the overall module for the execute stage of the processor.
*/
`default_nettype none
module execute (  input [15:0]PC,            // pc for branch calcs
                  input [15:0]aluA,          // --------------- alu sigs ---------------
                  input [15:0]aluB,          // ..
                  input invA,                // ..
                  input invB,                // ..
                  input cin,                 // ..
                  input [2:0]aluOp,          // ----------------------------------------
                  input immSrc,              // -------------- br/jmp sigs -------------
                  input jump,                // ..
                  input [15:0]imm11_ext,     // ..
                  input [15:0]imm8_ext,      // ----------------------------------------
                  output [15:0]aluOut,
                  output [15:0]writeData,
                  output [15:0]specOps,      // SLBI/BTR signal for regSrc mux 
                  output [15:0]calcPC);

   // TODO: branch logic
   wire ZF, SF, OF, CF;

   branch_cmd BRANCHCOMMAND(.brControl(), .ZF(ZF), .SF(SF), .OF(),  .CF(CF), .brSel());


   alu ALU(.inA(aluA), .inB(aluB), .Cin(cin), .Oper(aluOp), .invA(invA), .invB(invB), .sign(1'b1), .Out(aluOut), .Ofl(OF), .Zero(ZF));






   // TODO: set if equal/less than/produce carry out logic -> mux with alu out based on setIf control sig














endmodule
`default_nettype wire
