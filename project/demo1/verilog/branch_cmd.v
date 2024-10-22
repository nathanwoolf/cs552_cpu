`default_nettype none
module branch_cmd (  input wire [2:0]brControl,
                     input wire ZF,
                     input wire SF,
                     input wire OF,
                     input wire CF,
                     output wire brSel);

    assign brSel = brControl[2] ?   (brControl[1:0] == 2'b00) ? ZF:  
                                    (brControl[1:0] == 2'b01) ? ~ZF:  
                                    (brControl[1:0] == 2'b10) ? SF:  
                                    (ZF | ~SF)   
                                    :1'b0;





endmodule
`default_nettype wire
