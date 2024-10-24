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
                  input wire aluJump,
                  input wire jump,                //
                  input wire setIf,               //
                  input wire [2:0]brControl,
                  input wire [1:0]setControl,      // ..
                  input wire [15:0]imm11_ext,     // ..
                  input wire [15:0]imm8_ext,      // ----------------------------------------
                  input wire [15:0]read2Data,
                  input wire BTR_cs,
                  input wire STU,
                  input wire LBI,
                  output wire [15:0] next_pc,
                  output wire [15:0]aluOut,
                  output wire [15:0]outData,
                  output wire [15:0]specOps);

   // TODO: branch logic
   wire ZF, SF, OF, CF, brSel, brOrJmp;

   assign brOrJmp = brSel | jump;

   branch_cmd BRANCHCOMMAND(.brControl(brControl), .ZF(ZF), .SF(SF), .brSel(brSel));


   alu ALU( .InA(aluA), .InB(aluB), .Cin(cin), .Oper(aluOp), .invA(invA), 
            .invB(invB), .sign(1'b1), .Out(aluOut), .Ofl(OF), .Zero(ZF), .SF(SF), .CF(CF));

   // TODO: set if equal/less than/produce carry out logic -> mux with alu out based on setIf control sig
   wire [15:0]BTR, SLBI; 
   assign SLBI = {aluA[7:0], imm8_ext[7:0]}; 
   assign BTR = { aluA[0], aluA[1], aluA[2], aluA[3], aluA[4], aluA[5], aluA[6], aluA[7],
            aluA[8], aluA[9], aluA[10], aluA[11], aluA[12], aluA[13], aluA[14], aluA[15]};

   wire [15:0] specOut;
   assign specOut = (LBI) ? imm8_ext : 
                    (BTR_cs) ? BTR : SLBI;

   assign outData = (STU) ? read2Data : aluB; 

   assign specOps = (setIf) ? 
                           (setControl == 2'b00) ? 
                                 (ZF) ? 16'h0001 : 16'h0000 :
                           (setControl == 2'b01) ? 
                                 (SF) ? 16'h0001 : 16'h0000 :
                           (setControl == 2'b10) ? 
                                 (SF | ZF) ? 16'h0001 : 16'h0000 :
                           (CF) ? 
                                 16'h0001 : 16'h0000 
                     : specOut;

   // JmpSrc Mux
   wire [15:0]JmpSrc;
   // assign JmpSrc = (immSrc) ? imm8_ext : {imm11_ext[15:1], 1'b0};
   assign JmpSrc = (immSrc) ? imm8_ext : imm11_ext;


   // JmpSel Mux
   wire [15:0]JmpVal;
   alu ADDER(.InA(PC), .InB(JmpSrc), .Cin(1'b0), .Oper(3'b000), .invA(1'b0), .invB(1'b0), .sign(1'b0), .Out(JmpVal), .Ofl(), .Zero(), .SF(), .CF());

   wire [15:0]BrVal;

   assign BrVal = (brOrJmp) ? JmpVal : PC;   

   // brOrJmp Mux
   assign next_pc = (aluJump) ? aluOut : BrVal;

endmodule
`default_nettype wire