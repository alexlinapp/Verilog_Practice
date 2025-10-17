module shift_reg(
        input     wire        clk,
        input     wire        reset,
        input     wire        x_i,      // Serial input

        output    wire[3:0]   sr_o
    );
    logic [3:0] curr_o;
    assign sr_o = curr_o;
    
    
    always_ff @(posedge clk, posedge reset) begin
        if (reset) begin
            curr_o <= 4'b0;
        end
        else
            curr_o <= {curr_o[2:0], x_i};
    
    end
    
    
endmodule
