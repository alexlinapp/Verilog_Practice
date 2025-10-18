/*
To see why the formula below works, we know that when we add one, say initial value was N. Then taking N+1
we see that there exists k >= 0 that flips from 0 to 1 for N. Actually k is the position of the least significant
0 bit. So from bits 0 to k-1 flip from 1 to 0. And bit k flips from 0 to 1. And bits baove k remain the same.

For bits above k, nothing changes. That is b_i, b_{i+1} don't change so we get the same value for the gray code as previous
For bit k, we have bit changed and bit above did not, so different gray code (1 bit changes)
Forbits below k, since the b_{i+1} and b_i both changed XOR does not change the answer.



*/

module bin_graycode_converter#(
    parameter VEC_W = 4
)(
       input    wire[VEC_W-1:0] bin_i,
       output   wire[VEC_W-1:0] gray_o
    );
    assign gray_o[VEC_W-1] = bin_i[VEC_W-1];
    assign gray_o[VEC_W-2:0] = bin_i[VEC_W-1:1] ^ bin_i[VEC_W-2:0];
endmodule


module bin_graycode_TB;
    localparam VEC_W = 4;
    logic [VEC_W-1:0] bin_i, gray_o;
    
    bin_graycode_converter #(.VEC_W(VEC_W)) DUT(.*);
    logic clk;
    always begin
        clk = 0;
        #5;
        clk = 1;
        #5;
    end
    
    initial begin
        for (int i = 0; i < 2 << VEC_W; i++) begin
            bin_i = i;
            @(negedge clk);
        end
        $finish;
    end

endmodule
