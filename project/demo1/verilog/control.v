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
        5'b010??: begin 
            //unconditional assigns 
            aluSrc = 2'b10; 
            regWrite = 1'b1; 
            memRead = 1'b0; 
            memWrite = 1'b0; 
            immSource = 1'bx; 
            aluOp = opcode[2:0]; 
            brControl = 1'bx;

            assign zeroExt = (opcode[2]) ? 1 : 0; 
            assign invA = (opcode[1:0] == 2'b01) ? 1 : 0;
            assign cin = (opcode[1:0] == 2'b01) ? 1 : 0;
            assign invB = (opcode[1:0] == 2'b11) ? 1 : 0;
        end 

    endcase 
end 
   
endmodule
`default_nettype wire