/*
    CS/ECE 552 FALL '22
    Homework #2, Problem 2
    
    A barrel shifter module.  It is designed to shift a number via rotate
    left, shift left, shift right arithmetic, or shift right logical based
    on the 'Oper' value that is passed in.  It uses these
    shifts to shift the value any number of bits.
 */
module shifter (In, ShAmt, Oper, Out);

    // declare constant for size of inputs, outputs, and # bits to shift
    parameter OPERAND_WIDTH = 16;
    parameter SHAMT_WIDTH   =  4;
    parameter NUM_OPERATIONS = 2;

    input  [OPERAND_WIDTH -1:0] In   ; // Input operand
    input  [SHAMT_WIDTH   -1:0] ShAmt; // Amount to shift/rotate
    input  [NUM_OPERATIONS-1:0] Oper ; // Operation type
    output [OPERAND_WIDTH -1:0] Out  ; // Result of shift/rotate

   /* YOUR CODE HERE */
    wire[15:0] shft_0, shft_1, shft_2; 
    wire[15:0] op_00, op_01, op_10, op_11;

    rotate_lft r_left(.In(In), .ShAmt(ShAmt), .Out(op_00)); 
    shift_lft s_left(.In(In), .ShAmt(ShAmt), .Out(op_01));
    shift_rght_arithmetic s_r_a(.In(In), .ShAmt(ShAmt), .Out(op_10));   //rotate right
    shift_rght_logical s_r_l(.In(In), .ShAmt(ShAmt), .Out(op_11));

    assign Out =    (Oper == 2'b00) ? op_00 :           //rotate left
                    (Oper == 2'b01) ? op_01 :           //shift left logical
                    (Oper == 2'b10) ? op_10 :           //rotate right
                    (Oper == 2'b11) ? op_11 :           //shift right logical
                    16'h0000; 
endmodule