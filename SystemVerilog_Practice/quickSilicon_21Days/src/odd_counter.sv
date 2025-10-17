module odd_counter(
            input logic clk, reset,
            output logic [7:0] cnt_o     
    );
    
    logic [7:0] next_cnt_o;
    assign next_cnt_o = cnt_o + 8'h2;
    
    always_ff @(posedge clk) begin
        if (reset)
            cnt_o <= 8'b1;
        else
            cnt_o <= next_cnt_o;
    end
endmodule
