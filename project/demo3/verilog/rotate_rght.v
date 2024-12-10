module rotate_rght(In, ShAmt, Out); 
    input [15:0]In; 
    input [3:0]ShAmt;
    output [15:0]Out;

    wire [15:0] shft_0, shft_1, shft_2;

    //fill MSB's shifted out with zero
    assign shft_0 = (ShAmt[0]) ? {In[0],     In[15:1]}          : In;
    assign shft_1 = (ShAmt[1]) ? {shft_0[1:0], shft_0[15:2]}    : shft_0;
    assign shft_2 = (ShAmt[2]) ? {shft_1[3:0], shft_1[15:4]}    : shft_1;
    assign Out =    (ShAmt[3]) ? {shft_2[7:0],  shft_2[15:8]}   : shft_2; 
endmodule
