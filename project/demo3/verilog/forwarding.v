module forwarding(
    input wire [15:0]DX_instr; 

    input wire [2:0] MW_rd; 
    input wire MW_regWrite;

    input wire [2:0] XM_rd;
    input wire XM_regWrite; 

    output wire [1:0] forwardA; 
    output wire [1:0] forwardB;
);

/**
 * Basic forwarding idea: 
 * if the current register we are trying to read from (RS or RT) matches on of the 
 * registers in our blocks downstream from execute, pass thaat value back to before EX 
 * and MUX it into aluA or aluB depending on the control singal 
 * 
 * otherwise, let the hazard detection unit take care of it
 * 
 * mux control mapping in proc for forwardA and forwardB 
 * 2'b00 -> take XM_aluOut
 * 2'b01 -> take MW_aluOut
 * 2'b11 -> take aluA and aluB from decode stage
 */

//forwarding can come for WB or XM latch
 assign forwardA =  (XM_regWrite && (DX_instr[10:8] === XM_rd)) ? 2'b00 : 
                    (MW_regWrite && (DX_instr[10:8] === MW_rd)) ? 2'b01 : 2'b11;  

 assign forwardA =  (XM_regWrite && (DX_instr[7:5] === XM_rd)) ? 2'b00 : 
                    (MW_regWrite && (DX_instr[7:5] === MW_rd)) ? 2'b01 : 2'b11;  


endmodule
