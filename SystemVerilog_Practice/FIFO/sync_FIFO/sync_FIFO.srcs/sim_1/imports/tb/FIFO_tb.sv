`timescale 1ns / 1ps
module FIFO_tb;
    
    bit clk;
    bit reset;
    
    logic rd, wr;
    logic [3:0] w_data, r_data;
    logic empty, full;

    initial begin
        clk = 1;
    end
    
    always #5 clk = ~clk;
    
    
    
    
    // create FIFO
    FIFO fifo(.*);
    
    initial begin
        reset = 0;
        #5;
        reset = 1;
        #20;
        reset = 0;
        #10;
        reset = 0;
        w_data = 4'b0001;
        rd = 1;
        wr = 1;
        #10;
        assert(r_data == 4'b0001) 
        else $error("Did not read correctly on reset");
        
        w_data = 4'b0010;
        rd = 0;
        #10;
        assert(r_data == 4'b0001) 
        else $error("Failed Second clock cycle read");
        
        w_data = 4'b0011;
        rd = 1;
        #10;
        assert(r_data == 4'b0010) 
        else $error("Failed third clcok cycle read");
        
        w_data = 4'b0100;
        rd = 0;
        #10;
        assert(r_data == 4'b0010) 
        else $error("Failed fourth clock cycle read");
        assert(empty == 1'b0) 
        else $error("Failed fourth clock cycle empty");
        assert(full == 1'b0) 
        else $error("Failed fourth clock cycle full");
        
        w_data = 4'b0101;
        rd = 0;
        #10;
        assert(empty == 1'b0) 
        else $error("Failed fifth clock cycle empty");
        assert(full == 1'b1) 
        else $error("Failed fifth clock cycle full");
        // FIFO: 2345 front to back
        
        w_data = 4'b0110;
        rd = 1;
        #10;
        assert(full == 1'b1)
        else $error("Failed special clock cycle full");
        assert(r_data == 4'b0011)
        else $error("Failed r_data clock cycle");
        
        wr = 0;
        #10
        assert(empty == 1'b0) 
        else $error("Failed 8th clock cycle empty");
        assert(r_data == 4'b0100) 
        else $error("Failed 8th clock cycle r_data");
        
        rd = 1;
        #10
        assert(empty == 1'b0) 
        else $error("Failed 9th clock cycle empty");
        assert(r_data == 4'b0101) 
        else $error("Failed 9th clock cycle r_data");
        
        rd = 1;
        #10
        assert(empty == 1'b0) 
        else $error("Failed 10th clock cycle empty");
        
        #10
        assert(empty == 1'b1)
        else $error("Failed 11th clock cycle empty");
        
        
        $stop;
    end
endmodule
