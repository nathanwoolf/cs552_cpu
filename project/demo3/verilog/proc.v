/* $Author: sinclair $ */
/* $LastChangedDate: 2020-02-09 17:03:45 -0600 (Sun, 09 Feb 2020) $ */
/* $Rev: 46 $ */
`default_nettype none
module proc (/*AUTOARG*/
   // Outputs
   err, 
   // Inputs
   clk, rst
   );

   input wire clk;
   input wire rst;

   output reg err;

   // None of the above lines can be modified

   // OR all the err ouputs for every sub-module and assign it as this
   // err output
   
   // As desribed in the homeworks, use the err signal to trap corner
   // cases that you think are illegal in your statemachines
   
   /* your code here -- should include instantiations of fetch, decode, execute, mem and wb modules */

   /* README
    * Matthew - propogate regDest, regWrite, and writeData through all flops, come out of wb and into FD latch
    *
    */
   wire [1:0]regDest;
   // ---------- fetch I/O ----------
   wire halt, valid, NOP;  
   wire [15:0] instr,
               next_instr,  
               next_pc,
               pc_inc;
   
   // ---------- decode I/O ----------

   //  ---------- DX_ latch singals ----------  
   wire FD_valid;
   wire [15:0] FD_instr, 
               FD_pc_inc;

   // control signals used outside of DECODE stage
   wire [1:0]  regSrc,
               setControl;
   wire        memWrite,
               memRead, 
               aluJump,
               jump, 
               immSrc, 
               invA, 
               invB, 
               cin, 
               STU, 
               BTR, 
               LBI,
               setIf,
               regWrite;
   wire [2:0]  brControl, 
               aluOp,
               writeReg;
   wire [15:0] aluA, 
               aluB, 
               imm11_ext, 
               imm8_ext, 
               read2Data;

   //  ---------- DX_ latch singals ----------  

   // control signals used outside of DECODE stage
   wire [1:0]  DX_regSrc,
               DX_setControl;
   wire        DX_memWrite,
               DX_memRead, 
               DX_aluJump,
               DX_jump, 
               DX_immSrc, 
               DX_invA, 
               DX_invB, 
               DX_cin, 
               DX_STU, 
               DX_BTR, 
               DX_LBI,
               DX_setIf,
               DX_regWrite, 
               DX_halt;
   wire [2:0]  DX_brControl, 
               DX_aluOp,
               DX_writeReg;
   wire [15:0] DX_aluA, 
               DX_aluB, 
               DX_imm11_ext, 
               DX_imm8_ext, 
               DX_read2Data,
               DX_pc_inc,
               DX_instr;    

   // ---------- execute I/O ----------
   wire [15:0] aluOut, 
               writeData, 
               specOps, 
               outData;

   //  ---------- XM_ latch singals ---------- 
   wire [15:0] XM_aluOut, 
               XM_specOps, 
               XM_writeData,      //turns into writeData in WB
               XM_next_pc, 
               XM_pc_inc,
               XM_instr;    
   wire        XM_memWrite, 
               XM_memRead,
               XM_regWrite,
               XM_jump,
               XM_br,
               XM_halt;
   wire [1:0]  XM_regSrc;
   wire [2:0]  XM_writeReg;

   // ---------- memory I/O ----------
   wire [15:0] readData;

   //  ---------- MW_ latch singals ---------- 
   wire        MW_regWrite,
               MW_br,
               MW_jump,
               MW_halt;
   wire [1:0]  MW_regSrc;
   wire [2:0]  MW_writeReg;
   wire [15:0] MW_next_pc, 
               MW_pc_inc,
               MW_readMemData, 
               MW_aluOut,
               MW_specOps;

   // instantiate fetch module
   fetch FETCH(.clk(clk), .rst(rst), .halt(MW_halt), 
               .branch_or_jump(MW_br | MW_jump),
               .NOP(NOP),
               .PC(MW_next_pc), // TODO is this correct stage of next_pc?
               .pc_plus_two(pc_inc),
               .pc_inc(pc_inc), 
               .instr(instr),
               .valid(valid), 
               .err());

   hazard_unit HAZARD(
      .instr(instr),
      .FD_instr(FD_instr),
      .FD_writeReg(writeReg),
      .DX_writeReg(DX_writeReg),
      .XM_writeReg(XM_writeReg),
      .regDest(regDest),
      .FD_regWrite(regWrite),
      .DX_regWrite(DX_regWrite),
      .XM_regWrite(XM_regWrite),
      .FD_br_or_j(brControl[2] | jump),
      .DX_br_or_j(DX_brControl[2] | DX_jump),
      .XM_br_or_j(XM_br | XM_jump), // TODO
      .MW_br_or_j(MW_br | MW_jump), // TODO
      .next_instr(next_instr),
      .NOP(NOP)
    ); 

   FD_pipe FD_PIPELINE(.clk(clk), .rst(rst), 
               .instr(next_instr), .FD_instr(FD_instr), 
               .pc_inc(pc_inc), .FD_pc_inc(FD_pc_inc),
               .valid(valid), .FD_valid(FD_valid));

   decode DECODE( .clk(clk), .rst(rst), 
                  .instr(FD_instr), 
                  .writeData(writeData),
                  .MW_regWrite(MW_regWrite),
                  .MW_writeReg(MW_writeReg),  //END INPUTS
                  .memWrite(memWrite), 
                  .memRead(memRead), 
                  .aluJump(aluJump), 
                  .immSrc(immSrc), 
                  .brControl(brControl), 
                  .regSrc(regSrc),    
                  .aluOp(aluOp), 
                  .invA(invA), 
                  .invB(invB), 
                  .cin(cin), 
                  .STU(STU), 
                  .BTR(BTR), 
                  .LBI(LBI), 
                  .setIf(setIf), 
                  .aluA(aluA), 
                  .aluB(aluB), 
                  .imm11_ext(imm11_ext), 
                  .imm8_ext(imm8_ext),                                    
                  .read2Data(read2Data), 
                  .halt(halt), 
                  .setControl(setControl), 
                  .jump(jump),
                  .regWrite(regWrite), 
                  .writeReg(writeReg),
                  .valid(FD_valid),
                  .regDest(regDest));  

   DX_pipe DX_pipeline(.clk(clk), .rst(rst), 
               .FD_instr(FD_instr), .DX_instr(DX_instr),
               .pc_inc(FD_pc_inc), .DX_pc_inc(DX_pc_inc),
               .memWrite(memWrite), .DX_memWrite(DX_memWrite),
               .memRead(memRead), .DX_memRead(DX_memRead), 
               .regSrc(regSrc), .DX_regSrc(DX_regSrc), 
               .aluJump(aluJump), .DX_aluJump(DX_aluJump), 
               .jump(jump), .DX_jump(DX_jump), 
               .immSrc(immSrc), .DX_immSrc(DX_immSrc),
               .brControl(brControl), .DX_brControl(DX_brControl), 
               .setControl(setControl), .DX_setControl(DX_setControl), 
               .aluOp(aluOp), .DX_aluOp(DX_aluOp), 
               .invA(invA), .DX_invA(DX_invA), 
               .invB(invB), .DX_invB(DX_invB), 
               .cin(cin), .DX_cin(DX_cin), 
               .STU(STU), .DX_STU(DX_STU), 
               .BTR(BTR), .DX_BTR(DX_BTR), 
               .LBI(LBI), .DX_LBI(DX_LBI), 
               .setIf(setIf), .DX_setIf(DX_setIf), 
               .aluA(aluA), .DX_aluA(DX_aluA), 
               .aluB(aluB), .DX_aluB(DX_aluB), 
               .imm11_ext(imm11_ext), .DX_imm11_ext(DX_imm11_ext), 
               .imm8_ext(imm8_ext), .DX_imm8_ext(DX_imm8_ext), 
               .read2Data(read2Data), .DX_read2Data(DX_read2Data),
               .regWrite(regWrite), .DX_regWrite(DX_regWrite),
               .writeReg(writeReg), .DX_writeReg(DX_writeReg),
               .halt(halt), .DX_halt(DX_halt));                                   

   execute EXECUTE( .clk(clk), .rst(rst), 
                     .PC(DX_pc_inc), 
                     .aluA(DX_aluA), 
                     .aluB(DX_aluB), 
                     .invA(DX_invA), 
                     .invB(DX_invB), 
                     .cin(DX_cin), 
                     .aluOp(DX_aluOp), 
                     .immSrc(DX_immSrc), 
                     .aluJump(DX_aluJump), 
                     .setIf(DX_setIf), 
                     .imm11_ext(DX_imm11_ext), 
                     .imm8_ext(DX_imm8_ext), 
                     .read2Data(DX_read2Data), 
                     .BTR_cs(DX_BTR), 
                     .STU(DX_STU), 
                     .LBI(DX_LBI), 
                     .jump(DX_jump),                //END INPUTS
                     .next_pc(next_pc), 
                     .aluOut(aluOut), 
                     .outData(outData), 
                     .specOps(specOps), 
                     .brControl(DX_brControl), 
                     .setControl(DX_setControl));

   XM_pipe XM_PIPELINE(.clk(clk), .rst(rst), 
               .DX_instr(DX_instr), .XM_instr(XM_instr),
               .next_pc(next_pc), .XM_next_pc(XM_next_pc), 
               .pc_inc(DX_pc_inc), .XM_pc_inc(XM_pc_inc),
               .aluOut(aluOut), .XM_aluOut(XM_aluOut), 
               .outData(outData), .XM_writeData(XM_writeData), 
               .specOps(specOps), .XM_specOps(XM_specOps),
               .DX_memWrite(DX_memWrite), .XM_memWrite(XM_memWrite), 
               .DX_memRead(DX_memRead), .XM_memRead(XM_memRead), 
               .DX_regSrc(DX_regSrc), .XM_regSrc(XM_regSrc),
               .DX_regWrite(DX_regWrite), .XM_regWrite(XM_regWrite),
               .DX_writeReg(DX_writeReg), .XM_writeReg(XM_writeReg),
               .DX_jump(DX_jump), .XM_jump(XM_jump),
               .DX_br(DX_brControl[2]), .XM_br(XM_br),
               .DX_halt(DX_halt), .XM_halt(XM_halt));

   memory MEMORY( .clk(clk), .rst(rst), 
                  .memWrite(XM_memWrite), 
                  .memRead(XM_memRead), 
                  .aluOut(XM_aluOut), 
                  .writeData(XM_writeData), 
                  .halt(MW_halt),                  //END INPUTS
                  .readData(readData));   

   MW_pipe MW_PIPELINE(.clk(clk), .rst(rst), 
               .readData(readData), .MW_readMemData(MW_readMemData), 
               .XM_regSrc(XM_regSrc), .MW_regSrc(MW_regSrc), 
               .XM_aluOut(XM_aluOut), .MW_aluOut(MW_aluOut), 
               .XM_specOps(XM_specOps), .MW_specOps(MW_specOps), 
               .XM_next_pc(XM_next_pc), .MW_next_pc(MW_next_pc), 
               .XM_pc_inc(XM_pc_inc), .MW_pc_inc(MW_pc_inc),
               .XM_regWrite(XM_regWrite), .MW_regWrite(MW_regWrite),
               .XM_writeReg(XM_writeReg), .MW_writeReg(MW_writeReg),
               .XM_jump(XM_jump), .MW_jump(MW_jump),
               .XM_br(XM_br), .MW_br(MW_br),
               .XM_halt(XM_halt), .MW_halt(MW_halt));   

   wb WRITEBACK(  .regSrc(MW_regSrc), 
                  .PC(MW_pc_inc), 
                  .readData(MW_readMemData), 
                  .aluOut(MW_aluOut), 
                  .specOps(MW_specOps),              //END INPUTS
                  .writeData(writeData));


endmodule // proc
`default_nettype wire
// DUMMY LINE FOR REV CONTROL :0:
