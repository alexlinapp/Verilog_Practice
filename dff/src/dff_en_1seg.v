module dff_en_1seg(
    input wire clk, d, reset, enable,
    output reg q
    );
    
    always @(posedge clk, posedge reset)
        if (reset)
            q <= 1'b0;
        else if (enable)
            q <= d;
        //  no else statement needed afterwards. According to Verilog a variable keeps its previous
        //  value if it is not assigned
  
endmodule
