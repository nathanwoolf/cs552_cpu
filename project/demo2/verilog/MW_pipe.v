module MW_pipe(
    input wire [15:0]aluOut,
    input wire [15:0]readData,      //readData from memory
    input wire [15:0]XM_readData,   //read data 
    input wire [1:0]XM_regSrc,
    input wire [15:0]XM_aluOut, 
    input wire [15:0]XM_specOps,
    input wire [15:0]XM_next_pc,
    input wire [15:0]XM_pc_inc
    output wire [15:0]MW_next_pc,
); 

endmodule