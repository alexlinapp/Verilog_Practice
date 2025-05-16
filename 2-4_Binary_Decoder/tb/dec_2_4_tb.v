`timescale 1ns / 10ps


module dec_2_4_tb;
    reg [1:0] a;
    wire[3:0] test_out;
    
    dec_2_4 uut(.a(a), .OUT(test_out));
    initial
    begin
    a = 2'b00;
    #200;
    a = 2'b01;
    #200;
    a = 2'b10;
    #200;
    a = 2'b11;
    #200;
    
    $stop;
    end
endmodule
