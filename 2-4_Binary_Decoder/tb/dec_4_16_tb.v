`timescale 1ns / 10ps

module dec_4_16_tb;
    reg[3:0] a;
    wire[15:0] OUT;
    reg EN;
    dec_4_16 uut(.a(a), .EN(EN), .OUT(OUT));
    
    initial
    begin
    EN = 1'b1;
    a = 4'b0111;
    #200
    a = 4'b0001;
    #200
    a = 4'b1001;
    #200
    a = 4'b0010;
    #200
    EN = 1'b0;
    a = 4'b1001;
    #200;

    
    $stop;
    end
endmodule
