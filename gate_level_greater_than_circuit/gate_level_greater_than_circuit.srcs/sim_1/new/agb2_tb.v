`timescale 1ns / 10ps


module agb2_tb;
    reg[1:0] test_in_a, test_in_b;
    wire OUT;
    
    
    //  intanstiate module
    agb2 uut(.a(test_in_a), .b(test_in_b), .agb(OUT));
    
    // test vector
    initial
    begin
        //  test vector 1; expected OUT = 1
        test_in_a = 2'b00;
        test_in_b = 2'b00;
        #200;
        test_in_a = 2'b01;
        test_in_b = 2'b00;
        #200;
        test_in_a = 2'b11;
        test_in_b = 2'b11;
        #200;
        test_in_a = 2'b10;
        test_in_b = 2'b11;
        #200;
        test_in_a = 2'b10;
        test_in_b = 2'b01;
        #200;
        test_in_a = 2'b01;
        test_in_b = 2'b11;
        $stop;
        end
endmodule
