module set_if(  input zf,
                input of, 
                input cf, 
                input [15:0]aluOut, 
                input setif, 
                output [15:0]setifout);

    assign setifout =   (zf | ~aluOut[15] | cf) ? 16'h0001 : 16'h0000;
endmodule