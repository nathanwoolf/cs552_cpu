//TODO: we need come up with a way to get a muxoutput for aluA and aluB for the following singals
// specOps from XM latch
// specOps from MW latch
// aluA from DX latch
// aluA from DX latch 
// aluOut from XM latch 
// aluOut from MW latch
// output of wb (writeData)

// all of these signals are already pipelined
// need to handle convential forwarding with handling 

module forwarding(
    input wire [15:0]DX_instr, 

    input wire [2:0] MW_rd,
    input wire MW_regWrite,
    input wire [2:0] XM_rd,
    input wire XM_regWrite, 

    input wire [15:0] DX_aluA, 
    input wire [15:0] DX_aluB, 

    input wire [15:0] write_Data, 

    output wire [1:0] forwardA, 
    output wire [1:0] forwardB, 
    output wire [15:0] aluA, 
    output wire [15:0] aluB);

/**
 * Basic forwarding idea: 
 * if the current register we are trying to read from (RS or RT) matches on of the 
 * registers in our blocks downstream from execute, pass that value back to before EX 
 * and MUX it into aluA or aluB depending on the control singal 
 * 
 * otherwise, let the hazard detection unit take care of it
 * 
 * mux control mapping in proc for forwardA and forwardB 
 * 2'b00 -> take XM_aluOut
 * 2'b01 -> take MW_aluOut

 * 2'b11 -> no forwarding 
 */

//forwarding can come for WB or XM latch
// essentially readReg1 from fetch 
 assign forwardA =  (XM_regWrite && (DX_instr[10:8] === XM_rd)) ? 2'b00 : 
                    (MW_regWrite && (DX_instr[10:8] === MW_rd)) ? 2'b01 : 2'b11;  

// essentially readReg2 from fetch
 assign forwardB =  (XM_regWrite && (DX_instr[7:5] === XM_rd)) ? 2'b00 : 
                    (MW_regWrite && (DX_instr[7:5] === MW_rd)) ? 2'b01 : 2'b11;  



endmodule
