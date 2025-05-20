module dff_no_reset
    (
     input wire clk, d,
     output reg q 
    );
    
    always @ (posedge clk)
        q <= d;     //  non-blocking assignment
endmodule
