/*
    CS/ECE 552 FALL '22
    Homework #2, Problem 1
    
    a 16-bit CLA module
*/
module cla_16b(sum, c_out, a, b, c_in);

    // declare constant for size of inputs, outputs (N)
    parameter   N = 16;

    output [N-1:0] sum;
    output         c_out;
    input [N-1: 0] a, b;
    input          c_in;

    wire [2:0]carry; 

    // YOUR CODE HERE
    cla_4b CLA1(.sum(sum[3:0]), .c_out(carry[0]), .a(a[3:0]), .b(b[3:0]), .c_in(c_in));
    cla_4b CLA2(.sum(sum[7:4]), .c_out(carry[1]), .a(a[7:4]), .b(b[7:4]), .c_in(carry[0]));
    cla_4b CLA3(.sum(sum[11:8]), .c_out(carry[2]), .a(a[11:8]), .b(b[11:8]), .c_in(carry[1]));
    cla_4b CLA4(.sum(sum[15:12]), .c_out(c_out), .a(a[15:12]), .b(b[15:12]), .c_in(carry[2]));

endmodule
