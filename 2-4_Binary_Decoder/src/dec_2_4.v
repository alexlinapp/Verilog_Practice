module dec_2_4(
    input wire[1:0] a,
    input wire EN,
    output wire[3:0] OUT
    );
    assign OUT[0] = ~a[1] & ~a[0] & EN;
    assign OUT[1] = ~a[1] & a[0] & EN;
    assign OUT[2] = a[1] & ~a[0] & EN;
    assign OUT[3] = a[1] & a[0] & EN;
endmodule
