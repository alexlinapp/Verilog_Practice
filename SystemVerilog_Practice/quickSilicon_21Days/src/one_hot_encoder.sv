module one_hot_encoder#(
    parameter   BIN_W               = 4,
    parameter   ONE_HOT_W           = 16
)
(
    input   wire[BIN_W-1:0]         bin_i,
    output  wire[ONE_HOT_W-1:0]     one_hot_o
);
    // synthesizes to a combinational decoder
    assign one_hot_o = 1 << bin_i;  // synthesizes to a decoder

endmodule


module one_hot_encoder_TB;
    localparam BIN_W            = 4;
    localparam ONE_HOT_W        = 16;
    
    logic [BIN_W-1:0]       bin_i;
    logic   [ONE_HOT_W-1:0] one_hot_o;
    
    one_hot_encoder #(.BIN_W(BIN_W), .ONE_HOT_W(ONE_HOT_W)) DUT(.*);
    
    logic clk;
    
    always begin
        clk = 0;
        #5;
        clk = 1;
        #5;
    end
    
    initial begin
        repeat(5) @(negedge clk);
        bin_i <= 4'b1001;
        @(negedge clk);
        bin_i <= 4'b0001;
        @(negedge clk);
        bin_i <= 4'b0000;
        @(negedge clk);
        for (int i = 0; i < 16; i++) begin
            bin_i <= i;
            @(negedge clk); 
        end
        $finish;
    end
    
    
    
    
    
    
endmodule
