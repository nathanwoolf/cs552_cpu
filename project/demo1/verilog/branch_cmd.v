`default_nettype none
module branch_cmd (  input [2:0]brControl,
                     input ZF,
                     input SF,
                     input OF,
                     input CF,
                     output brSel);


    assign brSel = brControl[2] ?   (brControl[1:0] == 2'b00) ? ZF:  
                                    (brControl[1:0] == 2'b01) ? ~ZF:  
                                    (brControl[1:0] == 2'b10) ? SF:  
                                    (brControl[1:0] == 2'b11) ? ZF | ~SF:   
                                    : 1'b0;





endmodule
`default_nettype wire
