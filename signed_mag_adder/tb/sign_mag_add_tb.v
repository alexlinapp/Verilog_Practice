`timescale 1ns / 10ps
module sign_mag_add_tb;
    
    localparam N = 5;
    reg [N-1:0] a, b;
    wire [N-1:0] sum;
    
    sign_mag_add #(.N(N)) sma1 (.a(a), .b(b), .sum(sum));
    
    initial
    begin
    a = 5'b11101;
    b = 5'b10110;
    #200;
    a = 5'b01101;
    b = 5'b10110;
    #200;
    a = 5'b00101;
    b = 5'b00110;
    #200;
    
   $stop;
    end
endmodule
