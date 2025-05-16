module agb2(
    input wire[1:0] a, b,
    output wire agb
    );
    
    wire p0, p1, p2;
    
    //  sum of product terms
     
    assign agb = p0 | p1 | p2;
    
    //  product terms
    assign p0 = a[1] & ~b[1];
    assign p1 = ~b[1] & ~b[0] & a[0];
    assign p2 = a[1] & a[0] & ~b[0];
endmodule
