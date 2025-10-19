module parallel_serial(
    input     logic      clk,
    input     logic      reset,

      output    logic      empty_o,
      input     logic[3:0] parallel_i,
      
      output    logic      serial_o,
      output    logic      valid_o
    );
    
    
//    typedef enum logic [2:0] {EMPTY, s1, s2, s3, s4} state;
    
//    state curr_s, next_s;
    
//    always_ff @(posedge clk, posedge reset) begin
//        if (reset) begin
//            curr_s <= EMPTY;
//        end
//        else
//            curr_s <= next_s;
//    end
    
//    // next state logic
//    always_comb begin
//        next_s = curr_s;
//        case (curr_s)
//            EMPTY: begin
                
//            end
        
//        endcase
//    end
        logic [3:0] curr_count;
        logic [3:0] next_count;
        logic [3:0] curr_reg, next_reg;
        
        
        always_ff @(posedge clk, posedge reset) begin
            if (reset)
                curr_reg <= 4'b0;
            else
                curr_reg <= next_reg;
        end
        
        always_ff @(posedge clk, posedge reset) begin
            if (reset)
                curr_count <= '0;
            else
                curr_count <= next_count;
        
        end
        
        assign next_reg = (empty_o == 1'b1) ? (parallel_i) : {1'b0, curr_reg[3:1]};
        
        assign next_count = (curr_count == 4'h4) ? 0 : curr_count + 1;
        
        assign empty_o = (curr_count == '0) ? 1'b1 : 1'b0;
        
        assign valid_o = |curr_count;
        
        assign serial_o = curr_reg[0];
endmodule
