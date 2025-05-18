`timescale 1ns / 10ps

module addr_carry_param_tb;
    reg[2:0] a, b;
    wire[2:0] sum;
    wire cout;
    
    addr_carry_param #(.N(3)) addr1(.a(a), .b(b), .sum(sum), .cout(cout));
    
    initial
    begin
    a = 3'b101;
    b = 3'b001;
    #200;
    
    
    $stop;
    end
endmodule
