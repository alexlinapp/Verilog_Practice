`timescale 10ns / 1ps
module dual_edge_detector_tb;

    localparam T = 20;  //clock period
    //signal declarations
    reg clk, reset, level;
    wire tick;
    
    dual_edge_detector uut(.clk(clk), .reset(reset), 
                            .level(level), .tick(tick));
    
    always
    begin
        clk = 1'b1;
        #(T/2);
        clk = 1'b0;
        #(T/2);
    end
    
    initial
    begin
        reset = 1'b1;
        #(T/2);
        reset = 1'b0;
    
    end
    
    initial
    begin
        //  initial input
        level = 1'b1;
        @(negedge reset);
        @(negedge clk);
        //  test load
        level = 1'b0;
        repeat(2) @(negedge clk);
        level = 1'b1;
        @(negedge clk);
        
    
    
    end
endmodule
