
module dec_3_8(
    input wire[2:0] a,
    input wire EN,
    output wire[7:0] OUT
    );
    wire p0, p1;
    assign p0 = EN & ~a[2];
    assign p1 = EN & a[2];
    dec_2_4 d1(.a(a[1:0]), .EN(p0), .OUT(OUT[7:4]));
    dec_2_4 d2(.a(a[1:0]), .EN(p1), .OUT(OUT[3:0]));
endmodule