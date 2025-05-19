module barrel_right_shift #(parameter N = 8)
    (
        input wire [N-1:0] a,
        input wire [2:0] amt,
        output wire [N-1:0] b
    );
    wire [N-1:0] s0, s1;
    assign s0 = amt[0] ? {a[0], a[N-1:1]} : a;
    assign s1 = amt[1] ? {s0[1:0], s0[N-1:2]} : s0;
    assign b = amt[2] ? {s1[3:0], s1[N-1:4]} : s1;
endmodule
