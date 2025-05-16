`timescale 1ns / 10ps


module ageqb4_tb;
    reg[3:0] a, b;
    wire OUT;
    
    //  instantiate test module
    ageqb4 uut(.a(a), .b(b), .ageqb(OUT));
    
    initial begin 
    a = 4'b0000;
    b = 4'b0000;
    # 200;
    a = 4'b0000;
    b = 4'b0001;
    # 200;
    a = 4'b0010;
    b = 4'b0001;
    # 200;
    a = 4'b1000;
    b = 4'b1001;
    # 200;
    a = 4'b1001;
    b = 4'b1001;
    #200
    $stop;
    end
endmodule
