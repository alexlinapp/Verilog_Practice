`timescale 1ns / 10ps

module prio_encoder_if_tb;
    reg [3:0] IN;
    wire[2:0] OUT;
    
    prio_encoder_if pei1(.r(IN), .y(OUT));
    initial
    begin
    IN = 4'b1000;
    #200;
    IN = 4'b1100;
    #200;
    IN = 4'b0101;
    #200;
    IN = 4'b0001;
    #200;
    
    $stop;
    end
endmodule
