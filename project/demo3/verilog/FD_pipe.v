module FD_pipe(
    input wire clk,                 input wire rst,
    input wire [15:0] instr,        output wire [15:0] FD_instr, 
    input wire [15:0] pc_inc,       output wire [15:0] FD_pc_inc,
    input wire valid,               output wire FD_valid,
    input wire forward_XX_A,        output wire FD_forward_XX_A,
    input wire forward_XX_B,        output wire FD_forward_XX_B,
    input wire forward_XM_A,        output wire FD_forward_XM_A,
    input wire forward_XM_B,        output wire FD_forward_XM_B,
    input wire [1:0]forward_XX_sel, output wire [1:0]FD_forward_XX_sel,
    input wire [1:0]forward_XM_sel, output wire [1:0]FD_forward_XM_sel,
    input wire flush,               output wire FD_flush,
    input wire flush_again,         output wire FD_flush_again,
    input wire flush_final,         output wire FD_flush_final

); 

dff INSTR[15:0](.d(instr), .q(FD_instr), .clk(clk), .rst(rst));
dff PC[15:0](.d(pc_inc), .q(FD_pc_inc), .clk(clk), .rst(rst | flush));
dff VALID(.d(valid), .q(FD_valid), .clk(clk), .rst(rst | flush));


dff FORWARD_XX_A(.d(forward_XX_A), .q(FD_forward_XX_A), .clk(clk), .rst(rst | flush));
dff FORWARD_XX_B(.d(forward_XX_B), .q(FD_forward_XX_B), .clk(clk), .rst(rst | flush));
dff FORWARD_XM_A(.d(forward_XM_A), .q(FD_forward_XM_A), .clk(clk), .rst(rst | flush));
dff FORWARD_XM_B(.d(forward_XM_B), .q(FD_forward_XM_B), .clk(clk), .rst(rst | flush));
dff FORWORD_XX_SEL[1:0](.d(forward_XX_sel), .q(FD_forward_XX_sel), .clk(clk), .rst(rst | flush));
dff FORWORD_XM_SEL[1:0](.d(forward_XM_sel), .q(FD_forward_XM_sel), .clk(clk), .rst(rst | flush));
dff FORWARD_FLUSH(.d(flush), .q(FD_flush), .clk(clk), .rst(rst));
dff FORWARD_FLUSH_AGAIN(.d(flush_again), .q(FD_flush_again), .clk(clk), .rst(rst));
dff FORWARD_FLUSH_FINAL(.d(flush_final), .q(FD_flush_final), .clk(clk), .rst(rst));



endmodule