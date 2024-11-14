module hazard_unit(
    input wire [15:0]instr,
    input wire [15:0]FD_instr,
    input wire [2:0]FD_writeReg,
    input wire [2:0]DX_writeReg,
    input wire [2:0]XM_writeReg,
    input wire [1:0]regDest,
    input wire FD_regWrite,
    input wire DX_regWrite,
    input wire XM_regWrite,
    input wire FD_br_or_j,
    input wire DX_br_or_j,
    input wire XM_br_or_j,
    input wire MW_br_or_j,
    output wire [15:0]next_instr,
    output wire NOP
);

wire read_RS, read_RT;
// TODO

assign NOP_instr = (instr[15:11] == 5'b00001);
// Get reg dest based on R/I type
// assign FD_Rd = (FD_instr[15:11] == 5'b11000) ? (FD_instr[15:14] == 2'b11) ? FD_instr[4:2] : FD_instr[7:5];
// assign DX_Rd = (DX_instr[15:14] == 2'b11) ? DX_instr[4:2] : DX_instr[7:5];
// assign XM_Rd = (XM_instr[15:14] == 2'b11) ? XM_instr[4:2] : XM_instr[7:5];


// need to make sure reg were reading from is not the same as any we will be writing to in downstream instr 


assign DX_Rd = DX_writeReg;
assign XM_Rd = XM_writeReg;

assign read_RS = (  (instr[15:13] == 3'b010) || 
                    (instr[15:13] == 3'b101) || 
                    (instr[15:13] == 3'b100) || 
                    (instr[15:12] == 4'b1101) || 
                    (instr[15:13] == 3'b111) ||
                    (instr[15:13] == 3'b011) ||
                    (instr[15:11] == 5'b10010) ||       //SLBI
                    (instr[15:11] == 5'b11000) ||       //LBI
                    (instr[15:11] == 5'b11001) ||
                    (instr[15:13] == 3'b001 && instr[11] == 1)) ? 1'b1 : 1'b0; 
assign read_RT = (instr[15:12] == 5'b1101) ? (~(instr[15:11] == 5'b11001)) : 
                    (instr[15:13] == 5'b111) ? 1'b1 : 1'b0;
assign read_RD = (instr[15:11] == 5'b10011) || (instr[15:11] == 5'b10000);


// RS is [10:8], RT is [7:5]
assign NOP = (FD_instr !== 16'b0000) ? (
                    FD_br_or_j || DX_br_or_j || XM_br_or_j || MW_br_or_j ||
                    (read_RS && ((FD_regWrite && FD_writeReg == instr[10:8]) || (DX_regWrite && DX_writeReg == instr[10:8]) || (XM_regWrite && XM_writeReg == instr[10:8]))) ||
                    (read_RT && ((FD_regWrite && FD_writeReg == instr[7:5]) || (DX_regWrite && DX_writeReg == instr[7:5]) || (XM_regWrite && XM_writeReg == instr[7:5]))) ||
                    (read_RD && ((FD_regWrite && FD_writeReg == instr[7:5]) || (DX_regWrite && DX_writeReg == instr[7:5]) || (XM_regWrite && XM_writeReg == instr[7:5])))
                ) : 1'b0;

assign next_instr = NOP ? 16'h0800 : instr;
              
/*
always @(*) begin 
    // Default outputs
    read_RS = 1'b0;
    read_RT = 1'b0;

    casex (instr[15:11])

        // Arithmetic with immediate
        5'b010??: begin 
            read_RS = 1'b1;
        end

        // Shift with immediate
        5'b101??: begin 
            read_RS = 1'b1;
        end

        // 
        5'b100??: begin 
            read_RS = 1'b1;
        end

        // Arithmetic with registers
        5'b1101?: begin 
            read_RS = 1'b1;
            read_RT = ~(instr[15:11] == 5'b11001);
        end

        // Set
        5'b111??: begin 
            read_RS = 1'b1;
            read_RT = 1'b1;
        end

        // Branch
        5'b011??: begin 
            read_RS = 1'b1;
        end

        // Jump
        5'b001?1: begin 
            read_RS = 1'b1;
        end

    endcase 
end 
*/ 

endmodule