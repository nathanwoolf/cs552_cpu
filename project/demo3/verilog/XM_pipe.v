module XM_pipe(
    input wire clk, input wire rst, input wire stall,
    input wire [15:0]DX_instr,          output wire [15:0]XM_instr,
    input wire [15:0]next_pc,           output wire [15:0]XM_next_pc,      //this is the next pc after jumps and garbage
    input wire [15:0]pc_inc,            output wire [15:0]XM_pc_inc,
    input wire [15:0]aluOut,            output wire [15:0]XM_aluOut, 
    input wire [15:0]outData,           output wire [15:0]XM_writeData,
    input wire [15:0]specOps,           output wire [15:0]XM_specOps,       //^ direct outputs from execute 
    input wire DX_memWrite,             output wire XM_memWrite, 
    input wire DX_memRead,              output wire XM_memRead, 
    input wire [1:0]DX_regSrc,          output wire [1:0]XM_regSrc,
    input wire DX_regWrite,             output wire XM_regWrite,
    input wire [2:0]DX_writeReg,        output wire [2:0]XM_writeReg, 
    input wire DX_jump,                 output wire XM_jump,
    input wire DX_br,                   output wire XM_br,
    input wire DX_halt,                 output wire XM_halt, 
    input wire DX_memAccess,            output wire XM_memAccess,
    input wire flush,                   output wire XM_flush
); 

wire [15:0]instr_m;
assign instr_m = stall ? XM_instr : DX_instr;
dff INSTR[15:0](.d(instr_m), .q(XM_instr), .clk(clk), .rst(rst));

wire [15:0]next_pc_m;
assign next_pc_m = stall ? XM_next_pc : next_pc;
dff NEXT_PC[15:0](.d(next_pc_m), .q(XM_next_pc), .clk(clk), .rst(rst));

wire [15:0]pc_inc_m;
assign pc_inc_m = stall ? XM_pc_inc : pc_inc;
dff PC_INC[15:0](.d(pc_inc_m), .q(XM_pc_inc), .clk(clk), .rst(rst));

wire [15:0]aluOut_m; 
assign aluOut_m = stall ? XM_aluOut : aluOut;
dff ALU_OUT[15:0](.d(aluOut_m), .q(XM_aluOut), .clk(clk), .rst(rst));

wire [15:0] outData_m; 
assign outData_m = stall ? XM_writeData : outData;
dff OUT_DATA[15:0](.d(outData_m), .q(XM_writeData), .clk(clk), .rst(rst));

wire [15:0]specOps_m; 
assign specOps_m = stall ? XM_specOps : specOps;
dff SPEC_OPS[15:0](.d(specOps_m), .q(XM_specOps), .clk(clk), .rst(rst));

wire memWrite_m;
assign memWrite_m = stall ? XM_memWrite : DX_memWrite;
dff MEM_WRITE(.d(memWrite_m), .q(XM_memWrite), .clk(clk), .rst(rst));

wire memRead_m; 
assign memRead_m = stall ? XM_memRead : DX_memRead;
dff MEE_READ(.d(memRead_m), .q(XM_memRead), .clk(clk), .rst(rst));

wire [1:0]regSrc_m;
assign regSrc_m = stall ? XM_regSrc : DX_regSrc;
dff REG_SRC[1:0](.d(regSrc_m), .q(XM_regSrc), .clk(clk), .rst(rst));

wire regWrite_m;
assign regWrite_m = stall ? XM_regWrite : DX_regWrite;
dff REGWRITE(.d(regWrite_m), .q(XM_regWrite), .clk(clk), .rst(rst));

wire [2:0]writeReg_m; 
assign writeReg_m = stall ? XM_writeReg : DX_writeReg;
dff WRITEREG[2:0](.d(writeReg_m), .q(XM_writeReg), .clk(clk), .rst(rst));

wire jump_m; 
assign jump_m = stall ? XM_jump : DX_jump;
dff JUMP(.d(jump_m), .q(XM_jump), .clk(clk), .rst(rst));

wire br_m; 
assign br_m = stall ? XM_br : DX_br;
dff BR(.d(br_m), .q(XM_br), .clk(clk), .rst(rst));

wire halt_m; 
assign halt_m = stall ? XM_halt : DX_halt;
dff HALT(.d(halt_m), .q(XM_halt), .clk(clk), .rst(rst));

wire memAccess_m; 
assign memAccess_m = stall ? XM_memAccess : DX_memAccess;
dff MEMACCESS(.d(memAccess_m), .q(XM_memAccess), .clk(clk), .rst(rst));

wire flush_m; 
assign flush_m = stall ? XM_flush : flush;
dff FORWARD_FLUSH(.d(flush_m), .q(XM_flush), .clk(clk), .rst(rst));


endmodule