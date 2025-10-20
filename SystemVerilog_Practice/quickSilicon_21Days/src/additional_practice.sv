module binary_gray_1 #(
    parameter VEC_W = 4
    )
(
    input   wire[VEC_W-1:0] bin_i,
    output   wire[VEC_W-1:0] gray_o

);
    assign gray_o[VEC_W-1] = bin_i[VEC_W-1];
    assign gray_o[VEC_W-2:0] = bin_i[VEC_W-1:1] ^ bin_i[VEC_W-2:0];

endmodule

module additional_practice_TB_gray;
    localparam VEC_W = 4;
    logic [VEC_W-1:0] bin_i;
    logic [VEC_W-1:0] gray_o;
    
    binary_gray_1 #(.VEC_W(VEC_W)) DUT(.*);
    
    initial begin
        for (int i = 0; i < 1 << VEC_W; i++) begin
            bin_i = i;
            #5;
        
        end
        $finish;
    end

endmodule

module par_ser #(
    parameter N = 4
)
(
    input   logic   clk,
    input   logic   reset,
    
    output  logic   empty_o,
    input   logic [3:0] parallel_i,
    
    output  logic       serial_o,
    output  logic       valid_o
);

    logic [2:0] count_curr, count_next;
    logic [3:0] shift_reg;
    
    always_ff @(posedge clk, posedge reset) begin
        if (reset) begin
            count_curr <= 1'b0;
        end
        else begin
            count_curr <= count_next;
        end
    end
    always_ff @(posedge clk, posedge reset) begin
        if (reset)
            shift_reg <= '0;
        else if (empty_o)
            shift_reg <= parallel_i;
        else
            shift_reg <= {1'b0, shift_reg[3:1]};
    end
    
    assign count_next = (count_curr == 4'h4) ? 4'h0 : count_curr + 1;
    assign empty_o = (count_curr == 4'h0) ? 1'b1 : 1'b0;
    assign valid_o = |count_curr;
    assign serial_o = shift_reg[0];


endmodule

module par_ser_TB2;
    logic   clk;
    logic   reset;
    
    logic empty_o;
    logic [3:0] parallel_i;
    
    logic       serial_o;
    logic       valid_o;
    
    par_ser #(.N(4)) DUT(.*);
    
    always begin
        clk = 0;
        #5;
        clk = 1;
        #5;
    end
    
    initial begin
        reset <= 1'b1;
        repeat (4) @(negedge clk);
        reset <= 1'b0;
        parallel_i <= 4'b1101;
        repeat (4) @(negedge clk);
        parallel_i <= 4'b0101;
        repeat (2) @(negedge clk);
        parallel_i <= 4'b1011;
        repeat (8) @(negedge clk);
        $finish;
    end
endmodule











