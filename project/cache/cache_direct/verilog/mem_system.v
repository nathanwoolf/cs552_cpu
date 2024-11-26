/* $Author: karu $ */
/* $LastChangedDate: 2009-04-24 09:28:13 -0500 (Fri, 24 Apr 2009) $ */
/* $Rev: 77 $ */

`default_nettype none
module mem_system(/*AUTOARG*/
   // Outputs
   DataOut, Done, Stall, CacheHit, err,
   // Inputs
   Addr, DataIn, Rd, Wr, createdump, clk, rst
   );
   
   input wire [15:0] Addr;
   input wire [15:0] DataIn;
   input wire        Rd;
   input wire        Wr;
   input wire        createdump;
   input wire        clk;
   input wire        rst;
   
   output wire [15:0] DataOut;
   output wire        Done;
   output wire        Stall;
   output wire        CacheHit;
   output wire        err;

   // Cache Outputs
   wire [15:0] cache_data_out;
   wire [4:0] cache_tag_out, cache_tag_in;
   wire cache_hit, cache_dirty, cache_valid, cache_err;

   // Cache Inputs
   wire [7:0] cache_index;
   wire [2:0] cache_offset;
   wire [15:0] cache_data_in;
   wire cache_comp, cache_write, cache_valid_in, cache_enable;

   // Mem Outputs
   wire [15:0] mem_data_out;
   wire [3:0] mem_busy;
   wire mem_stall, mem_err;

   // Mem Inputs
   wire [15:0] mem_addr, mem_data_in;
   wire mem_wr, mem_rd;
   
   // Controller Outputs for DataOut
   wire [15:0] temp_DataOut, control_DataOut;
   wire State;


   /* data_mem = 1, inst_mem = 0 *
    * needed for cache parameter */
   parameter memtype = 0;
   cache #(0 + memtype) c0(// Outputs
                          .tag_out              (cache_tag_out),
                          .data_out             (cache_data_out),
                          .hit                  (cache_hit),
                          .dirty                (cache_dirty),
                          .valid                (cache_valid),
                          .err                  (cache_err),

                          // Inputs
                          .clk                  (clk),
                          .rst                  (rst),
                          .createdump           (createdump),

                          .enable               (cache_enable),
                          .tag_in               (cache_tag_in),
                          .index                (cache_index),
                          .offset               (cache_offset),
                          .data_in              (cache_data_in),
                          .comp                 (cache_comp),
                          .write                (cache_write),
                          .valid_in             (cache_valid_in));

   four_bank_mem mem(// Outputs
                     .data_out          (mem_data_out),
                     .stall             (mem_stall),
                     .busy              (mem_busy),
                     .err               (mem_err),

                     // Inputs
                     .clk               (clk),
                     .rst               (rst),
                     .createdump        (createdump),

                     .addr              (mem_addr),
                     .data_in           (mem_data_in),
                     .wr                (mem_wr),
                     .rd                (mem_rd));
   
   // your code here
   cache_control control(// Outputs
                     .cache_enable          (cache_enable),
                     .cache_tag_in          (cache_tag_in),
                     .cache_index           (cache_index),
                     .cache_offset          (cache_offset),
                     .cache_data_in         (cache_data_in),
                     .cache_comp            (cache_comp),
                     .cache_write           (cache_write),
                     .cache_valid_in        (cache_valid_in),

                     .mem_addr              (mem_addr),
                     .mem_data_in           (mem_data_in),
                     .mem_wr                (mem_wr),
                     .mem_rd                (mem_rd),
                     
                     .control_DataOut       (control_DataOut), 
                     .Done                  (Done), 
                     .Stall                 (Stall), 
                     .CacheHit              (CacheHit), 
                     .State                 (State),

                     // Inputs
                     .clk                   (clk),
                     .rst                   (rst),
                     .createdump            (createdump),
                     
                     .temp_DataOut          (temp_DataOut), // TODO ? 
                     .Addr                  (Addr),
                     .DataIn                (DataIn),
                     .Rd                    (Rd),
                     .Wr                    (Wr),

                     .cache_tag_out         (cache_tag_out),
                     .cache_data_out        (cache_data_out),
                     .cache_hit             (cache_hit),
                     .cache_dirty           (cache_dirty),
                     .cache_valid           (cache_valid),
                     
                     .mem_data_out          (mem_data_out));



   assign DataOut = State ? control_DataOut : temp_DataOut;

   dff DATA[15:0](.q(temp_DataOut), .d(control_DataOut), .clk(clk), .rst(rst)); // TODO check this

endmodule // mem_system
`default_nettype wire
// DUMMY LINE FOR REV CONTROL :9:
