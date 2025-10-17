module lfsr_4bit(
        input   wire        clk,
        input   wire        reset,
        
        output  wire [3:0]  lfsr_o
    );
    
    logic [3:0] lfsr_reg;
    logic       shift_in;
    
    assign shift_in = lfsr_reg[0] ^ lfsr_reg[3];
    assign lfsr_o = lfsr_reg;
    
    always_ff @(posedge clk) begin
        if (reset)
            lfsr_reg <= 4'b1010;               // set random seed
        else
            lfsr_reg <= {lfsr_reg[2:0], shift_in};
    end
endmodule


module lfsr_TB;
    
    logic clk, reset;
    logic [3:0] lfsr_o;
    
    lfsr_4bit DUT(.*);
    
    initial begin
        clk = 0;
    end
    
    always begin
        clk <= ~clk;
        #5;
    
    end
    
    initial begin
        reset <= 1'b1;
        @(negedge clk);
        @(negedge clk);
        reset <= 1'b0;
        #50;
        $display("REACHED THE END\n");
        $stop;
    
    end

endmodule

