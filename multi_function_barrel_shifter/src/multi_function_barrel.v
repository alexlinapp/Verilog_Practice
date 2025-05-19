module multi_function_barrel #(parameter N = 8)(
    input wire [N-1:0] a,
    input wire [2:0] amt,
    input wire s0,
    output wire[N-1:0] b
    );
    
    wire[N-1:0] b0, b1;
    //  using default parameter of N = 8
    barrel_right_shift brs1(.a(a), .amt(amt), .b(b0));
    barrel_left_shift bls1(.a(a), .amt(amt), .b(b1));
    //  1 = right shift, 0 = left shift
    assign b = s0 ? b0 : b1;
endmodule
