/*
   CS/ECE 552 Spring '22
  
   Filename        : execute.v
   Description     : This is the overall module for the execute stage of the processor.
*/
`default_nettype none
module execute (  input wire clk,
                  input wire rst,
                  input wire [15:0]PC,            // pc for branch calcs
                  input wire [15:0]aluA,          // --------------- alu sigs ---------------
                  input wire [15:0]aluB,          // ..
                  input wire invA,                // ..
                  input wire invB,                // ..
                  input wire cin,                 // ..
                  input wire [2:0]aluOp,          // ----------------------------------------
                  input wire immSrc,              // -------------- br/jmp sigs -------------
                  input wire jump,                //
                  input wire [2:0]brControl,      // ..
                  input wire [15:0]imm11_ext,     // ..
                  input wire [15:0]imm8_ext,      // ----------------------------------------
                  input wire [15:0]read2Data,
                  input wire BTR_cs,
                  input wire STU,
                  input wire LBI,
                  output wire [15:0] next_pc,
                  output wire [15:0]aluOut,
                  output wire [15:0]writeData,
                  output wire [15:0]specOps);

   // TODO: branch logic
   wire ZF, SF, OF, CF, brSel;

   branch_cmd BRANCHCOMMAND(.brControl(brControl), .ZF(ZF), .SF(SF), .OF(OF),  .CF(CF), .brSel(brSel));


   alu ALU( .InA(aluA), .InB(aluB), .Cin(cin), .Oper(aluOp), .invA(invA), 
            .invB(invB), .sign(1'b1), .Out(aluOut), .Ofl(OF), .Zero(ZF));

   // TODO: set if equal/less than/produce carry out logic -> mux with alu out based on setIf control sig
   wire [15:0]BTR, SLBI; 
   assign BTR = {aluA[7:0], imm8_ext[7:0]}; 
   assign SLBI = { aluA[0], aluA[1], aluA[2], aluA[3], aluA[4], aluA[5], aluA[6], aluA[6], aluA[7],
            aluA[8], aluA[9], aluA[10], aluA[11], aluA[12], aluA[13], aluA[14], aluA[15]};

   assign specOps = (LBI) ? imm8_ext : 
                    (BTR_cs) ? BTR : SLBI;

   assign writeData = (STU) ? read2Data : aluB; 

   // JmpSrc Mux
   wire [15:0]JmpSrc;
   assign JmpSrc = (immSrc) ? imm8_ext : {imm11_ext[14:0], 1'b0};


   // JmpSel Mux
   wire [15:0]JmpVal;
   alu ADDER(.InA(PC), .InB(JmpSrc), .Cin(1'b0), .Oper(3'b000), .invA(1'b0), .invB(1'b0), .sign(1'b0), .Out(JmpVal), .Ofl(), .Zero());

   wire [15:0]JmpSel;

   assign JmpSel = (jump) ? JmpVal : PC;   

   // BrSel Mux
   assign next_pc = (brSel) ? aluOut : JmpSel;







endmodule
`default_nettype wire
