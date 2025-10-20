// Detecting a big sequence - 1110_1101_1011
module day12 (
  input     wire        clk,
  input     wire        reset,
  input     wire        x_i,

  output    wire        det_o
);

  // 13 states, 1 "not seen state" and 12 seen. 
    logic [3:0] c_state, n_state;
    
    always_ff @(posedge clk, posedge reset) begin
        if (reset)
            c_state <= 4'b0;
        else
            c_state <= n_state;
        
    end
    
    // next state logic
    always_comb begin
        n_state = c_state;
        case (c_state)
            4'd0, 4'd1, 4'd3, 4'd4, 
            4'd6, 4'd7, 4'd9, 
            4'd10, 4'd11, 4'd12: if (x_i == 1'b1) n_state = c_state + 1;
            else
                n_state = '0;
            4'd2, 4'd5, 4'd8: if (x_i == 1'b0) n_state = c_state + 1;
            else
                n_state = '0;
        endcase
    end
    
    // output logic
    assign det_o = (c_state == 4'd12);
endmodule

module day_12TB;
    logic clk, reset, x_i, det_o;
    
    day12 DUT(.*);
    
    localparam logic [11:0] PATTERN = 12'b1110_1101_1011;
    
    always begin
        clk = 0;
        #5;
        clk = 1;
        #5;
    end
    
    initial begin
        reset <= 1;
        repeat (2) @(negedge clk);
        reset <= 0;
        for (int i = 0; i < 32; i++) begin
            x_i = $urandom_range(0, 1);
            @(negedge clk);
        end
        x_i = '0;
        repeat (5) @(negedge clk);
        for (int i = 0; i < 12; i++) begin
            x_i = PATTERN[i];
            @(negedge clk);
        end
        #20;
        $finish;
    end

endmodule
