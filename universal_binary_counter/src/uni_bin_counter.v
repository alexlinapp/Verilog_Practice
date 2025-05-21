module uni_bin_counter
    #(
    parameter N = 4
    )
    (
    input wire clk, reset, 
    input wire[N-1:0] d,
    input wire load, en, up, synclr,
    output reg max_tick, min_tick,
    output reg[N-1:0] q
    );
    
    reg[N-1:0] r_next, r_curr;
    always @(posedge clk, posedge reset)
        if (reset)
            r_curr <= 0;
        else 
            r_curr <= r_next;
    
    //  next state combinational logic
    
    always @*
        if (synclr)
            r_next = 0;
        else if (load)
            r_next = d;
        else if (en)
            if (up)
                r_next = r_curr + 1;
            else
                r_next = r_curr - 1;
        else
            r_next = r_curr;
    always @*
    begin
       q = r_curr;
       max_tick = (r_curr == 2**N - 1) ? 1'b1 : 1'b0;
       min_tick = (r_curr == 0) ? 1'b1 : 1'b0;
    end
endmodule
