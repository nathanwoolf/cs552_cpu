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
   wire [15:0] cache_data_out_0;
   wire [15:0] cache_data_out_1;
   wire [15:0] cache_data_out_final;

   wire [4:0] cache_tag_out_0;
   wire [4:0] cache_tag_out_1;
   wire [4:0] cache_tag_out_final;

   wire [4:0] cache_tag_in;
   
   wire cache_hit_0, cache_dirty_0, cache_valid_0, cache_err_0;
   wire cache_hit_1, cache_dirty_1, cache_valid_1, cache_err_1;
   wire cache_hit_valid_0;
   wire cache_hit_valid_1;
   wire cache_hit_final;
   


   // Cache Inputs
   wire [7:0] cache_index;
   wire [2:0] cache_offset;
   wire [15:0] cache_data_in;
   wire cache_comp, cache_write, cache_valid_in;
   
   wire cache_enable_0;
   wire cache_enable_1;
   wire cache_enable;

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


   wire compare_rw_flag;
   wire ff_victimize_d, ff_victimize_q;

   wire Idle;

   /* data_mem = 1, inst_mem = 0 *
    * needed for cache parameter */
   parameter memtype = 0;
   cache #(0 + memtype) c0(// Outputs
                          .tag_out              (cache_tag_out_0),
                          .data_out             (cache_data_out_0),
                          .hit                  (cache_hit_0),
                          .dirty                (cache_dirty_0),
                          .valid                (cache_valid_0),
                          .err                  (cache_err_0),

                          // Inputs
                          .clk                  (clk),
                          .rst                  (rst),
                          .createdump           (createdump),

                          .enable               (cache_enable_0),
                          .tag_in               (cache_tag_in),
                          .index                (cache_index),
                          .offset               (cache_offset),
                          .data_in              (cache_data_in),
                          .comp                 (cache_comp),
                          .write                (cache_write),
                          .valid_in             (cache_valid_in));

   cache #(2 + memtype) c1(// Outputs
                          .tag_out              (cache_tag_out_1),
                          .data_out             (cache_data_out_1),
                          .hit                  (cache_hit_1),
                          .dirty                (cache_dirty_1),
                          .valid                (cache_valid_1),
                          .err                  (cache_err_1),

                          // Inputs
                          .clk                  (clk),
                          .rst                  (rst),
                          .createdump           (createdump),

                          .enable               (cache_enable_1),
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
                     .cache_enable             (cache_enable),
                     .cache_tag_in             (cache_tag_in),
                     .cache_index              (cache_index),
                     .cache_offset             (cache_offset),
                     .cache_data_in            (cache_data_in),
                     .cache_comp               (cache_comp),
                     .cache_write              (cache_write),
                     .cache_valid_in           (cache_valid_in),

                     .mem_addr                 (mem_addr),
                     .mem_data_in              (mem_data_in),
                     .mem_wr                   (mem_wr),
                     .mem_rd                   (mem_rd),
                     
                     .control_DataOut          (control_DataOut), 
                     .Done                     (Done), 
                     .Stall                    (Stall), 
                     .CacheHit                 (CacheHit), 
                     .State                    (State),

                     .ff_victimize_q_control   (ff_victimize_d),
                     .compare_rw_flag          (compare_rw_flag),

                     .Idle                     (Idle),
                                          
                     
                     // Inputs
                     .clk                      (clk),
                     .rst                      (rst),
                     .createdump               (createdump),

                     .temp_DataOut             (temp_DataOut),
                     .Addr                     (Addr),
                     .DataIn                   (DataIn),
                     .Rd                       (Rd),
                     .Wr                       (Wr),

                     .cache_tag_out_final      (cache_tag_out_final),
                     .cache_data_out_final     (cache_data_out_final),
                     .cache_hit_final          (cache_hit_final),

                     .cache_hit_0              (cache_hit_0),
                     .cache_dirty_0            (cache_dirty_0),
                     .cache_valid_0            (cache_valid_0),

                     .cache_hit_1              (cache_hit_1),
                     .cache_dirty_1            (cache_dirty_1),
                     .cache_valid_1            (cache_valid_1),
                  
                     .mem_data_out             (mem_data_out),
                     
                     .ff_victimize_d_control   (ff_victimize_q));


   assign cache_enable_0 = Idle ? 1'b0 : (compare_rw_flag | cache_enable);
   assign cache_enable_1 = Idle ? 1'b0 : (compare_rw_flag | ~cache_enable);

   assign cache_tag_out_final = cache_enable ? cache_tag_out_0 : cache_tag_out_1;
   assign cache_data_out_final = cache_enable ? cache_data_out_0 : cache_data_out_1;

   assign cache_hit_valid_0 = cache_valid_0 & cache_hit_0;
   assign cache_hit_valid_1 = cache_valid_1 & cache_hit_1;
   assign cache_hit_final = cache_valid_0 & cache_hit_0 | cache_valid_1 & cache_hit_1;

   assign DataOut = State ? control_DataOut : temp_DataOut;
   dff DATA[15:0](.q(temp_DataOut), .d(control_DataOut), .clk(clk), .rst(rst));

   dff VICTIM(.q(ff_victimize_q), .d(ff_victimize_d), .clk(clk), .rst(rst)); // TODO check this

   assign err = cache_err_0 | cache_err_1 | mem_err;

endmodule // mem_system
`default_nettype wire
// DUMMY LINE FOR REV CONTROL :9:
