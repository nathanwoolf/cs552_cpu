module hazard_unit(
    input wire [15:0]instr,
    input wire [15:0]FD_instr,
    input wire [15:0]DX_instr,
    input wire [15:0]XM_instr,
    output wire branch_or_jump,
    output wire NOP
);

assign branch_or_jump = ~instr[15] && instr[13];

reg read_RS, read_RT;





// TODO

// Get reg dest based on R/I type
assign FD_Rd = (FD_instr[15:11] == 5'b11000) ? (FD_instr[15:14] == 2'b11) ? FD_instr[4:2] : FD_instr[7:5];
assign DX_Rd = (DX_instr[15:14] == 2'b11) ? DX_instr[4:2] : DX_instr[7:5];
assign XM_Rd = (XM_instr[15:14] == 2'b11) ? XM_instr[4:2] : XM_instr[7:5];


// RS is [10:8], RT is [7:5]
assign NOP = (FD_instr !== 16'b0000) ? ((read_RS && (FD_Rd == instr[10:8] || DX_Rd == instr[10:8] || XM_Rd == instr[10:8])) ||
             (read_RT && (FD_Rd == instr[7:5] || DX_Rd == instr[7:5] || XM_Rd == instr[7:5]))) : 1'b0;


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

endmodule