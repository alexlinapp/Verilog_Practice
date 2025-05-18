`timescale 1ns / 10ps
module addr_carry_local_param_tb;
    localparam N = 4,
               N1 = N - 1;
               
    reg [3:0] a, b;
    wire [3:0] sum;
    wire cout;
    
    addr_carry_local_param addr1(.a(a), .b(b), .sum(sum), .cout(cout));
    
    initial
    begin
    a = 4'b0101;
    b = 4'b0001;
    #200;
    a = 4'b1001;
    b = 4'b0001;
    #200;
    a = 4'b1101;
    b = 4'b0010;
    #200;
    a = 4'b110;
    b = 4'b1001;
    #200;
    a = 4'b1111;
    b = 4'b1111;
    #200;
    
    
    
    $stop;
    end
    
endmodule
