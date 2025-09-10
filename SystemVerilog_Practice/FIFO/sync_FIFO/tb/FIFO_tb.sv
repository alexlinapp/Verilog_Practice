`timescale 1ns / 1ps
module FIFO_tb;
    
    bit clk;
    bit reset;
    
    logic rd, wr;
    logic [3:0] w_data, r_data;
    logic empty, full;

    initial begin
        clk = 0;
        reset = 0;
    end
    
    always #5 clk = ~clk;
    
    
    
    
    // create FIFO
    FIFO fifo(.*);
    
    initial begin
        #10;
        w_data = 4'b0001;
        rd = 1;
        wr = 1;
        #10;
        assert(r_data == 4'b0001) $error("Did not read correctly on reset");
        
        w_data = 4'b0010;
        rd = 0;
        #10;
        assert(r_data == 4'b0001) $error("Failed Second clock cycle read");
        
        w_data = 4'b0011;
        rd = 1;
        #10;
        assert(r_data == 4'b0010) $error("Failed third clcok cycle read");
        
        w_data = 4'b0100;
        rd = 0;
        #10;
        assert(r_data == 4'b0010) $error("Failed fourth clock cycle read");
        assert(empty == 1'b0) $error("Failed fourth clock cycle empty");
        assert(full == 1'b0) $error("Failed fourth clock cycle full");
        
        w_data = 4'b0101;
        rd = 0;
        #10;
        assert(empty == 1'b0) $error("Failed fifth clock cycle empty");
        assert(full == 1'b1) $error("Failed fifth clock cycle full");
        // FIFO: 2345 front to back
        
        w_data = 4'b0110;
        #10;
        
        rd = 1;
        #10
        assert(full == 1'b0) $error("Failed 7th clock cycle empty");
        assert(r_data == 4'b0011); $error("Failed 7th clock cycle r_data");
        
        rd = 1;
        #10
        assert(empty == 1'b0) $error("Failed 8th clock cycle empty");
        assert(r_data == 4'b0100); $error("Failed 8th clock cycle r_data");
        
        rd = 1;
        #10
        assert(empty == 1'b0) $error("Failed 9th clock cycle empty");
        assert(r_data == 4'b0101); $error("Failed 9th clock cycle r_data");
        
        rd = 1;
        #10
        assert(empty == 1'b1) $error("Failed 10th clock cycle empty");
        
        
        $stop;
    end
endmodule
