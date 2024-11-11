module FD_pipe(
    input clk, input rst,
    input wire [15:0] instr,        output wire [15:0] FD_instr, 
    input wire [15:0] pc_inc,       output wire [15:0] FD_pc_inc,
); 

//not entirely sure how to do write_data... coming from writeback
dff INSTR[15:0](.d(instr), .q(FD_instr), .clk(clk), .rst(rst));
dff PC[15:0](.d(pc_inc), .q(FD_pc_inc), .clk(clk), .rst(rst));

endmodule