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
    input wire [15:0]FD_instr,
    input wire [15:0]DX_instr, 

    input wire FD_br_or_j,
    input wire DX_br_or_j,
    input wire XM_br_or_j,
    input wire MW_br_or_j,

    input wire [15:0]instr,
    input wire [2:0]FD_writeReg,
    input wire [2:0]DX_writeReg,
    input wire FD_regWrite,
    input wire DX_regWrite,

    output wire forward_XX_A,
    output wire forward_XX_B,
    output wire forward_XM_A,
    output wire forward_XM_B,

    output wire [1:0]forward_XX_sel,
    output wire [1:0]forward_XM_sel,
    output wire NOP,
    output wire [15:0] next_instr
);

assign read_RS = (  (instr[15:13] == 3'b010) | 
                    (instr[15:13] == 3'b101) |
                    (instr[15:13] == 3'b100) |
                    (instr[15:12] == 4'b1101) |
                    (instr[15:13] == 3'b111) |
                    (instr[15:13] == 3'b011) |
                    (instr[15:11] == 5'b10010) |       //SLBI
                    (instr[15:11] == 5'b11000) |       //LBI
                    (instr[15:11] == 5'b11001) |
                    (instr[15:13] == 3'b001 & instr[11] == 1)) ? 1'b1 : 1'b0; 
assign read_RT = (instr[15:12] == 5'b1101) ? (~(instr[15:11] == 5'b11001)) : 
                    (instr[15:13] == 5'b111) ? 1'b1 : 1'b0;
assign read_RD = (instr[15:11] == 5'b10011) | (instr[15:11] == 5'b10000);

assign forward_XX_A = (read_RS & (FD_regWrite & FD_writeReg == instr[10:8]));

assign forward_XX_B = (read_RT & (FD_regWrite & FD_writeReg == instr[7:5])) |
                      (read_RD & (FD_regWrite & FD_writeReg == instr[7:5]));

assign forward_XM_A = (read_RS & (DX_regWrite & DX_writeReg == instr[10:8]));

assign forward_XM_B = (read_RT & (DX_regWrite & DX_writeReg == instr[7:5])) |
                      (read_RD & (DX_regWrite & DX_writeReg == instr[7:5]));

assign forward_XX_sel = ( (FD_instr[15:11] == 5'b11000) |
                            (FD_instr[15:11] == 5'b10010) |
                            (FD_instr[15:11] == 5'b11001) |
                            (FD_instr[15:13] == 3'b111)
                            ) ? 2'b00 :
                            // (FD_instr[15:12] == 4'0011) ? 2'b01 :
                            (FD_instr[15:11] == 5'b10001) ? 2'b10 :
                            2'b11;

assign forward_XM_sel = ( (DX_instr[15:11] == 5'b11000) |
                            (DX_instr[15:11] == 5'b10010) |
                            (DX_instr[15:11] == 5'b11001) |
                            (DX_instr[15:13] == 3'b111)
                            ) ? 2'b00 :
                            (DX_instr[15:12] == 4'b0011) ? 2'b01 :
                            (DX_instr[15:11] == 5'b10001) ? 2'b10 :
                            2'b11;


// TODO here for now, remove when adding branch prediction
assign NOP = (FD_instr !== 16'b0000) ? (
                    FD_br_or_j | DX_br_or_j | XM_br_or_j | MW_br_or_j | 
                    ((FD_instr[15:11] == 5'b10001) & (
                        (read_RS & (FD_regWrite & FD_writeReg == instr[10:8])) | 
                        (read_RT & (FD_regWrite & FD_writeReg == instr[7:5])) |
                        (read_RD & (FD_regWrite & FD_writeReg == instr[7:5]))
                    ))
                ) : 1'b0;

assign next_instr = NOP ? 16'h0800 : instr;

endmodule
