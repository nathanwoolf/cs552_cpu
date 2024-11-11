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
    * 
    * Piping rule of thumb: every cpu block (F D X M W) should have its inputs and 
    * outputs contained in a latch at some point
    * 
    * if, say, an output from decode is not consumed until W, that signal MUST  
    * propogate through each intermediate latch 
    * 
    * prepend the transisition to singal name e.g. FD_ for latch between fetch and decode
    *
    * each stage should should hold the outputs from the first letter and then inputs to the second 
    * 
    * take regSrc as an example: 
    *    produced in decode and isnt consumed until Writeback
    *    we will need the following signals: DX_regSrc, XM_regSrc,  MW_regSrc
    * 
    * Latch singals should be the inputs to each ff stage
    * 
    * TODO: what the fuck do we do with regDest? does this need to go through all flops - add as IO to decode?
    *
    */
   
   // ---------- fetch I/O ----------
   wire halt;  
   wire [15:0] instr,  
               next_pc,
               pc_inc;
   
   // ---------- decode I/O ----------
   wire [1:0]  r_typeALU;

   //  ---------- DX_ latch singals ----------  
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
               setIf;
   wire [2:0]  brControl, 
               aluOp;
   wire [15:0] aluA, 
               aluB, 
               imm11_ext, 
               imm8_ext, 
               read2Data;

   //  ---------- DX_ latch singals ----------  
   wire [1:0]  DX_r_typeALU;

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
               DX_setIf;
   wire [2:0]  DX_brControl, 
               DX_aluOp;
   wire [15:0] DX_aluA, 
               DX_aluB, 
               DX_imm11_ext, 
               DX_imm8_ext, 
               DX_read2Data,
               DX_instr, 
               DX_pc_inc;    

   // ---------- execute I/O ----------
   wire [15:0] aluOut, 
               writeData, 
               specOps, 
               outData;

   //  ---------- XM_ latch singals ---------- 
   wire [15:0] XM_aluOut, 
               XM_writeData, 
               XM_specOps, 
               XM_writeData,      //turns into writeData in WB
               XM_next_pc, 
               XM_pc_inc;    
   wire        XM_memWrite, 
               XM_memRead, 
   wire [1:0]  XM_regSrc;

   // ---------- memory I/O ----------
   wire [15:0] readData;
   wire [15:0] specOps;

   //  ---------- MW_ latch singals ---------- 
   wire [1:0]  MW_regSrc;
   wire [15:0] MW_next_pc, 
               MW_pc_inc,
               MW_readMemData, 
               MW_aluOut,
               MW_specOps, 

   // instantiate fetch module
   fetch FETCH(.clk(clk), .rst(rst), .halt(halt), 
               .PC(next_pc), 
               .pc_inc(pc_inc), 
               .instr(instr), 
               .err());

   FD_pipe FD_PIPELINE(.clk(clk), .rst(rst), .
               .instr(instr), .FD_instr(FD_instr), 
               .pc_inc(pc_inc), .FD_pc_inc(FD_pc_inc));

   //latch signal from fetch to decode are the denoted by "FD_"

   decode DECODE( .clk(clk), .rst(rst), 
                  .instr(FD_instr), 
                  .writeData(writeData),  //END INPUTS
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
                  .jump(jump));  

   DX_pipe DX_pipeline(.clk(clk), .rst(rst), 
               .FD_instr(FD_instr), .DX_instr(DX_instr),
               .pc_inc(pc_inc), .DX_pc_inc(DX_pc_inc),
               .memWrite(memWrite), .DX_memWrite(DX_memWrite),
               .memRead(memRead), .DX_memRead(memRead), 
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
               .setIf(setIF), .DX_setIf(DX_setIF), 
               .aluA(aluA), .DX_aluA(DX_aluA), 
               .aluB(aluB), .DX_aluB(DX_aluB), 
               .imm11_ext(imm11_ext), .DX_imm11_ext(DX_imm11_ext), 
               .imm8_ext(imm8_ext), .DX_imm8_ext(DX_imm8_ext), 
               .read2Data(read2Data), .DX_read2Data(DX_read2Data));                                   

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
                     .LBI(DX_LBI),                 //END INPUTS
                     .next_pc(DX_next_pc), 
                     .aluOut(DX_aluOut), 
                     .outData(DX_outData), 
                     .specOps(DX_specOps), 
                     .brControl(DX_brControl), 
                     .setControl(DX_setControl), 
                     .jump(DX_jump));

   XM_pipe XM_PIPELINE(.clk(clk), .rst(rst), 
               .next_pc(next_pc), .XM_next_pc(XM_next_pc), 
               .pc_inc(pc_inc), .DX_pc_inc(DX_px_inc),
               .aluOut(aluOut), .XM_aluOut(XM_aluOut), 
               .outData(outData), .XM_writeData(XM_writeData), 
               .specOps(specOps), .XM_specOps(XM_specOps),
               .DX_memWrite(DX_memWrite), .XM_memWrite(XM_memWrite), 
               .DX_memRead(DX_memRead), .XM_memRead(XM_memRead), 
               .DX_regSrc(DX_regSrc), .XM_regSrc(XM_regSrc));

   memory MEMORY( .clk(clk), .rst(rst), 
                  .memWrite(XM_memWrite), 
                  .memRead(XM_memRead), 
                  .aluOut(XM_aluOut), 
                  .writeData(XM_writeData), 
                  .halt(halt),                  //END INPUTS
                  .readData(readData));   

   MW_pipe MW_PIPELINE(.clk(clk), .rst(rst), 
               .readData(readData), .MW_readData(MW_readMemData), 
               .XM_regSrc(XM_regSrc), .MW_regSrc(MW_regSrc), 
               .XM_aluOut(XM_aluOut), .MW_aluOut(MW_aluOut), 
               .XM_specOps(XM_specOps), .MW_specOps(MW_specOps), 
               .XM_next_pc(XM_next_pc), .MW_next_pc(MW_next_pc), 
               .XM_pc_inc(XM_pc_inc), .MW_pc_inc(MW_pc_inc));   

   wb WRITEBACK(  .regSrc(MW_regSrc), 
                  .PC(MW_pc_inc), 
                  .readData(MW_readMemData), 
                  .aluOut(MW_aluOut), 
                  .specOps(MW_specOps),              //END INPUTS
                  .writeData(writeData));

endmodule // proc
`default_nettype wire
// DUMMY LINE FOR REV CONTROL :0:
