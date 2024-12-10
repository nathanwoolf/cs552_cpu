/*
    CS/ECE 552 FALL '22
    Homework #2, Problem 1
    
    a 1-bit full adder
*/
module fullAdder_1b(s, c_out, a, b, c_in);
    output s;
    output c_out;
	input  a, b;
    input  c_in;

    // YOUR CODE HERE
    assign c_out = (a & b) | ((a ^ b) & c_in); 
    assign s =  (a ^ b) ^ c_in;

    /*
    wire a_xor_b, a_and_b, not_a_and_b, cin_and_int, not_cin_and_int, cout_int;

    //S output logic
    xor2 x1(a, b, a_xor_b); 
    xor2 x2(c_in, a_xor_b, s);
    
    //Cout output logic
    nand2 and1(a, b, a_and_b); 
    not1 n1(a_and_b, not_a_and_b); 
    
    nand2 and2(c_in, a_xor_b, cin_and_int); 
    not1 n2(cin_and_int, not_cin_and_int);

    nor2 or1(not_cin_and_int, not_a_and_b, cout_int); 
    not1 n3(cout_int, c_out);   
    */

endmodule
