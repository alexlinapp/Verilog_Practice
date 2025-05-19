module barrel_left_shift #(parameter N = 8)
    (
        input wire [N-1:0] a,
        input wire [2:0] amt,
        output wire [N-1:0] b
    );
    wire [N-1:0] s0, s1;
    assign s0 = amt[0] ? {a[N-2:0], a[N-1]} : a;
    assign s1 = amt[1] ? {s0[N-3:0], s0[N-1:N-2]} : s0;
    assign b = amt[2] ? {s1[N-5:0], s1[N-1:N-4]} : s1;
endmodule

