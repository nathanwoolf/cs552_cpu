module DX_pipe(
    input wire [15:0] FD_instr, 
    input wire memWrite,
    input wire memRead,   
    input wire [1:0]regSrc,    
    input wire aluJump,          
    input wire jump,
    input wire immSrc,             
    input wire [2:0]brControl,
    input wire [1:0]setControl,
    input wire [2:0]aluOp, 
    input wire invA, 
    input wire invB, 
    input wire cin,
    input wire STU,
    input wire BTR,
    input wire LBI,
    input wire setIf,
    input wire halt, 
    input wire [15:0]aluA, 
    input wire [15:0]aluB, 
    input wire [15:0]imm11_ext, 
    input wire [15:0]imm8_ext,
    input wire [15:0]read2Data,
    output wire DX_memWrite,
    output wire DX_memRead,       
    output wire [1:0]DX_regSrc,    
    output wire DX_aluJump,               
    output wire DX_jump,
    output wire DX_immSrc,             
    output wire [2:0]DX_brControl,
    output wire [1:0]DX_setControl,
    output wire [2:0]DX_aluOp, 
    output wire DX_invA, 
    output wire DX_invB, 
    output wire DX_cin,
    output wire DX_STU,
    output wire DX_BTR,
    output wire DX_LBI,
    output wire DX_setIf,
    output wire DX_halt, 
    output wire [15:0]DX_aluA, 
    output wire [15:0]DX_aluB, 
    output wire [15:0]DX_imm11_ext, 
    output wire [15:0]DX_imm8_ext,
    output wire [15:0]DX_read2Data
); 

endmodule
