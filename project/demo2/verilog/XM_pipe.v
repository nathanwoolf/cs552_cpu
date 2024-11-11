module XM_pipe(
    input clk, input rst,
    input wire [15:0]next_pc,           output wire [15:0]XM_next_pc,      //this is the next pc after jumps and garbage
    input wire [15:0]pc_inc,            output wire [15:0]XM_pc_inc,
    input wire [15:0]aluOut,            output wire [15:0]XM_aluOut, 
    input wire [15:0]outData,           output wire [15:0]XM_writeData,
    input wire [15:0]specOps,           output wire [15:0]XM_specOps,       //^ direct outputs from execute 
    input wire DX_memWrite,             output wire XM_memWrite, 
    input wire DX_memRead,              output wire XM_memRead, 
    input wire [1:0]DX_regSrc,          output wire XM_regSrc   
); 

dff NEXT_PC[15:0](.d(next_pc), .q(XM_next_pc), .clk(clk), .rst(rst));
dff NEXT_PC[15:0](.d(pc_inc), .q(XM_pc_inc), .clk(clk), .rst(rst));
dff ALU_OUT[15:0](.d(aluOut), .q(XM_aluOut), .clk(clk), .rst(rst));
dff OUT_DATA[15:0](.d(outData), .q(XM_writeData), .clk(clk), .rst(rst));
dff SPEC_OPS[15:0](.d(specOps), .q(XM_specOps), .clk(clk), .rst(rst));
dff MEM_WRITE(.d(memWrite), .q(XM_memWrite), .clk(clk), .rst(rst));
dff MEE_READ(.d(memRead), .q(XM_memRead), .clk(clk), .rst(rst));
dff REG_SRC[1:0](.d(DX_regSrc), .q(XM_regSrc), .clk(clk), .rst(rst));
endmodule