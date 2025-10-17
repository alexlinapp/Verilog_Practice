module D_FF(
        input   logic   clk, reset,
        input   logic   d_i,
        output  logic   q_norst, qsync_rst, qasync_rst
    );
    
    
    // no reset
    always_ff @(posedge clk)
        q_norst <= d_i;
    
    // sync reset
    always_ff @(posedge clk) begin
        if (reset)
            qsync_rst <= '0;
        else
            qsync_rst <= d_i;
    end
    
    
    // async reset
    always_ff @(posedge clk, posedge reset) begin
        if (reset)
            qasync_rst <= '0;
        else
            qasync_rst <= d_i;
    end
endmodule


module D_FF_tb;
    logic clk, reset;
    logic d_i;
    logic q_norst, qsync_rst, qasync_rst;
    
    D_FF DUT(.*);
    
    initial begin
        clk = 0;
        reset = 0;
    end
    always begin
        clk = ~clk;
        #5;
    end
    
    initial begin
        #20;
        @(negedge clk);
        d_i = 1;
        @(negedge clk);
        reset = 1;
        @(negedge clk);
        reset = 0;
        @(negedge clk);
        d_i = 0;
        @(negedge clk);
        @(negedge clk);
        d_i = 1;
        @(negedge clk);
        d_i = 0;
        $stop;
    end

endmodule

