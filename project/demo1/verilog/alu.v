/*
    CS/ECE 552 FALL '22
    Homework #2, Problem 3

    A multi-bit ALU module (defaults to 16-bit). It is designed to choose
    the correct operation to perform on 2 multi-bit numbers from rotate
    left, shift left, shift right arithmetic, shift right logical, add,
    or, xor, & and.  Upon doing this, it should output the multi-bit result
    of the operation, as well as drive the output signals Zero and Overflow
    (OFL).
*/
module alu (InA, InB, Cin, Oper, invA, invB, sign, Out, Zero, Ofl, SF, CF);

    parameter OPERAND_WIDTH = 16;    
    parameter NUM_OPERATIONS = 3;
       
    input  [OPERAND_WIDTH -1:0] InA ; // Input operand A
    input  [OPERAND_WIDTH -1:0] InB ; // Input operand B
    input                       Cin ; // Carry in
    input  [NUM_OPERATIONS-1:0] Oper; // Operation type
    input                       invA; // Signal to invert A
    input                       invB; // Signal to invert B
    input                       sign; // Signal for signed operation
    output [OPERAND_WIDTH -1:0] Out ; // Result of computation
    output                      Ofl ; // Signal if overflow occured
    output                      Zero; // Signal if Out is 0
    output                      SF;   // Signal is negative (signed)
    output                      CF; // Carry occurred

    /* YOUR CODE HERE */
    wire [15:0] A, B, shifter_out, alu_out, A_xor_B, A_and_B; 
    wire alu_Cout; 

    assign A = (invA) ? ~InA : InA; 
    assign B = (invB) ? ~InB : InB; 

    shifter shft(.In(A), .ShAmt(B[3:0]), .Oper(Oper[1:0]), .Out(shifter_out));
    cla_16b adder(.sum(alu_out), .c_out(alu_Cout), .a(A), .b(B), .c_in(Cin)); 

    assign A_and_B = A & B; 
    assign A_xor_B = A ^ B; 

//TODO: 
    assign Ofl = sign ? ((A[15] & B[15] & ~alu_out[15]) | (~A[15] & ~B[15] & alu_out[15])) : alu_Cout; 

    assign Out =    (Oper[2]) ? shifter_out : 
                    (~Oper[2] & ~Oper[1]) ? alu_out : 
                    (~Oper[2] & Oper[1] & ~Oper[0]) ? A_xor_B : 
                    (~Oper[2] & Oper[1] & Oper[0]) ? A_and_B : 
                    16'h0000;           //default case - should never happen;

    assign Zero = ~|Out;
    assign SF = sign & Out[15];
    assign CF = alu_Cout;
endmodule