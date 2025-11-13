module even_clock_divider#(parameter N = 2)(
    input   logic clk_i, reset,
    output  logic clk_o
);
    logic [$clog2(N)-1:0] counter_q, counter_d;
    // 0->1   ->0->1
//    logic clk_d, clk_q;
//    assign clk_o = clk_q;
//    always_ff @(posedge clk_i) begin
//        if (reset)
//            clk_q <= 1'b0;
//        else
//            clk_q <= clk_d;
    
//    end
 
    
    always_ff @(posedge clk_i) begin
        if (reset)
            counter_q <= '0;
        else
            counter_q <= counter_d;
    
    end
    
    always_comb begin
        if (counter_q < (N >> 1))
            clk_o = 1'b0;
        else
            clk_o = 1'b1;
    end
    
    always_comb begin
        counter_d = counter_q + 1;
        if (counter_d == N) // will wrap around on its own and we will be fine
            counter_d = '0;
    end
endmodule

//https://www.mikrocontroller.net/attachment/177198/Clock_Dividers_Made_Easy.pdf
module odd_clock_divider #(parameter N)(
    input   logic clk_i, reset,
    output  logic clk_o
);
logic [$clog2(N)-1:0] counter_d, counter_q;
logic en1, en2; // clock enables
logic div1, div2;
always_ff @(posedge clk_i) begin
    if (reset)
        counter_q <= '0;
    else
        counter_q <= counter_d;
end
always_ff @(posedge clk_i) begin
    if (reset)
        div1 <= '0;
    else if (en1)
        div1 <= ~div1;
end

always_ff @(negedge clk_i) begin
    if (reset)
        div2 <= '0;
    else if (en2)
        div2 <= ~div2;
end
assign en1 = (counter_q == 0);
assign en2 = (counter_q == ((N >> 1)+1));

assign counter_d = counter_q == (N-1) ? '0 : counter_q + 1;

assign clk_o = div1 ^ div2;
endmodule

module clk_divider_tb;
    logic clk_i = 0;
    logic reset;
    logic clk_o;
    always #5 clk_i = ~clk_i;
    localparam N = 3;
    
    //even_clock_divider #(.N(N)) DUT(.*);
    
    odd_clock_divider #(.N(N)) DUT1(.*);
    
    
    
//    property check_clk_low_to_high;
//        @(posedge clk_i) 
//        disable iff (reset)
//        $rose(clk_o) |-> ##(N/2) $fell(clk_o);
//    endproperty
    
//    property check_clk_high_to_low;
//        @(posedge clk_i) 
//        disable iff (reset)
//        clk_o == 1 |-> ##(N/2) (clk_o == 0);
//    endproperty
    
//    assert property (check_clk_low_to_high)
//    else $display("Failed check_clk_low_to_high: %0t", $time);
//    assert property (check_clk_high_to_low)
//    else $display("Failed check_clk_high_to_low: %0t", $time);
    
    initial begin
        @(posedge clk_i)
        reset <= 1'b1;
        repeat (2) @(posedge clk_i);
        reset <= 1'b0;
        repeat (10) @(posedge clk_i);
        $finish;
    
    end
    
endmodule
