module MW_pipe(
    input wire clk, input wire rst, 
    input wire [15:0]readData,      output wire [15:0]MW_readMemData,        //readData from memory
    input wire [1:0]XM_regSrc,      output wire [1:0]MW_regSrc,
    input wire [15:0]XM_aluOut,     output wire [15:0]MW_aluOut, 
    input wire [15:0]XM_specOps,    output wire [15:0]MW_specOps, 
    input wire [15:0]XM_next_pc,    output wire [15:0]MW_next_pc,
    input wire [15:0]XM_pc_inc,     output wire [15:0]MW_pc_inc,
    input wire XM_regWrite,         output wire MW_regWrite,
    input wire [2:0]XM_writeReg,    output wire [2:0]MW_writeReg,
    input wire XM_jump,             output wire MW_jump,
    input wire XM_br,               output wire MW_br,
    input wire align_err_m,         output wire MW_align_err_m,
    input wire XM_halt,             output wire MW_halt,
    input wire XM_flush,            output wire MW_flush
); 

dff READ_MEM_DATA[15:0](.d(readData), .q(MW_readMemData), .clk(clk), .rst(rst));
dff ALU_OUT[15:0](.d(XM_aluOut), .q(MW_aluOut), .clk(clk), .rst(rst));
dff SPEC_OPS[15:0](.d(XM_specOps), .q(MW_specOps), .clk(clk), .rst(rst));
dff NEX_TPC[15:0](.d(XM_next_pc), .q(MW_next_pc), .clk(clk), .rst(rst));
dff PC_INC[15:0](.d(XM_pc_inc), .q(MW_pc_inc), .clk(clk), .rst(rst));
dff REG_SRC[1:0](.d(XM_regSrc), .q(MW_regSrc), .clk(clk), .rst(rst));
dff REGWRITE(.d(XM_regWrite), .q(MW_regWrite), .clk(clk), .rst(rst));
dff WRITEREG[2:0](.d(XM_writeReg), .q(MW_writeReg), .clk(clk), .rst(rst));
dff JUMP(.d(XM_jump), .q(MW_jump), .clk(clk), .rst(rst));
dff BR(.d(XM_br), .q(MW_br), .clk(clk), .rst(rst));
dff HALT(.d(XM_halt), .q(MW_halt), .clk(clk), .rst(rst));
dff ALIGNERRMEM(.d(align_err_m), .q(MW_align_err_m), .clk(clk), .rst(rst));
dff FLUSH(.d(XM_flush), .q(MW_flush), .clk(clk), .rst(rst));


endmodule