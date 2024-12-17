module DX_pipe(
    input wire clk, input wire rst, input wire stall,
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
    input wire memAccess,               output wire DX_memAccess,
    input wire flush
    // ,                   output wire DX_flush
    ); 

wire rst_or_flush;
assign rst_or_flush = rst | (flush & ~stall);

wire [15:0] instr_m;
assign instr_m = stall ? DX_instr : FD_instr;
dff INSTR[15:0](.d(instr_m), .q(DX_instr), .clk(clk), .rst(rst_or_flush)); // TODO might need to flush this to halt? not sure, will affect fwd logic if we keep and not flush

wire [15:0] pc_inc_m;
assign pc_inc_m = stall ? DX_pc_inc : pc_inc; 
dff PC_INC[15:0](.d(pc_inc_m), .q(DX_pc_inc), .clk(clk), .rst(rst_or_flush));

wire memWrite_m; 
assign memWrite_m = stall ? DX_memWrite : memWrite;
dff MEM_WRITE(.d(memWrite_m), .q(DX_memWrite), .clk(clk), .rst(rst_or_flush));

wire memRead_m;
assign memRead_m = stall ? DX_memRead : memRead;
dff MEM_READ(.d(memRead_m), .q(DX_memRead), .clk(clk), .rst(rst_or_flush));

wire [1:0]regSrc_m; 
assign regSrc_m = stall ? DX_regSrc : regSrc;
dff REG_SRC[1:0](.d(regSrc_m), .q(DX_regSrc), .clk(clk), .rst(rst_or_flush));

wire aluJump_m; 
assign aluJump_m = stall ? DX_aluJump : aluJump;
dff ALU_JUMP(.d(aluJump_m), .q(DX_aluJump), .clk(clk), .rst(rst_or_flush));

wire jump_m; 
assign jump_m = stall ? DX_jump : jump;
dff JUMP(.d(jump_m), .q(DX_jump), .clk(clk), .rst(rst_or_flush));

wire immSrc_m; 
assign immSrc_m = stall ? DX_immSrc : immSrc;
dff IMM_SRC(.d(immSrc_m), .q(DX_immSrc), .clk(clk), .rst(rst_or_flush));

wire [2:0] brControl_m; 
assign brControl_m = stall ? DX_brControl : brControl;
dff BR_CONTROL[2:0](.d(brControl_m), .q(DX_brControl), .clk(clk), .rst(rst_or_flush));

wire [1:0]setControl_m; 
assign setControl_m = stall ? DX_setControl : setControl;
dff SET_CONTROL[1:0](.d(setControl_m), .q(DX_setControl), .clk(clk), .rst(rst_or_flush));

wire [2:0]aluOp_m;
assign aluOp_m = stall ? DX_aluOp : aluOp;
dff ALU_OP[2:0](.d(aluOp_m), .q(DX_aluOp), .clk(clk), .rst(rst_or_flush));

wire invA_m;
assign invA_m = stall ? DX_invA : invA;
dff INVA(.d(invA_m), .q(DX_invA), .clk(clk), .rst(rst_or_flush));

wire invB_m;
assign invB_m = stall ? DX_invB : invB;
dff INVB_FF(.d(invB_m), .q(DX_invB), .clk(clk), .rst(rst_or_flush));

wire cin_m; 
assign cin_m = stall ? DX_cin : cin;
dff CIN_FF(.d(cin_m), .q(DX_cin), .clk(clk), .rst(rst_or_flush));

wire STU_m; 
assign STU_m = stall ? DX_STU : STU;
dff STU_FF(.d(STU_m), .q(DX_STU), .clk(clk), .rst(rst_or_flush));

wire BTR_m;
assign BTR_m = stall ? DX_BTR : BTR;
dff BTR_FF(.d(BTR_m), .q(DX_BTR), .clk(clk), .rst(rst_or_flush));

wire LBI_m;
assign LBI_m = stall ? DX_LBI : LBI;
dff LBI_FF(.d(LBI_m), .q(DX_LBI), .clk(clk), .rst(rst_or_flush));

