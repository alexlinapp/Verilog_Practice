module dual_priority_encoder(
    input wire[11:0] a,
    output reg[3:0] first, second
    );
    
    wire[11:0] masked;
    assign masked = a & ~(12'b1 << (first - 1));
    always @*
    begin
        if (a[11])
            first = 4'b1100;
       else if (a[10])
            first = 4'b1011;
       else if (a[9])
            first = 4'b1010;
       else if (a[8])
            first = 4'b1001;
       else if (a[7])
            first = 4'b1000;
       else if (a[6])
            first = 4'b0111;
       else if (a[5])
            first = 4'b0110;
       else if (a[4])
            first = 4'b0101;
       else if (a[3])
            first = 4'b0100;
       else if (a[2])
            first = 4'b0011;
       else if (a[1])
            first = 4'b0010;
       else if (a[0])
            first = 4'b0001;
    end
    always @*
    begin
       second = 4'd0;
       if (masked[11])
            second = 4'b1100;
       else if (masked[10])
            second = 4'b1011;
       else if (masked[9])
            second = 4'b1010;
       else if (masked[8])
            second = 4'b1001;
       else if (masked[7])
            second = 4'b1000;
       else if (masked[6])
            second = 4'b0111;
       else if (masked[5])
            second = 4'b0110;
       else if (masked[4])
            second = 4'b0101;
       else if (masked[3])
            second = 4'b0100;
       else if (masked[2])
            second = 4'b0011;
       else if (masked[1])
            second = 4'b0010;
       else if (masked[0])
            second = 4'b0001;
    end
endmodule
