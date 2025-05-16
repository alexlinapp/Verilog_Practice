module dec_4_16(
    input wire[3:0] a,
    input wire EN,
    output wire[15:0] OUT
    );
    wire[3:0] p0;
    dec_2_4 d0(.a(a[3:2]), .EN(EN), .OUT(p0));
    dec_2_4 d1(.a(a[1:0]), .EN(p0[3]), .OUT(OUT[15:12]));
    dec_2_4 d2(.a(a[1:0]), .EN(p0[2]), .OUT(OUT[11:8]));
    dec_2_4 d3(.a(a[1:0]), .EN(p0[1]), .OUT(OUT[7:4]));
    dec_2_4 d4(.a(a[1:0]), .EN(p0[0]), .OUT(OUT[3:0]));
endmodule
