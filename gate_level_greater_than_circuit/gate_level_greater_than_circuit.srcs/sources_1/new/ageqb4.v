module ageqb4(
    input wire[3:0] a, b,
    output wire ageqb
    );
    wire p0, p1, p2, p3;
    
    
    agb2 u1_agb2(.a(a[3:2]), .b(b[3:2]), .agb(p0));
    eq2 u2_eq2(.a(a[3:2]), .b(b[3:2]), .aeqb(p1));
    agb2 u3_agb2(.a(a[1:0]), .b(b[1:0]), .agb(p2));
    eq2 u4_eq2(.a(a[1:0]), .b(b[1:0]), .aeqb(p3));
    
    //  a4a3 > b4b3 OR (a4a3 = b4b3 AND (a2a1 > b2b1 | a2a1 = b2b1))
    assign ageqb = p0 | (p1 & (p2 | p3));
    
endmodule
