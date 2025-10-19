module self_reloading_counter(
        input     logic          clk,
        input     logic          reset,
        input     logic          load_i,
        input     logic[3:0]     load_val_i,

        output    logic[3:0]     count_o
    );
    
    logic [3:0] next_count_o;
    logic [3:0] curr_count_o;
    logic [3:0] load_val_q;
    assign curr_count_o = count_o;
    
    
    always_ff @(posedge clk, posedge reset) begin
        if (reset)
            count_o <= '0;
        else
            count_o <= next_count_o;
    end
    
    always_ff @(posedge clk) begin
        if (load_i === 1'b1)
            load_val_q <= load_val_i;
    end
    
    always_comb begin
        automatic logic [3:0] temp = curr_count_o + 1; // use autoamtic, value is not retained
        next_count_o = curr_count_o;
        if (temp == 0) begin
            next_count_o = load_val_q;
        end
        else
            next_count_o = temp;  
    end
endmodule

module self_reloading_counter_TB;
    logic          clk, reset, load_i;
    logic[3:0]     load_val_i;

    logic[3:0]     count_o;




    self_reloading_counter DUT(.*);
    
    always begin
        clk <= 0;
        #5;
        clk <= 1;
        #5;
    end
    
    
    
    
    initial begin
        load_i <= 1'b0;
        reset <= 1'b1;
        repeat (3) @(negedge clk);
        reset <= 1'b0;
        load_i <= 1'b1;
        load_val_i <= 4'b1000;
        @(posedge clk);
        repeat (20) @(negedge clk);
        reset <= 1'b1;
        repeat (2) @(negedge clk);
        reset <= 1'b0;
        repeat (8) @(negedge clk);
        $finish;
        
    
    end
endmodule
