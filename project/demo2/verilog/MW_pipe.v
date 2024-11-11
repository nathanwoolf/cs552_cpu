module MW_pipe(
    input clk, input rst, 
    input wire [15:0]readData,      output wire [15:0]MW_readMemData,        //readData from memory
    input wire [15:0]XM_readData,   output wire [15:0]MW_readData,          //read data from registers??
    input wire [1:0]XM_regSrc,      output wire [1:0]MW_regSrc,
    input wire [15:0]XM_aluOut,     output wire [15:0]MW_aluOut, 
    input wire [15:0]XM_specOps,    output wire [15:0]MW_specOps, 
    input wire [15:0]XM_next_pc,    output wire [15:0]MW_next_pc,
    input wire [15:0]XM_pc_inc,     output wire [15:0]MW_pc_inc
); 

dff READ_MEM_DATA[15:0](.d(readData), .q(MW_readMemData), .clk(clk), .rst(rst));
dff READ_DATA[15:0](.d(XM_readData), .q(MW_readData), .clk(clk), .rst(rst));
dff ALU_OUT[15:0](.d(XM_aluOut), .q(MW_aluOut), .clk(clk), .rst(rst));
dff SPEC_OPS[15:0](.d(XM_specOps), .q(MW_specOps), .clk(clk), .rst(rst));
dff NEX_TPC[15:0](.d(XM_next_pc), .q(MW_next_pc), .clk(clk), .rst(rst));
dff PC_INC[15:0](.d(XM_pc_inc), .q(MW_pc_inc), .clk(clk), .rst(rst));
dff REG_SRC[1:0](.d(XM_regSrc), .q(MW_regSrc), .clk(clk), .rst(rst));
endmodule