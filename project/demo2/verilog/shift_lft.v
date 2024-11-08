module shift_lft(In, ShAmt, Out); 
    input [15:0]In; 
    input [3:0]ShAmt;
    output [15:0]Out; 

    wire [15:0] shft_0, shft_1, shft_2;
    
    assign shft_0 = (ShAmt[0]) ? {In[14:0], 1'b0}               : In;
    assign shft_1 = (ShAmt[1]) ? {shft_0[13:0], 2'b00}          : shft_0;
    assign shft_2 = (ShAmt[2]) ? {shft_1[11:0], 4'b0000}        : shft_1;
    assign Out =    (ShAmt[3]) ? {shft_2[7:0],  8'b00000000}    : shft_2; 

endmodule