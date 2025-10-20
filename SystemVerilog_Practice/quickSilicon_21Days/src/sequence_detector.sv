module sequence_detector
    #(parameter int N = 12,
      parameter logic [N-1:0] PATTERN = 12'b1110_1101_1011
    )
    (
        input   logic       clk,
        input   logic       reset,
        input   logic       x_i,
        output  logic       det_o
    );
    // 
    localparam unsigned WIDTH = $clog2(N);
    logic [$clog2(N):0] c_state, n_state;
    
    always_ff @(posedge clk, posedge reset) begin
        if (reset) begin
            c_state <= '0;
        end
        else 
            c_state <= n_state;
    end
    always_comb begin
        n_state = (x_i == PATTERN[c_state]) ? c_state + 1: '0;
        if (c_state == N) begin
            n_state = (x_i == PATTERN[0]) ? 1 : '0;
        end
    end
    
    assign det_o = (c_state == N);
endmodule


module sequence_detector_TB;
    logic clk, reset, x_i, det_o;
    localparam N = 12;
    localparam logic [N-1:0] PATTERN = 12'b1110_1101_1011;
    
    sequence_detector #(.N(N), .PATTERN(PATTERN)) DUT(.*);
    
    always begin
        clk = 0;
        #5;
        clk = 1;
        #5;
    end
    
    initial begin
        reset <= 1'b1;
        repeat (2) @(negedge clk);
        reset <= 1'b0;
        
        for (int i = 0; i < N; i++) begin
            x_i <= PATTERN[i];
            @(negedge clk);
        end
        #20;
        $finish;
    end

endmodule
