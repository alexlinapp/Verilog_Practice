module barrel_right_shift #(parameter N = 4)
    (
        input wire [N-1:0] a,
        input wire [1:0] amt,
        output wire [N-1:0] b
    );
    wire [N-1:0] s0;
    assign s0 = amt[0] ? {a[0], a[N-1:1]} : a;
    assign b = amt[1] ? {s0[1:0], s0[N-1:2]} : s0;
endmodule
