/*
    CS/ECE 552 FALL'22
    Homework #2, Problem 1
    
    a 4-bit CLA module
*/
module cla_4b(sum, c_out, a, b, c_in);

    // declare constant for size of inputs, outputs (N)
    parameter   N = 4;

    output [N-1:0] sum;
    output         c_out;
    input [N-1: 0] a, b;
    input          c_in;

    wire [3:0] c, g, p;
    // YOUR CODE HERE
    
    //assign bitwise propogate and generate bits
    assign p = a ^ b;
    assign g = a & b;

    //assign carry bits 
    assign c[0] = c_in;
    assign c[1] = g[0] | (p[0] & c_in); 
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]); 
    assign c_out = g[3] | (p[3] & c[3]); 

    // assign outputs for sum
    assign sum[0] = p[0] ^ c[0];
    assign sum[1] = p[1] ^ c[1]; 
    assign sum[2] = p[2] ^ c[2]; 
    assign sum[3] = p[3] ^ c[3];

endmodule