wire setIf_m; 
assign setIf_m = stall ? DX_setIf : setIf;
dff SET_IF_FF(.d(setIf_m), .q(DX_setIf), .clk(clk), .rst(rst_or_flush));

wire [15:0]aluA_m; 
assign aluA_m = stall ? DX_aluA : aluA;
dff ALU_A[15:0](.d(aluA_m), .q(DX_aluA), .clk(clk), .rst(rst_or_flush));

wire [15:0]aluB_m;
assign aluB_m = stall ? DX_aluB : aluB;
dff ALU_B[15:0](.d(aluB_m), .q(DX_aluB), .clk(clk), .rst(rst_or_flush));

wire [15:0]imm11_ext_m;
assign imm11_ext_m = stall ? DX_imm11_ext : imm11_ext;
dff IMM11[15:0](.d(imm11_ext_m), .q(DX_imm11_ext), .clk(clk), .rst(rst_or_flush));

wire [15:0]imm8_ext_m; 
assign imm8_ext_m = stall ? DX_imm8_ext : imm8_ext;
dff IMM8[15:0](.d(imm8_ext_m), .q(DX_imm8_ext), .clk(clk), .rst(rst_or_flush));

wire [15:0]read2Data_m;
assign read2Data_m = stall ? DX_read2Data : read2Data;
dff READ2DATA[15:0](.d(read2Data_m), .q(DX_read2Data), .clk(clk), .rst(rst_or_flush));

wire regWrite_m; 
assign regWrite_m = stall ? DX_regWrite : regWrite;
dff REGWRITE(.d(regWrite_m), .q(DX_regWrite), .clk(clk), .rst(rst_or_flush));

wire [2:0]writeReg_m; 
assign writeReg_m = stall ? DX_writeReg : writeReg;
dff WRITEREG[2:0](.d(writeReg_m), .q(DX_writeReg), .clk(clk), .rst(rst_or_flush));

wire halt_m; 
assign halt_m = stall ? DX_halt : halt;
dff HALT(.d(halt_m), .q(DX_halt), .clk(clk), .rst(rst_or_flush));

wire forward_XX_A_m; 
assign forward_XX_A_m = stall ? DX_forward_XX_A : FD_forward_XX_A;
dff FORWARD_XX_A(.d(forward_XX_A_m), .q(DX_forward_XX_A), .clk(clk), .rst(rst_or_flush));

wire forward_XX_B_m; 
assign forward_XX_B_m = stall ? DX_forward_XX_B : FD_forward_XX_B;
dff FORWARD_XX_B(.d(forward_XX_B_m), .q(DX_forward_XX_B), .clk(clk), .rst(rst_or_flush));

wire forward_XM_A_m;
assign forward_XM_A_m = stall ? DX_forward_XM_A : FD_forward_XM_A;
dff FORWARD_XM_A(.d(forward_XM_A_m), .q(DX_forward_XM_A), .clk(clk), .rst(rst_or_flush));

wire forward_XM_B_m;
assign forward_XM_B_m = stall ? DX_forward_XM_B : FD_forward_XM_B;
dff FORWARD_XM_B(.d(forward_XM_B_m), .q(DX_forward_XM_B), .clk(clk), .rst(rst_or_flush));

wire [1:0]forward_XX_sel_m;
assign forward_XX_sel_m = stall ? DX_forward_XX_sel : FD_forward_XX_sel;
dff FORWARD_XX_SEL[1:0](.d(forward_XX_sel_m), .q(DX_forward_XX_sel), .clk(clk), .rst(rst_or_flush));

wire [1:0]forward_XM_sel_m;
assign forward_XM_sel_m = stall ? DX_forward_XM_sel : FD_forward_XM_sel;
dff FORWARD_XM_SEL[1:0](.d(forward_XM_sel_m), .q(DX_forward_XM_sel), .clk(clk), .rst(rst_or_flush));

wire memAccess_m; 
assign memAccess_m = stall ? DX_memAccess : memAccess;
dff MEMACCESS(.d(memAccess_m), .q(DX_memAccess), .clk(clk), .rst(rst_or_flush));
// dff MEMFLUSH(.d(flush), .q(DX_flush), .clk(clk), .rst(rst));


endmodule
