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
    * take regSrc as an example: 
    *    produced in decode and isnt consumed until Writeback
    *    we will need the following signals: DX_regSrc, XM_regSrc,  MW_regSrc
    * 
    * Latch singals should be the inputs to each ff stage
    * 
    * TODO: may be able to omit original intermediate singals??
    *
    */
   
   // ---------- fetch I/O ----------
   wire halt;  
   wire [15:0] instr,  
               next_pc,
               pc_inc;

   //  ---------- FD_ latch singals ----------
   wire [15:0] FD_instr, 
               FD_next_pc, 
               FD_pc_inc;
   
   // ---------- decode I/O ----------
   wire [1:0]  r_typeALU;

   // control signals used outside of DECODE stage
   wire [1:0]  aluSrc, 
               regSrc,
               setControl;
   wire        zeroExt, 
               regWrite, 
               regDest, 
               memWrite,
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
   wire [1:0]  DX_aluSrc, 
               DX_regSrc,
               DX_setControl;
   wire        DX_zeroExt, 
               DX_regWrite, 
               DX_regDest, 
               DX_memWrite,
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
               DX_read2Data;    

   //propogate pc related signals
   wire [15:0] DX_instr, 
               DX_next_pc, 
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
               XM_outData;       //turns into writeData in WB

   //propogate pc related signals
   wire [15:0] XM_instr, 
               XM_next_pc, 
               XM_pc_inc;    
   wire        XM_memWrite, 
               XM_memRead, 
               XM_halt;
               
   wire [1:0]  XM_regSrc;

   // ---------- memory I/O ----------
   wire [15:0] readData;
   wire [15:0] specOps;

   //  ---------- MW_ latch singals ---------- 
   wire [1:0]  MW_regSrc;
   wire [15:0] MW_PC, 
               MW_readData, 
               MW_aluOut,
               MW_specOps, 
               MW_writeData; 

   //propogate pc related signals
   wire [15:0] MW_instr, 
               MW_next_pc, 
               MW_pc_inc;    

   // instantiate fetch module
   fetch FETCH(.clk(clk), .rst(rst), .halt(halt), 
               .PC(next_pc), 
               .pc_inc(pc_inc), 
               .instr(instr), 
               .err());

   //latch signal from fetch to decode are the denoted by "FD_"

   decode DECODE( .clk(clk), .rst(rst), 
                  .instr(instr), 
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

   execute EXECUTE( .clk(clk), .rst(rst), 
                     .PC(pc_inc), 
                     .aluA(aluA), 
                     .aluB(aluB), 
                     .invA(invA), 
                     .invB(invB), 
                     .cin(cin), 
                     .aluOp(aluOp), 
                     .immSrc(immSrc), 
                     .aluJump(aluJump), 
                     .setIf(setIf), 
                     .imm11_ext(imm11_ext), 
                     .imm8_ext(imm8_ext), 
                     .read2Data(read2Data), 
                     .BTR_cs(BTR), 
                     .STU(STU), 
                     .LBI(LBI),                 //END INPUTS
                     .next_pc(next_pc), 
                     .aluOut(aluOut), 
                     .outData(outData), 
                     .specOps(specOps), 
                     .brControl(brControl), 
                     .setControl(setControl), 
                     .jump(jump));

   memory MEMORY( .clk(clk), .rst(rst), 
                  .memWrite(memWrite), 
                  .memRead(memRead), 
                  .aluOut(aluOut), 
                  .writeData(outData), 
                  .halt(halt),                  //END INPUTS
                  .readData(readData));      

   wb WRITEBACK(  .regSrc(regSrc), 
                  .PC(pc_inc), 
                  .readData(readData), 
                  .aluOut(aluOut), 
                  .specOps(specOps),              //END INPUTS
                  .writeData(writeData));

endmodule // proc
`default_nettype wire
// DUMMY LINE FOR REV CONTROL :0: