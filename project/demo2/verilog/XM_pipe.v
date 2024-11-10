module XM_pipe(
    input wire [15:0]next_pc,       //this is the next pc after jumps and garbage
    input wire [15:0]aluOut, 
    input wire [15:0]outData,
    input wire [15:0]specOps,       //^ direct outputs from execute
    input wire DX_memWrite,
    input wire DX_memRead, 
    input wire [1:0]DX_regSrc,      //^ control signals consumed in memory or WB
    output wire XM_memWrite, 
    output wire XM_memRead, 
    output wire [15:0]XM_aluOut, 
    output wire [15:0]XM_writeData,
    output wire [15:0]XM_specOps,
    output wire [15:0]XM_next_pc
); 

endmodule