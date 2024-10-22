/*
   CS/ECE 552 Spring '22
  
   Filename        : control.v
   Description     : This is the module for the overall decode stage of the processor.
*/
`default_nettype none
module control (input   wire [4:0] opcode, 
                input   wire [1:0] r_typeALU,
                output  reg [1:0] aluSrc, 
                output  reg zeroExt, 
                output  reg [1:0]regSrc,
                output  reg regWrite,
                output  reg [1:0]regDest, 
                output  reg memWrite,
                output  reg memRead,
                output  reg halt, 
                output  reg jump, 
                output  reg immSrc, 
                output  reg [2:0]brControl,
                output  reg [2:0]aluOp, 
                output  reg invA, 
                output  reg invB, 
                output  reg cin, 
                output  reg STU,
                output  reg BTR,
                output  reg LBI,
                output  reg setIf);

always @(*) begin 
    // Default outputs
        aluSrc = 2'b00;
        zeroExt = 1'b0;
        regDest = 2'b00;
        regSrc = 2'b00;
        regWrite = 1'b0; 
        memWrite = 1'b0; 
        memRead = 1'b0;
        jump = 1'b0;
        immSrc = 1'b0; 
        brControl = 3'b000;

        aluOp = 3'b000;
        invA = 1'b0;
        invB = 1'b0;
        cin = 1'b0;

        STU = 1'b0;
        BTR = 1'b0;
        LBI = 1'b0;
        setIf = 1'b0;
        
        halt = 1'b0;

    casex (opcode)

        // Arithmatic with immediate
        5'b010??: begin 
            aluSrc = 2'b10;
            zeroExt = (opcode[2]) ? 1 : 0;
            regSrc = 2'b10;
            regWrite = 1'b1; 
            aluOp = (~opcode[1]) ? 3'b000 : opcode[2:0];
            invA = (~opcode[1] & opcode[0]) ? 1'b1 : 1'b0;
            invB = (opcode[1] & opcode[0]) ? 1'b1 : 1'b0;
            cin = (~opcode[1] & opcode[0]) ? 1'b1 : 1'b0;
        end

        // Shift with immediate
        5'b101??: begin 
            aluSrc = 2'b10; 
            regSrc = 2'b10;
            regWrite = 1'b1; 
            aluOp = opcode[2:0]; 
        end

        // ST
        5'b10000: begin 
            aluSrc = 2'b10; 
            memWrite = 1'b1;
        end

        // LD
        5'b10001: begin 
            aluSrc = 2'b01; 
            regSrc = 2'b01;
            regWrite = 1'b1; 
            memRead = 1'b1;
        end

        // STU
        5'b10011: begin 
            aluSrc = 2'b10; 
            regDest = 2'b01;
            regSrc = 2'b10;
            regWrite = 1'b1; 
            memWrite = 1'b1;
        end

        // BTR
        5'b11001: begin 
            regDest = 2'b10;
            regSrc = 2'b11;
            regWrite = 1'b1; 
            BTR = 1'b1;
        end

        // Arithmatic with registers
        5'b11011: begin 
            regDest = 2'b10;
            regSrc = 2'b10;
            regWrite = 1'b1; 
            aluOp = (~r_typeALU[1]) ? 3'b000 : {1'b0, r_typeALU[1:0]};
            invA = (~r_typeALU[1] & r_typeALU[0]) ? 1'b1 : 1'b0;
            invB = (r_typeALU[1] & r_typeALU[0]) ? 1'b1 : 1'b0;
            cin = (~r_typeALU[1] & r_typeALU[0]) ? 1'b1 : 1'b0;

        end

        // Shift with registers
        5'b11010: begin 
            regDest = 2'b10;
            regSrc = 2'b10;
            regWrite = 1'b1; 
            aluOp = {1'b1, r_typeALU[1:0]};
        end

        // Set
        5'b111??: begin 
            aluSrc = 2'b11;
            regDest = 2'b10;
            regSrc = 2'b10;
            regWrite = 1'b1; 
            invB = (opcode[0] & opcode[1]) ? 1'b0 : 1'b1;
            cin = (opcode[0] & opcode[1]) ? 1'b0 : 1'b1;
            setIf = 1'b1;
        end

        // Branch
        5'b011??: begin 
            aluSrc = 2'b10;
            zeroExt = 1'b1;
            brControl = {1'b1, opcode[1:0]};
        end

        // LBI
        5'b11000: begin 
            aluSrc = 2'b11;
            regDest = 2'b01;
            regSrc = 2'b11;
            regWrite = 1'b1;
            LBI = 1'b1;
        end

        // SLBI
        5'b11000: begin 
            zeroExt = 1'b1;
            regDest = 2'b11;
            regSrc = 2'b11;
            regWrite = 1'b1;
        end

        // Jump
        5'b001??: begin 
            regDest = 2'b11;
            regWrite = opcode[1];
            jump = 1'b1;
            immSrc = opcode[0]; 
        end

        // Halt
        5'b00000: begin
            halt = 1'b1;
        end

        // TODO: NOP, SIIC, RTI

    endcase 
end 
   
endmodule
`default_nettype wire