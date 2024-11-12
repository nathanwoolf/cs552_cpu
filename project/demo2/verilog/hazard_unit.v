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

// RS is [10:8], RT is [7:5]
assign NOP = (read_RS && (FD_instr[10:8] == instr[10:8] || DX_instr[10:8] == instr[10:8] || XM_instr[10:8] == instr[10:8])) ||
             (read_RT && (FD_instr[7:5] == instr[7:5] || DX_instr[7:5] == instr[7:5] || XM_instr[7:5] == instr[7:5]));

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
        5'b110??: begin 
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