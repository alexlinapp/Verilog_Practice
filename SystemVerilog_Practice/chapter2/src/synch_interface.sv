interface arb_if(input bit clk);
    logic [1:0] grant, request;
    bit rst;

    clocking cb @(posedge clk);
        output request;
        input grant;
    endclocking

    modport TEST (
    clocking cb,
    output rst
    );

    modport DUT (
        input request, rst, clk,
        output grant
    );

endinterface //arb_if

module incr(
    ref int c, d
);
    always @(c)
        #1 d = c++;
    
endmodule


program automatic test(arb_if.TEST arbif);
logic [1:0] grant, request;
    final begin
        $display("Test completed!");
        $display("Now its truly done!");
    end
endprogram

module top ();
    bit clk;
    arb_if  arbif(clk);
    test    t1(arbif.TEST);
    int c, d;
    incr i1(c, d);
    initial begin
        $monitor("@%0d: c = %0d, d = %0d", $time, c, d);
        c = 2;
        #10;
        c = 8;
        #10;
    end
endmodule
