module directcachetb();
    logic   clk, reset, we;
    logic [3:0] addr, din, dout;
    
    directcache#(.DATA_WIDTH(4), .ADDR_WIDTH(5), .C(2)) uut(.clk, .reset, .we, .addr, .din, .dout);
    
    always
        begin
            clk = 1'b1;
            #5;
            clk = 1'b0;
            #5;
        end
    initial
        begin
            we = 0;
            #22;
            @(negedge clk)
            we = 1;
            addr = 5'b11100;
            din = 4'b1111;
            repeat(2) @(negedge clk);
            addr = 5'b01000;
            din = 4'b1100;
            #10;
            $stop;
        end
    
endmodule
