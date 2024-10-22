/*
   CS/ECE 552 Spring '22
  
   Filename        : execute.v
   Description     : This is the overall module for the execute stage of the processor.
*/
`default_nettype none
module execute (  input clk,
                  input rst,
                  input [15:0]PC,            // pc for branch calcs
                  input [15:0]aluA,          // --------------- alu sigs ---------------
                  input [15:0]aluB,          // ..
                  input invA,                // ..
                  input invB,                // ..
                  input cin,                 // ..
                  input [2:0]aluOp,          // ----------------------------------------
                  input immSrc,              // -------------- br/jmp sigs -------------
                  input jump,                //
                  input [2:0]brControl,      // ..
                  input [15:0]imm11_ext,     // ..
                  input [15:0]imm8_ext,      // ----------------------------------------
                  input [15:0]read2Data;
                  input BTR_cs,
                  input STU,
                  output [15:0] next_pc,
                  output [15:0]aluOut,
                  output [15:0]writeData,
                  output [15:0]specOps,      // SLBI/BTR signal for regSrc mux 
                  output [15:0]calcPC);

   // TODO: branch logic
   wire ZF, SF, OF, CF, brSel;

   branch_cmd BRANCHCOMMAND(.brControl(brControl), .ZF(ZF), .SF(SF), .OF(OF),  .CF(CF), .brSel(brSel));


   alu ALU( .inA(aluA), .inB(aluB), .Cin(cin), .Oper(aluOp), .invA(invA), 
            .invB(invB), .sign(1'b1), .Out(aluOut), .Ofl(OF), .Zero(ZF));

   // TODO: set if equal/less than/produce carry out logic -> mux with alu out based on setIf control sig
   wire [15:0]BTR, SLBI; 
   BTR = {aluA[7:0], imm8_ext[7:0]}; 
   SLBI = { aluA[0], aluA[1], aluA[2], aluA[3], aluA[4], aluA[5], aluA[6], aluA[6], aluA[7],
            aluA[8], aluA[9] aluA[10], aluA[11], aluA[12], aluA[13], aluA[14], aluA[15]};

   specOps = (BTR_cs) ? BTR : SLBI;

   writeData = (STU) ? read2Data : aluB; 

   // JmpSrc Mux
   wire [15:0]JmpSrc;
   assign JmpSrc = (immSrc) ? imm8_ext : {imm11_ext[14:0], 1'b0};


   // JmpSel Mux
   wire [15:0]JmpVal;
   alu ADDER(.inA(PC), .inB(JmpSrc), .Cin(1'b0), .Oper(3'b000), .invA(1'b0), .invB(1'b0), .sign(1'b0), .Out(jmpVal), .Ofl(), .Zero());

   assign JmpSel = (jump) ? JmpVal : PC;   

   // BrSel Mux
   assign next_pc = (brSel) ? aluOut : JmpSel;







endmodule
`default_nettype wire
