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
   
   // ---------- fetch I/O ----------
   wire halt;  
   wire [15:0] instr, 
               PC, 
               next_pc;
   
   // ---------- decode I/O ----------
   wire [4:0]  opcode; 
   wire [1:0]  r_typeALU;

   // control signals used outside of DECODE stage
   wire [1:0]  aluSrc, 
               regSrc;
   wire        zeroExt, 
               regWrite, 
               regDest, 
               memWrite, 
               jump, 
               immSrc, 
               invA, 
               invB, 
               cin, 
               STU, 
               BTR, 
               setIf;
   wire [2:0]  brControl, 
               aluOp;
   wire [15:0] aluA, 
               aluB, 
               imm11_ext, 
               imm8_ext, 
               read2Data;

   // ---------- execute I/O ----------
   wire [15:0]aluOut, writeData, secOps;
   wire BTR_cs;

   // ---------- memory I/O ----------
   wire [15:0]readData;


   wire [15:0] specOps;

   // instantiate fetch module
   fetch fetch0(.clk(clk), .rst(rst), .halt(halt), .PC(PC), .next_pc(next_pc), 
               .instr(instr), .err(err));

   decode decode0( .clk(clk), .rst(rst), .instr(instr), .writeData(writeData), 
                  .memWrite(memWrite), .jump(jump), .immSrc(immSrc), .brControl(brControl), 
                  .aluOp(aluOp), .invA(invA), .invB(invB), .cin(cin), .BTR(BTR), .setIf(setIf), 
                  .aluA(aluA), .aluB(aluB), .imm11_ext(imm11_ext), .imm8_ext(imm8_ext), 
                  .read2Data(read2Data)); 

   execute execute0( .clk(clk), .rst(rst), .PC(PC), .aluA(aluA), .aluB(aluB), 
                     .invA(invA), .invB(invB), .cin(cin), .aluOp(aluOp), .immSrc(immSrc), 
                     .jump(jump), .imm11_ext(imm11_ext), .imm8_ext(imm8_ext), 
                     .read2Data(read2Data), .BTR_cs(BTR_cs), .STU(STU), .next_pc(next_pc), .aluOut(aluOut), 
                     .writeData(writeData), .specOps(specOps), .brControl(brControl));

   memory memory0( .clk(clk), .rst(rst), .memWrite(memWrite), .aluResult(aluOut), .writeData(writeData), .readData(readData));

   wb writeback0( .regSrc(regSrc), .PC(PC), .readData(readData), .aluOut(aluOut), .specOps(specOps), .writeData(writeData));

   
endmodule // proc
`default_nettype wire
// DUMMY LINE FOR REV CONTROL :0:
