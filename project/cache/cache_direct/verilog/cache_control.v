module cache_control(
    output wire cache_enable,
    output wire [4:0] cache_tag_in,
    output wire [7:0] cache_index,
    output wire [2:0] cache_offset,
    output wire [15:0] cache_data_in,
    output wire cache_comp,           
    output wire cache_write,           
    output wire cache_valid_in,     
    
    output wire [15:0] mem_addr,           
    output wire [15:0] mem_data_in,          
    output wire mem_wr,                
    output wire mem_rd,                

    output wire [15:0] control_DataOut,         
    output wire Done,                  
    output wire Stall,                 
    output wire CacheHit,              
    output wire State,     

    input wire clk,                   
    input wire rst,                   
    input wire createdump,

    input wire [15:0] temp_DataOut,
    input wire Addr,                  
    input wire DataIn,                
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

typedef enum state [3:0](
    IDLE,
    COMPARE_READ,
    COMPARE_WRITE,
    ACCESS_READ_1,
    ACCESS_READ_2,
    ACCESS_READ_3,
    ACCESS_READ_4,
    ACCESS_WRITE_1,
    ACCESS_WRITE_2,
    ACCESS_WRITE_3,
    ACCESS_WRITE_4,
    ACCESS_WRITE_5,
    ACCESS_WRITE_6,
    DONE
) state_t;



always @* begin
    case(state)
        IDLE:

        COMPARE_READ:

        COMPARE_WRITE:

        ACCESS_READ_1:

        ACCESS_READ_2:

        ACCESS_READ_3:

        ACCESS_READ_4:

        ACCESS_WRITE_1:

        ACCESS_WRITE_2:

        ACCESS_WRITE_3:

        ACCESS_WRITE_4:

        ACCESS_WRITE_5:

        ACCESS_WRITE_6:

        DONE:

        // default:
        //     nxt_state = IDLE;
    endcase

end




endmodule