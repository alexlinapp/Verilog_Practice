module dff_reset
    (
    input wire clk, d, reset,
    output reg q
    );
    
    always @(posedge clk, posedge reset)
        if (reset)
            q <= 1'b0;
        else
            q <= d;
    
endmodule
