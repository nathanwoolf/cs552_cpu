/*
   CS/ECE 552 Spring '22
  
   Filename        : decode.v
   Description     : This is the module for the overall decode stage of the processor.
*/
`default_nettype none
module decode (input wire clk, 
               input wire rst, 
               input wire [15:0]instr,
               input wire [15:0]writeData,
               input wire MW_regWrite,
               input wire [2:0]MW_writeReg,  
               input wire valid,
               output wire memWrite,
               output wire memRead,       
               output wire [1:0]regSrc,    
               output wire aluJump,               // branch half of execute
               output wire jump,
               output wire immSrc,             // to go to branch part of execute
               output wire [2:0]brControl,
               output wire [1:0]setControl,
               output wire [2:0]aluOp, 
               output wire invA, 
               output wire invB, 
               output wire cin,
               output wire STU,
               output wire BTR,
               output wire LBI,
               output wire setIf,
               output wire halt, 
               output wire [15:0]aluA, 
               output wire [15:0]aluB, 
               output wire [15:0]imm11_ext, 
               output wire [15:0]imm8_ext,
               output wire [15:0]read2Data,
               output wire regWrite,
               output wire [2:0]writeReg);
   
   // control module signals
   wire [1:0]aluSrc;
   wire zeroExt; 
   wire [1:0] regDest;

   //4-1 mux controlled by regdest -> decides what our write register is
   // instatiate control module
   control CONTROLSIGS(.opcode(instr[15:11]), .r_typeALU(instr[1:0]), .aluSrc(aluSrc), .zeroExt(zeroExt), .valid(valid),
                        .regSrc(regSrc), .regWrite(regWrite), .regDest(regDest), .memWrite(memWrite), .memRead(memRead),
                         .aluJump(aluJump), .immSrc(immSrc), .brControl(brControl), .aluOp(aluOp), .invA(invA), .invB(invB), 
                         .cin(cin), .STU(STU), .BTR(BTR), .LBI(LBI), .setIf(setIf), .halt(halt), .setControl(setControl), .jump(jump)); 
   
   // 4 to 1 mux to control write data reg
   mux4_1_3b REGDEST(.sel(regDest), .inp0(instr[7:5]), .inp1(instr[10:8]), .inp2(instr[4:2]), .inp3(3'b111), .out(writeReg));

   // outputs from reg file go to alusrc1 and alusrc2 -> need to mux read2Data with other signals
   wire err; 
   regFile REGFILE(.read1RegSel(instr[10:8]), .read2RegSel(instr[7:5]), .writeData(writeData), 
                        .writeEn(MW_regWrite), .read1Data(aluA), .read2Data(read2Data), .writeRegSel(MW_writeReg),
                        .err(err), .clk(clk), .rst(rst)); 

   // sign extend or zero extend our immediate values form instruction bits
   wire [15:0] imm5_ext;
   assign imm5_ext = (zeroExt) ? {{11{1'b0}}, instr[4:0]} : {{11{instr[4]}}, instr[4:0]};
   assign imm8_ext = (zeroExt) ? {{8{1'b0}}, instr[7:0]} : {{8{instr[7]}}, instr[7:0]};
   assign imm11_ext = {{5{instr[10]}}, instr[10:0]};

   //pick the 'b' input of alu in execute
   mux4_1_16b ALUSOURCE(.sel(aluSrc), .inp0(read2Data), .inp1(imm8_ext), .inp2(imm5_ext), .inp3(16'b0), .out(aluB));

endmodule
`default_nettype wire