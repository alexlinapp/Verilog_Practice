`timescale 1ns / 10ps

module barrel_right_shift_tb;
    localparam N = 4;
    reg[N-1:0] a;
    reg[1:0] amt;
    wire[N-1:0] b;
    
    barrel_right_shift #(.N(N)) brs1(.a(a), .amt(amt), .b(b));
    
    
    initial
    begin
    a = 'b1001;
    amt = 'b10;
    #200;
    a = 'b1101;
    amt = 'b11;
    #200;
    a = 'b0101;
    amt = 'b01;
    #200;
    
    
    $stop;
    end
endmodule
