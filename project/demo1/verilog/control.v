/*
   CS/ECE 552 Spring '22
  
   Filename        : control.v
   Description     : This is the module for the overall decode stage of the processor.
*/
`default_nettype none
module decode ( input   [4:0] opcode, 
                input   [1:0] r_typeALU
                output  reg [1:0] aluSrc, 
                output  reg zeroExt, 
                output  reg memToReg, 
                output  reg regWrite, 
                output  reg memRead, 
                output  reg memWrite, 
                output  reg jump, 
                output  reg immSource, 
                output  reg [2:0]aluOp, 
                output  reg invA, 
                output  reg invB, 
                output  reg cin, 
                output  reg [1:0]brControl);

always @(*) begin 
    casex (opcode)

        // Arithmatic with immediate
        5'b010??: begin 
            aluSrc = 2'b10;
            zeroExt = (opcode[2]) ? 1 : 0;
            memToReg = 0;
            regWrite = 1'b1; 
            memRead = 1'b0; 
            memWrite = 1'b0; 
            jump = 1'b0;
            immSource = 1'bx; 
            brControl = 1'bx;

            aluOp = (~opcode[1]) ? 3'b000 : opcode[2:0]; 
            invA = (opcode[1:0] == 2'b01) ? 1'b1 : 1'b0;
            cin = (opcode[1:0] == 2'b01) ? 1'b1 : 1'b0;
            invB = (opcode[1:0] == 2'b11) ? 1'b1 : 1'b0;
        end

        // Shift with immediate
        5'b101??: begin 
            aluSrc = 2'b10; 
            zeroExt = 1'bx;
            memToReg = 1'b0;
            regWrite = 1'b1; 
            memRead = 1'b0; 
            memWrite = 1'b0;
            jump = 1'b0;
            immSource = 1'bx; 
            brControl = 1'bx;

            aluOp = opcode[2:0]; 
            invA = 1'b0;
            cin = 1'b0;
            invB = 1'b0;
        end

        // ST
        5'b10000: begin 
            aluSrc = 2'b10; 
            zeroExt = 1'b0;
            memToReg = 1'b0;
            regWrite = 1'b0; 
            memRead = 1'b0; 
            memWrite = 1'b1;
            jump = 1'b0;
            immSource = 1'bx; 
            brControl = 1'bx;

            aluOp = 3'b000;
            invA = 1'b0;
            cin = 1'b0;
            invB = 1'b0;
        end

        // LD
        5'b10001: begin 
            aluSrc = 2'b10; 
            zeroExt = 1'b0;
            memToReg = 1'b1;
            regWrite = 1'b1; 
            memRead = 1'b1; 
            memWrite = 1'b0;
            jump = 1'b0;
            immSource = 1'bx; 
            brControl = 1'bx;

            aluOp = 3'b000;
            invA = 1'b0;
            cin = 1'b0;
            invB = 1'b0;
        end

        // STU
        5'b10011: begin 
            aluSrc = 2'b10; 
            zeroExt = 1'b0;
            memToReg = 1'b0;
            regWrite = 1'b1; 
            memRead = 1'b0; 
            memWrite = 1'b1;
            jump = 1'b0;
            immSource = 1'bx; 
            brControl = 1'bx;

            aluOp = 3'b000;
            invA = 1'b0;
            cin = 1'b0;
            invB = 1'b0;
        end

        // BTR TODO
        5'b11001: begin 
            aluSrc = 2'b;
            zeroExt = 1'b;
            memToReg = 1'b;
            regWrite = 1'b; 
            memRead = 1'b; 
            memWrite = 1'b;
            jump = 1'b;
            immSource = 1'b; 
            brControl = 1'b;

            aluOp = 3'b;
            invA = 1'b;
            cin = 1'b;
            invB = 1'b;
        end

        // Arithmatic registers
        5'b11011: begin 
            aluSrc = 2'b00;
            zeroExt = 1'bx;
            memToReg = 1'b0;
            regWrite = 1'b1; 
            memRead = 1'b0; 
            memWrite = 1'b0;
            jump = 1'b0;
            immSource = 1'bx; 
            brControl = 1'bx;

            aluOp = ?????????? TODO;
            invA = 1'b;
            cin = 1'b;
            invB = 1'b;
        end

    endcase 
end 
   
endmodule
`default_nettype wire