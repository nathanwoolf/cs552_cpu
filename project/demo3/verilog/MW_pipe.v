module MW_pipe(
    input wire clk, input wire rst, input wire stall,
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
    input wire XM_halt,             output wire MW_halt,
    input wire XM_flush,            output wire MW_flush
); 

wire [15:0]readData_m; 
assign readData_m = stall ? MW_readMemData : readData;
dff READ_MEM_DATA[15:0](.d(readData_m), .q(MW_readMemData), .clk(clk), .rst(rst));

wire [15:0]aluOut_m; 
assign aluOut_m = stall ? MW_aluOut : XM_aluOut;
dff ALU_OUT[15:0](.d(aluOut_m), .q(MW_aluOut), .clk(clk), .rst(rst));

wire [15:0]specOps_m; 
assign specOps_m = stall ? MW_specOps : XM_specOps; 
dff SPEC_OPS[15:0](.d(specOps_m), .q(MW_specOps), .clk(clk), .rst(rst));

wire [15:0]next_pc_m; 
assign next_pc_m = stall ? MW_next_pc : XM_next_pc;
dff NEX_TPC[15:0](.d(next_pc_m), .q(MW_next_pc), .clk(clk), .rst(rst));

wire [15:0]pc_inc_m; 
assign pc_inc_m = stall ? MW_pc_inc : XM_pc_inc;
dff PC_INC[15:0](.d(pc_inc_m), .q(MW_pc_inc), .clk(clk), .rst(rst));

wire [1:0]regSrc_m; 
assign regSrc_m = stall ? MW_regSrc : XM_regSrc;
dff REG_SRC[1:0](.d(regSrc_m), .q(MW_regSrc), .clk(clk), .rst(rst));

wire regWrite_m;
assign regWrite_m = stall ? MW_regWrite : XM_regWrite;
dff REGWRITE(.d(regWrite_m), .q(MW_regWrite), .clk(clk), .rst(rst));

wire [2:0]writeReg_m; 
assign writeReg_m = stall ? MW_writeReg : XM_writeReg;
dff WRITEREG[2:0](.d(writeReg_m), .q(MW_writeReg), .clk(clk), .rst(rst));

wire jump_m;
assign jump_m = stall ? MW_jump : XM_jump;
dff JUMP(.d(jump_m), .q(MW_jump), .clk(clk), .rst(rst));

wire br_m;
assign br_m = stall ? MW_br : XM_br;
dff BR(.d(br_m), .q(MW_br), .clk(clk), .rst(rst));

wire halt_m; 
assign halt_m = stall ? MW_halt : XM_halt;
dff HALT(.d(halt_m), .q(MW_halt), .clk(clk), .rst(rst));

wire flush_m; 
assign flush_m = stall ? MW_flush : XM_flush;
dff FLUSH(.d(flush_m), .q(MW_flush), .clk(clk), .rst(rst));


endmodule