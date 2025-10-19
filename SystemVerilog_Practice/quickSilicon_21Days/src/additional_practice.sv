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


module additional_practice_TB;
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