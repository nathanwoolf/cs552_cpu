module FD_pipe(
    input wire clk,                 input wire rst, 
    input wire stall,
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
wire [15:0] instr_m;
assign instr_m = stall ? FD_instr : instr;
dff INSTR[15:0](.d(instr_m), .q(FD_instr), .clk(clk), .rst(rst));

wire [15:0] pc_inc_m; 
assign pc_inc_m = stall? FD_pc_inc : pc_inc;
dff PC[15:0](.d(pc_inc_m), .q(FD_pc_inc), .clk(clk), .rst(rst | flush));

wire valid_m; 
assign valid_m = stall ? FD_valid : valid;
dff VALID(.d(valid_m), .q(FD_valid), .clk(clk), .rst(rst | flush));

wire forward_XX_A_m; 
assign forward_XX_A_m = stall ? FD_forward_XX_A : forward_XX_A;
dff FORWARD_XX_A(.d(forward_XX_A_m), .q(FD_forward_XX_A), .clk(clk), .rst(rst | flush));

wire forward_XX_B_m;
assign forward_XX_B_m = stall ? FD_forward_XX_B : forward_XX_B; 
dff FORWARD_XX_B(.d(forward_XX_B_m), .q(FD_forward_XX_B), .clk(clk), .rst(rst | flush));

wire forward_XM_A_m; 
assign forward_XM_A_m = stall ? FD_forward_XM_A : forward_XM_A;
dff FORWARD_XM_A(.d(forward_XM_A_m), .q(FD_forward_XM_A), .clk(clk), .rst(rst | flush));

wire forward_XM_B_m; 
assign forward_XM_B_m = stall ? FD_forward_XM_B : forward_XM_B;
dff FORWARD_XM_B(.d(forward_XM_B_m), .q(FD_forward_XM_B), .clk(clk), .rst(rst | flush));

wire [1:0] forward_XX_sel_m; 
assign forward_XX_sel_m = stall ? FD_forward_XX_sel : forward_XX_sel;
dff FORWORD_XX_SEL[1:0](.d(forward_XX_sel_m), .q(FD_forward_XX_sel), .clk(clk), .rst(rst | flush));

wire [1:0] forward_XM_sel_m;
assign forward_XM_sel_m = stall ? FD_forward_XM_sel : forward_XM_sel;
dff FORWORD_XM_SEL[1:0](.d(forward_XM_sel_m), .q(FD_forward_XM_sel), .clk(clk), .rst(rst | flush));

wire flush_m; 
assign flush_m = stall ? FD_flush : flush;
dff FORWARD_FLUSH(.d(flush_m), .q(FD_flush), .clk(clk), .rst(rst));

wire flush_again_m;
assign flush_again_m = stall ? FD_flush_again : flush_again;
dff FORWARD_FLUSH_AGAIN(.d(flush_again_m), .q(FD_flush_again), .clk(clk), .rst(rst));

wire flush_final_m; 
assign flush_final_m = stall ? FD_flush_final : flush_final;
dff FORWARD_FLUSH_FINAL(.d(flush_final_m), .q(FD_flush_final), .clk(clk), .rst(rst));

endmodule