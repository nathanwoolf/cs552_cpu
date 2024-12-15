module DX_pipe(
    input wire clk, input wire rst,
    input wire [15:0]FD_instr,          output wire [15:0]DX_instr,
    input wire [15:0]pc_inc,            output wire [15:0]DX_pc_inc,
    input wire memWrite,                output wire DX_memWrite,
    input wire memRead,                 output wire DX_memRead,       
    input wire [1:0]regSrc,             output wire [1:0]DX_regSrc,    
    input wire aluJump,                 output wire DX_aluJump,               
    input wire jump,                    output wire DX_jump,
    input wire immSrc,                  output wire DX_immSrc,             
    input wire [2:0]brControl,          output wire [2:0]DX_brControl,
    input wire [1:0]setControl,         output wire [1:0]DX_setControl,
    input wire [2:0]aluOp,              output wire [2:0]DX_aluOp, 
    input wire invA,                    output wire DX_invA, 
    input wire invB,                    output wire DX_invB, 
    input wire cin,                     output wire DX_cin,
    input wire STU,                     output wire DX_STU,
    input wire BTR,                     output wire DX_BTR,
    input wire LBI,                     output wire DX_LBI,
    input wire setIf,                   output wire DX_setIf,
    input wire [15:0]aluA,              output wire [15:0]DX_aluA, 
    input wire [15:0]aluB,              output wire [15:0]DX_aluB, 
    input wire [15:0]imm11_ext,         output wire [15:0]DX_imm11_ext, 
    input wire [15:0]imm8_ext,          output wire [15:0]DX_imm8_ext,
    input wire [15:0]read2Data,         output wire [15:0]DX_read2Data,
    input wire regWrite,                output wire DX_regWrite,
    input wire [2:0]writeReg,           output wire [2:0]DX_writeReg, 
    input wire halt,                    output wire DX_halt,
    input wire FD_forward_XX_A,         output wire DX_forward_XX_A,
    input wire FD_forward_XX_B,         output wire DX_forward_XX_B,
    input wire FD_forward_XM_A,         output wire DX_forward_XM_A,
    input wire FD_forward_XM_B,         output wire DX_forward_XM_B,
    input wire [1:0]FD_forward_XX_sel,  output wire [1:0]DX_forward_XX_sel,
    input wire [1:0]FD_forward_XM_sel,  output wire [1:0]DX_forward_XM_sel, 
    input wire memAccess,               output wire DX_memAccess
    ); 

dff INSTR[15:0](.d(FD_instr), .q(DX_instr), .clk(clk), .rst(rst));
dff PC_INC[15:0](.d(pc_inc), .q(DX_pc_inc), .clk(clk), .rst(rst));
dff MEM_WRITE(.d(memWrite), .q(DX_memWrite), .clk(clk), .rst(rst));
dff MEM_READ(.d(memRead), .q(DX_memRead), .clk(clk), .rst(rst));
dff REG_SRC[1:0](.d(regSrc), .q(DX_regSrc), .clk(clk), .rst(rst));
dff ALU_JUMP(.d(aluJump), .q(DX_aluJump), .clk(clk), .rst(rst));
dff JUMP(.d(jump), .q(DX_jump), .clk(clk), .rst(rst));
dff IMM_SRC(.d(immSrc), .q(DX_immSrc), .clk(clk), .rst(rst));
dff BR_CONTROL[2:0](.d(brControl), .q(DX_brControl), .clk(clk), .rst(rst));
dff SET_CONTROL[1:0](.d(setControl), .q(DX_setControl), .clk(clk), .rst(rst));
dff ALU_OP[2:0](.d(aluOp), .q(DX_aluOp), .clk(clk), .rst(rst));
dff INVA(.d(invA), .q(DX_invA), .clk(clk), .rst(rst));
dff INVB_FF(.d(invB), .q(DX_invB), .clk(clk), .rst(rst));
dff CIN_FF(.d(cin), .q(DX_cin), .clk(clk), .rst(rst));
dff STU_FF(.d(STU), .q(DX_STU), .clk(clk), .rst(rst));
dff BTR_FF(.d(BTR), .q(DX_BTR), .clk(clk), .rst(rst));
dff LBI_FF(.d(LBI), .q(DX_LBI), .clk(clk), .rst(rst));
dff SET_IF_FF(.d(setIf), .q(DX_setIf), .clk(clk), .rst(rst));
dff ALU_A[15:0](.d(aluA), .q(DX_aluA), .clk(clk), .rst(rst));
dff ALU_B[15:0](.d(aluB), .q(DX_aluB), .clk(clk), .rst(rst));
dff IMM11[15:0](.d(imm11_ext), .q(DX_imm11_ext), .clk(clk), .rst(rst));
dff IMM8[15:0](.d(imm8_ext), .q(DX_imm8_ext), .clk(clk), .rst(rst));
dff READ2DATA[15:0](.d(read2Data), .q(DX_read2Data), .clk(clk), .rst(rst));
dff REGWRITE(.d(regWrite), .q(DX_regWrite), .clk(clk), .rst(rst));
dff WRITEREG[2:0](.d(writeReg), .q(DX_writeReg), .clk(clk), .rst(rst));
dff HALT(.d(halt), .q(DX_halt), .clk(clk), .rst(rst));

dff FORWARD_XX_A(.d(FD_forward_XX_A), .q(DX_forward_XX_A), .clk(clk), .rst(rst));
dff FORWARD_XX_B(.d(FD_forward_XX_B), .q(DX_forward_XX_B), .clk(clk), .rst(rst));
dff FORWARD_XM_A(.d(FD_forward_XM_A), .q(DX_forward_XM_A), .clk(clk), .rst(rst));
dff FORWARD_XM_B(.d(FD_forward_XM_B), .q(DX_forward_XM_B), .clk(clk), .rst(rst));
dff FORWARD_XX_SEL[1:0](.d(FD_forward_XX_sel), .q(DX_forward_XX_sel), .clk(clk), .rst(rst));
dff FORWARD_XM_SEL[1:0](.d(FD_forward_XM_sel), .q(DX_forward_XM_sel), .clk(clk), .rst(rst));
dff MEMACCESS(.d(memAccess), .q(DX_memAccess), .clk(clk), .rst(rst));

endmodule
