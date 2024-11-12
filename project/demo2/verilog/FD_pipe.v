module FD_pipe(
    input wire clk, input wire rst,
    input wire [15:0] instr,        output wire [15:0] FD_instr, 
    input wire [15:0] pc_inc,       output wire [15:0] FD_pc_inc,
    input wire valid,               output wire FD_valid
); 

dff INSTR[15:0](.d(instr), .q(FD_instr), .clk(clk), .rst(rst));
dff PC[15:0](.d(pc_inc), .q(FD_pc_inc), .clk(clk), .rst(rst));
dff VALID(.d(valid), .q(FD_valid), .clk(clk), .rst(rst));

endmodule