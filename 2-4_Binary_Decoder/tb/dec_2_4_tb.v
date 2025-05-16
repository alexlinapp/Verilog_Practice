`timescale 1ns / 10ps


module dec_2_4_tb;
    reg [1:0] a;
    wire[3:0] test_out;
    reg EN;
    
    dec_2_4 uut(.a(a), .EN(EN), .OUT(test_out));
    initial
    begin
    a = 2'b00;
    EN = 1'b0;
    #200;
    a = 2'b01;
    EN = 1'b0;
    #200;
    a = 2'b10;
    EN = 1'b0;
    #200;
    a = 2'b11;
    EN = 1'b0;
    #200;
    a = 2'b00;
    EN = 1'b1;
    #200;
    a = 2'b01;
    EN = 1'b1;
    #200;
    a = 2'b10;
    EN = 1'b1;
    #200;
    a = 2'b11;
    EN = 1'b1;
    #200;
    
    $stop;
    end
endmodule
