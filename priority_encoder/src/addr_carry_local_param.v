module addr_carry_local_param(
    input wire [3:0] a, b,
    output wire [3:0] sum,
    output wire cout
    );
    localparam N = 4,
               N1 = N - 1;
    wire [N:0] sum_ext;
    
    //  body
    assign sum_ext = {1'b0, a} + {1'b0, b};
    assign sum = sum_ext[N1:0];
    assign cout = sum_ext[N];

endmodule
