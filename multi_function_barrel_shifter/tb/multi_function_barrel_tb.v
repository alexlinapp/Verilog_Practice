`timescale 1ns / 10ps

module multi_function_barrel_tb;
    reg[7:0] a;
    wire[7:0] b;
    reg[2:0] amt;
    reg s0;
    
    multi_function_barrel mfb1(.a(a), .b(b), .amt(amt), .s0(s0));
    initial
    begin
    a = 'b01001011;
    amt = 'b011;
    s0 = 'b1;
    #200;
    a = 'b01001011;
    amt = 'b011;
    s0 = 'b0;
    #200;
    a = 'b01001000;
    amt = 'b001;
    s0 = 'b1;
    #200;
    a = 'b01001000;
    amt = 'b001;
    s0 = 'b0;
    #200;
    
    $stop;
    end
endmodule
