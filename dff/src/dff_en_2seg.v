module dff_en_2seg(
    input wire clk, d, en, reset,
    output reg q
    );
    
    reg r_reg, r_next;
    //  D ff no enable
    always @(posedge clk, posedge reset)
        if (reset)
            r_reg <= 1'b0;
        else
            r_reg <= r_next;
    
    //  next state logic
    //  note it is combiational. No need for non-blocking
    always @*
        if (en)
            r_next = d;
        else
            r_next = r_reg;
        
    always @*
        q = r_reg;
endmodule
