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
                  input wire [1:0]setControl,     // ..
                  input wire [15:0]imm11_ext,     // ..
                  input wire [15:0]imm8_ext,      // ----------------------------------------
                  input wire [15:0]read2Data,
                  input wire BTR_cs,
                  input wire STU,
                  input wire LBI,
                  input wire forward_XX_A,
                  input wire forward_XX_B,
                  input wire forward_XM_A, 
                  input wire forward_XM_B,
                  input wire [1:0]forward_XX_sel, 
                  input wire [1:0]forward_XM_sel,
                  input wire [15:0]XM_specOps,
                  input wire [15:0]XM_pc_inc,
                  input wire [15:0]XM_aluOut,
                  input wire [15:0]MW_specOps,
                  input wire [15:0]MW_pc_inc,
                  input wire [15:0]MW_readMemData,
                  input wire [15:0]MW_aluOut,
                  input wire XM_flush, input wire MW_flush,
                  output wire [15:0]next_pc,
                  output wire [15:0]aluOut,
                  output wire [15:0]outData,
                  output wire [15:0]specOps,
                  output wire flush);

      // TODO: branch logic
      wire ZF, SF, OF, CF, brSel, brOrJmp;

      // TODO

      assign flush = aluJump | brOrJmp;

      wire [15:0] final_A, final_B, final_read2Data;

      assign brOrJmp = brSel | jump;

      branch_cmd BRANCHCOMMAND(.brControl(brControl), .ZF(ZF), .SF(SF), .brSel(brSel));

      alu ALU( .InA(final_A), .InB(final_B), .Cin(cin), .Oper(aluOp), .invA(invA), 
            .invB(invB), .sign(1'b1), .Out(aluOut), .Ofl(OF), .Zero(ZF), .SF(SF), .CF(CF));

      // TODO: set if equal/less than/produce carry out logic -> mux with alu out based on setIf control sig
      wire [15:0]BTR, SLBI; 
      assign SLBI = {final_A[7:0], imm8_ext[7:0]}; 
      assign BTR = { final_A[0], final_A[1], final_A[2], final_A[3], final_A[4], final_A[5], final_A[6], final_A[7],
            final_A[8], final_A[9], final_A[10], final_A[11], final_A[12], final_A[13], final_A[14], final_A[15]};

      wire [15:0] specOut;
      assign specOut = (LBI) ? imm8_ext : 
                        (BTR_cs) ? BTR : SLBI;

      assign outData = (STU) ? final_read2Data : final_B; 

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

      // 4 : 1 for XX FWD?
      wire [15:0]XX_SEL_VAL;
      assign XX_SEL_VAL =     (forward_XX_sel == 2'b00) ? XM_specOps :
                              (forward_XX_sel == 2'b01) ? XM_pc_inc :
                              (forward_XX_sel == 2'b11) ? XM_aluOut :
                              16'b0000;

      // 4 : 1 for XM FWD?
      wire [15:0]XM_SEL_VAL;
      assign XM_SEL_VAL =     (forward_XM_sel == 2'b00) ? MW_specOps :
                              (forward_XM_sel == 2'b01) ? MW_pc_inc :
                              (forward_XM_sel == 2'b10) ? MW_readMemData :
                              MW_aluOut;




      // // 2 : 1 for XX A
      // wire [15:0]XX_FWD_A;
      // assign XX_FWD_A = forward_XX_A ?  XX_SEL_VAL : aluA;

      // // 2 : 1 for XM A
      // assign final_A = forward_XM_A ?  XM_SEL_VAL : XX_FWD_A;

      // 2 : 1 for XX A
      wire [15:0]XM_FWD_A;
      assign XM_FWD_A = forward_XM_A ? XM_SEL_VAL : aluA;

      // 2 : 1 for XM A
      assign final_A = forward_XX_A ? XX_SEL_VAL : XM_FWD_A;


      // // 2 : 1 for XX B
      // wire [15:0]XX_FWD_B;
      // assign XX_FWD_B = forward_XX_B ?  XX_SEL_VAL : aluB;

      // // 2 : 1 for XM B
      // assign final_B = forward_XM_B ?  XM_SEL_VAL : XX_FWD_B;

      // 2 : 1 for XX B
      wire [15:0]XM_FWD_B;
      assign XM_FWD_B = forward_XM_B & ~STU ?  XM_SEL_VAL : aluB;

      // 2 : 1 for XM B
      assign final_B = forward_XX_B & ~STU ?  XX_SEL_VAL : XM_FWD_B;




      // This mux setup is XX/XM for read2Data (STU)

      // // 2 : 1 for XX B
      // wire [15:0]XX_FWD_read2Data;
      // assign XX_FWD_read2Data = forward_XX_B ?  XX_SEL_VAL : read2Data;

      // // 2 : 1 for XM B
      // assign final_read2Data = forward_XM_B ?  XM_SEL_VAL : XX_FWD_read2Data;

      // 2 : 1 for XX B
      wire [15:0]XM_FWD_read2Data;
      assign XM_FWD_read2Data = forward_XM_B ?  XM_SEL_VAL : read2Data;

      // 2 : 1 for XM B
      assign final_read2Data = forward_XX_B ?  XX_SEL_VAL : XM_FWD_read2Data;




endmodule
`default_nettype wire