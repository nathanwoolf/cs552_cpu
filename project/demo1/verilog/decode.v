/*
   CS/ECE 552 Spring '22
  
   Filename        : decode.v
   Description     : This is the module for the overall decode stage of the processor.
*/
`default_nettype none
module decode (input clk, 
               input rst, 
               input [15:0]instr,
               input [15:0]writeData,  
               output memWrite,           
               output jump,               // branch half of execute
               output immSrc,             // to go to branch part of execute
               output [2:0]brControl,
               output [2:0]aluOp, 
               output invA, 
               output invB, 
               output cin,
               output BTR,
               output setIf, 
               output [15:0]aluA, 
               output [15:0]aluB, 
               output [15:0]imm11_ext, 
               output [15:0]imm8_ext,
               output [7:0]SLBI_instr); // TODO
   
   // control module signals
   wire [1:0]aluSrc;
   wire [1:0]regSrc,
   wire zeroExt; 
   wire regDest; 
   wire regWrite; 
   wire STU; 
   
   //4-1 mux controlled by regdest -> decides what our write register is
   // instatiate control module
   control CONTROLSIGS(.opcode(instr[15:11]), .r_typeALU(instr[1:0]), .aluSrc(aluSrc), .zeroExt(zeroExt), 
                        .regSrc(regSrc), .regWrite(regWrite), .regDest(regDest),
                        .memWrite(memWrite), .jump(jump), .immSrc(immSrc), .brControl(brControl), 
                        .aluOp(aluOp), .invA(invA), .invB(invB), .cin(cin), .STU(STU), .BTR(BTR), .setIf(setIf)); 

   //need to flop regWrite so signal is still high when WB happens
   reg regWrite_latch; 
   dff REGWRITE_LATCH(.d(regWrite), .q(regWrite_latch), .clk(clk), .rst(rst)); // TODO ask nathan about latch
   
   // 4 to 1 mux to control write data reg
   reg [2:0]writeReg;
   mux4_1_3b REGDEST(.sel(regDest), .inp0(instr[7:5]), .inp1(instr[10:8]), .inp2(instr[4:2]), .inp3(3'b111), .out(writeReg));

   // outputs from reg file go to alusrc1 and alusrc2 -> need to mux read2Data with other signals
   wire [15:0] read2Data;  
   wire regWrite; 
   wire err; 
   regFile REGISTERFILE(.read1RegSel(instr[10:8]), .read2RegSel(instr[7:5]), .writeData(writeData), 
                        .writeEn(regWrite_latch), .read1Data(aluA), .read2Data(read2Data), .writeRegSel(writeReg),
                        .err(err), .clk(clk), .rst(rst)); 

   // sign extend or zero extend our immediate values form instruction bits
   reg [15:0] imm5_ext, imm8_ext, imm11_ext; 
   assign imm5_ext = (zeroExt) ? {{11{1'b0}}, instr[4:0]} : {{11{instr[4]}}, instr[4:0]};
   assign imm8_ext = (zeroExt) ? {{8{1'b0}}, instr[7:0]} : {{8{instr[7]}}, instr[7:0]};
   assign imm11_ext = {{5{instr[10]}}, instr[10:0]};

   //pick the 'b' input of alu in execute
   mux4_1_16b ALUSOURCE(.sel(aluSrc), .inp0(read2Data), .inp1(imm8_ext), .inp2(imm5_ext), .inp3(16'b0), .out(aluB));

endmodule
`default_nettype wire
