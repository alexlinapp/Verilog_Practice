`timescale 1ns / 10ps

module sqaure_wave_gen_tb;
    localparam T = 20;  //clock period
    localparam N = 4;
    reg clk, reset;
    reg[N-1:0] m, n;
    wire q;
    wire[N+2:0] c;
    
    square_wave_gen #(.N(N)) uut(.clk(clk), .reset(reset),
                        .m(m), .n(n), .q(q), .c(c));
    //  initialize clock
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
    m = 4'b0100;
    n = 4'b0011;
    #3000;
    
    $stop;
    end
endmodule
