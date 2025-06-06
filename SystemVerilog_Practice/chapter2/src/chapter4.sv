interface asynch_if();
    logic l;
    wire w;
endinterface //asynch_if()

module test(asynch_if ifc);
    //  difference between declaring signals in interface as wire or logic
    logic local_wire;
    assign ifc.w = local_wire;

    initial begin
        ifc.1 <= 0; //  Drive asych logic directly
        local_wire <= 1;    // but drive wire through assign
    end

endmodule