/*
   CS/ECE 552 Spring '22
  
   Filename        : control.v
   Description     : This is the module for the overall decode stage of the processor.
*/
`default_nettype none
module control (input   wire [4:0] opcode, 
                input   wire [1:0] r_typeALU,
                input   wire valid,
                output  reg [1:0] aluSrc, 
                output  reg zeroExt, 
                output  reg [1:0]regSrc,
                output  reg regWrite,
                output  reg [1:0]regDest, 
                output  reg memWrite,
                output  reg memRead,
                output  reg halt, 
                output  reg aluJump, 
                output  reg jump,
                output  reg immSrc, 
                output  reg [2:0]brControl,
                output  reg [1:0]setControl,
                output  reg [2:0]aluOp, 
                output  reg invA, 
                output  reg invB, 
                output  reg cin, 
                output  reg STU,
                output  reg BTR,
                output  reg LBI,
                output  reg setIf);

wire [4:0]sel_opcode;
assign sel_opcode = valid ? opcode : 5'b00001;

always @(*) begin 
    // Default outputs
        aluSrc = 2'b00;
        zeroExt = 1'b0;
        regDest = 2'b00;
        regSrc = 2'b00;
        regWrite = 1'b0; 
        memWrite = 1'b0; 
        memRead = 1'b0;
        aluJump = 1'b0;
        jump = 1'b0;
        immSrc = 1'b0; 
        brControl = 3'b000;
        setControl = 2'b00;

        aluOp = 3'b000;
        invA = 1'b0;
        invB = 1'b0;
        cin = 1'b0;

        STU = 1'b0;
        BTR = 1'b0;
        LBI = 1'b0;
        setIf = 1'b0;
        
        halt = 1'b0;

    casex (sel_opcode)

        // Arithmetic with immediate
        5'b010??: begin 
            aluSrc = 2'b10;
            zeroExt = sel_opcode[1];
            regSrc = 2'b10;
            regWrite = 1'b1; 
            aluOp = (~sel_opcode[1]) ? 3'b000 : sel_opcode[2:0];
            invA = ~sel_opcode[1] & sel_opcode[0];
            invB = sel_opcode[1] & sel_opcode[0];
            cin = ~sel_opcode[1] & sel_opcode[0];
        end

        // Shift with immediate
        5'b101??: begin 
            aluSrc = 2'b10; 
            regSrc = 2'b10;
            regWrite = 1'b1; 
            aluOp = sel_opcode[2:0]; 
        end

        // ST
        5'b10000: begin 
            aluSrc = 2'b10; 
            memWrite = 1'b1;
            STU = 1'b1; // TODO rename?
        end

        // LD
        5'b10001: begin 
            aluSrc = 2'b10; 
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
            STU = 1'b1;
        end

        // BTR
        5'b11001: begin 
            regDest = 2'b10;
            regSrc = 2'b11;
            regWrite = 1'b1; 
            BTR = 1'b1;
        end

        // Arithmetic with registers
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
            regDest = 2'b10;
            regSrc = 2'b11;
            regWrite = 1'b1; 
            invB = (sel_opcode[0] & sel_opcode[1]) ? 1'b0 : 1'b1;
            cin = (sel_opcode[0] & sel_opcode[1]) ? 1'b0 : 1'b1;
            setIf = 1'b1;
            setControl = sel_opcode[1:0];
        end

        // Branch
        5'b011??: begin 
            aluSrc = 2'b11;
            immSrc = 1'b1;
            brControl = {1'b1, sel_opcode[1:0]};
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
        5'b10010: begin 
            regDest = 2'b01;
            regSrc = 2'b11;
            regWrite = 1'b1;
        end

        // Jump
        5'b001??: begin 
            regDest = 2'b11;
            regWrite = sel_opcode[1];
            aluJump = sel_opcode[0];
            immSrc = sel_opcode[0]; 
            jump = 1'b1;
            aluSrc = 1'b1;
        end
        // TODO: NOP, SIIC, RTI
        5'b00001: begin
            halt = 1'b0;
        end

        // Halt
        5'b00000: begin
            halt = 1'b1;
        end

    endcase 
end 
   
endmodule
`default_nettype wire