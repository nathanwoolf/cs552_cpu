/*
   CS/ECE 552 Spring '24
  
   Filename        : mux4_1_16b.v
   Description     : This is the module is a 4 to 1 mux used throughout the design
*/
module mux4_1_16b ( input [1:0] sel,
                    input [15:0]inp0, 
                    input [15:0]inp1, 
                    input [15:0]inp2,
                    input [15:0]inp3,
                    output [15:0]out);

    wire [15:0]mux1out, mux2out;

    assign mux1out = (sel[0]) ? inp1 : inp0;
    assign mux2out = (sel[0]) ? inp3 : inp2;

    assign out = (sel[1]) ? mux2out : mux1out;

endmodule