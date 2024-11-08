module shift_rght_logical(In, ShAmt, Out); 
    input [15:0]In; 
    input [3:0]ShAmt;
    output [15:0]Out; 

    wire [15:0] shft_0, shft_1, shft_2;

    //fill MSB's shifted out with zero
    assign shft_0 = (ShAmt[0]) ? {1'b0, In[15:1]} : In;
    assign shft_1 = (ShAmt[1]) ? {2'b00, shft_0[15:2]}  : shft_0;
    assign shft_2 = (ShAmt[2]) ? {4'b0000, shft_1[15:4]}  : shft_1;
    assign Out =    (ShAmt[3]) ? {8'b00000000, shft_2[15:8]}   : shft_2; 
            
endmodule