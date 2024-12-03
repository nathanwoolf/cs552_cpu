module cache_control(
    output reg cache_enable,
    output reg [4:0] cache_tag_in,
    output reg [7:0] cache_index,
    output reg [2:0] cache_offset,
    output reg [15:0] cache_data_in,
    output reg cache_comp,           
    output reg cache_write,           
    output reg cache_valid_in,     
    
    output reg [15:0] mem_addr,           
    output reg [15:0] mem_data_in,          
    output reg mem_wr,                
    output reg mem_rd,                

    output reg [15:0] control_DataOut,         
    output reg Done,                  
    output reg Stall,                 
    output reg CacheHit,              
    output reg State,     

    input wire clk,                   
    input wire rst,                   
    input wire createdump,

    input wire [15:0] temp_DataOut,
    input wire [15:0] Addr,                  
    input wire [15:0] DataIn,                
    input wire Rd,                   
    input wire Wr,                   
    
    input wire [4:0] cache_tag_out,         
    input wire [15:0] cache_data_out,       
    input wire cache_hit,             
    input wire cache_dirty,           
    input wire cache_valid,
    input wire [15:0] mem_data_out           
);
// TODO add correct widths for module in/out sigs

    localparam IDLE = 4'b0000;
    localparam COMPARE_READ = 4'b0010; 
    localparam COMPARE_WRITE = 4'b0011; 
    localparam ACCESS_READ_1 = 4'b0100; 
    localparam ACCESS_READ_2 = 4'b0101; 
    localparam ACCESS_READ_3 = 4'b0110; 
    localparam ACCESS_READ_4 = 4'b0111; 
    localparam ACCESS_WRITE_1 = 4'b1000; 
    localparam ACCESS_WRITE_2 = 4'b1001; 
    localparam ACCESS_WRITE_3 = 4'b1010;
    localparam ACCESS_WRITE_4 = 4'b1011;
    localparam ACCESS_WRITE_5 = 4'b1100;
    localparam ACCESS_WRITE_6 = 4'b1101; 
    localparam DONE = 4'b0001; 

    wire[3:0] state;
    reg [3:0 ]nxt_state;

    dff STATE[3:0](.q(state), .d(nxt_state), .clk(clk), .rst(rst));

    wire hit_ff_q;
    reg hit_ff_d;
    dff HIT(.q(hit_ff_q), .d(hit_ff_d), .clk(clk), .rst(rst));

    wire wr_ff_q;
    reg wr_ff_d;
    dff WR(.q(wr_ff_q), .d(wr_ff_d), .clk(clk), .rst(rst));

    wire rd_ff_q;
    reg rd_ff_d;
    dff RD(.q(rd_ff_q), .d(rd_ff_d), .clk(clk), .rst(rst));

    always @* begin
        // Defaults
        nxt_state = IDLE;

        cache_enable = 1'b0;
        cache_valid_in = 1'b0; 
        cache_tag_in = 5'hxxxx;
        cache_index = 8'hxxxxxxxx;
        cache_offset = 3'hxxx;
        
        cache_data_in = 16'hxxxxxxxxxxxxxxxx;

        cache_comp = 1'b0;           
        cache_write = 1'b0;     
        

        mem_wr = 1'b0;
        mem_rd = 1'b0;
        mem_addr = 16'hxxxxxxxxxxxxxxxx;
        mem_data_in = 16'hxxxxxxxxxxxxxxxx;


        // control_DataOut = 16'h0000;
        Done = 1'b0;
        Stall = 1'b1; // TODO Check num stalls?
        CacheHit = 1'b0;
        State = 1'b0;

        case(state)
            IDLE: begin
                Stall = 1'b0;
                wr_ff_d = 1'b0;
                rd_ff_d = 1'b0;
                nxt_state = Rd ? (COMPARE_READ) : (Wr ? (COMPARE_WRITE) : (IDLE));
            end
            COMPARE_READ: begin

                cache_tag_in =  Addr[15:11];
                cache_index = Addr[10:3];
                cache_offset = Addr[2:0];

                cache_enable = 1'b1;
                cache_comp = 1'b1;
                control_DataOut = cache_data_out;

                hit_ff_d = 1'b1;
                rd_ff_d = 1'b1;
                nxt_state = (cache_valid) ? (cache_hit) ? DONE : (cache_dirty) ? ACCESS_READ_1 : ACCESS_WRITE_1 : ACCESS_WRITE_1;
            end
            COMPARE_WRITE: begin

                cache_tag_in =  Addr[15:11];
                cache_index = Addr[10:3];
                cache_offset = Addr[2:0];

                cache_enable = 1'b1;
                cache_comp = 1'b1;
                cache_write = 1'b1;
                cache_data_in = DataIn;

                hit_ff_d = 1'b1;
                wr_ff_d = 1'b1;
                nxt_state = (cache_valid) ? (cache_hit) ? DONE : (cache_dirty) ? ACCESS_READ_1 : ACCESS_WRITE_1 : ACCESS_WRITE_1;
            end
            ACCESS_READ_1: begin

                mem_addr = {cache_tag_out, Addr[10:3], 3'b000};
                cache_offset = 3'b000;
                cache_index = Addr[10:3];
                cache_enable = 1'b1;
                mem_wr = 1'b1;
                mem_data_in = cache_data_out;
                nxt_state = ACCESS_READ_2;
            end
            ACCESS_READ_2: begin

                mem_addr = {cache_tag_out, Addr[10:3], 3'b010};
                cache_offset = 3'b010;
                cache_index = Addr[10:3];
                cache_enable = 1'b1;
                mem_wr = 1'b1;
                mem_data_in = cache_data_out;
                nxt_state = ACCESS_READ_3;
            end
            ACCESS_READ_3: begin

                mem_addr = {cache_tag_out, Addr[10:3], 3'b100};
                cache_offset = 3'b100;
                cache_index = Addr[10:3];
                cache_enable = 1'b1;
                mem_wr = 1'b1;
                mem_data_in = cache_data_out;
                nxt_state = ACCESS_READ_4;
            end
            ACCESS_READ_4: begin

                mem_addr = {cache_tag_out, Addr[10:3], 3'b110};
                cache_offset = 3'b110;
                cache_index = Addr[10:3];
                cache_enable = 1'b1;
                mem_wr = 1'b1;
                mem_data_in = cache_data_out;
                nxt_state = ACCESS_WRITE_1;
            end
            ACCESS_WRITE_1: begin

                cache_enable = 1'b1;
                mem_rd = 1'b1;
                mem_addr = {Addr[15:3],3'b000};
                hit_ff_d = 1'b0;
                nxt_state = ACCESS_WRITE_2;
            end
            ACCESS_WRITE_2: begin

                cache_enable = 1'b1;
                mem_rd = 1'b1;
                mem_addr = {Addr[15:3],3'b010};
                nxt_state = ACCESS_WRITE_3;
            end
            ACCESS_WRITE_3: begin

                cache_enable = 1'b1;
                mem_rd = 1'b1;
                mem_addr = {Addr[15:3],3'b100};
                
                cache_write = 1'b1;
                cache_valid_in = 1'b1;

                cache_tag_in = Addr[15:11];
                cache_index = Addr[10:3];
                cache_offset = 3'b000;

                cache_data_in = (Wr & (Addr[2:0] === 3'b000)) ? DataIn : mem_data_out;
                control_DataOut = (Rd & (Addr[2:0] === 3'b000)) ? mem_data_out : temp_DataOut;
                nxt_state = ACCESS_WRITE_4;
            end
            ACCESS_WRITE_4: begin

                cache_enable = 1'b1;
                mem_rd = 1'b1;
                mem_addr = {Addr[15:3],3'b110};
                
                cache_write = 1'b1;
                cache_valid_in = 1'b1;

                cache_tag_in = Addr[15:11];
                cache_index = Addr[10:3];
                cache_offset = 3'b010;

                cache_data_in = (Wr & (Addr[2:0] === 3'b010)) ? DataIn : mem_data_out;
                control_DataOut = (Rd & (Addr[2:0] === 3'b010)) ? mem_data_out : temp_DataOut;
                nxt_state = ACCESS_WRITE_5;
            end
            ACCESS_WRITE_5: begin

                cache_enable = 1'b1;
                
                cache_write = 1'b1;
                cache_valid_in = 1'b1;

                cache_tag_in = Addr[15:11];
                cache_index = Addr[10:3];
                cache_offset = 3'b100;

                cache_data_in = (Wr & (Addr[2:0] === 3'b100)) ? DataIn : mem_data_out;
                control_DataOut = (Rd & (Addr[2:0] === 3'b100)) ? mem_data_out : temp_DataOut;
                nxt_state = ACCESS_WRITE_6;
            end
            ACCESS_WRITE_6: begin

                cache_enable = 1'b1;
                cache_write = 1'b1;
                cache_valid_in = 1'b1;
                cache_comp = wr_ff_q;
                
                cache_tag_in = Addr[15:11];
                cache_index = Addr[10:3];
                cache_offset = 3'b110;
                
                cache_data_in = (wr_ff_q & (Addr[2:0] === 3'b110)) ? DataIn : mem_data_out;
                control_DataOut = (rd_ff_q & (Addr[2:0] === 3'b110)) ? mem_data_out : temp_DataOut;
                
                Done = 1'b1;
                State = 1'b1;
                nxt_state = IDLE; // IDLE?
            end
            DONE: begin

                Done = 1'b1;
                CacheHit = hit_ff_q;
                nxt_state = IDLE;
            end
        endcase

    end
endmodule