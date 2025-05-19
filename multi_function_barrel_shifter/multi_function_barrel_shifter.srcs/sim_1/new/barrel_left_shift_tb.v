`timescale 1ns / 10ps
module barrel_left_shift_tb;
    reg[7:0] a;
    reg[2:0] amt;
    wire[7:0] b;
    
    barrel_left_shift #(.N(8)) brs1 (.a(a), .b(b), .amt(amt));
    
    initial
    begin
    a = 'b10010110;
    amt = 'b001;
    #200;
    a = 'b10010110;
    amt = 'b011;
    #200;
    a = 'b10010110;
    amt = 'b101;
    #200;
    
    $stop;
    end
endmodule
