class MemTrans;
    logic [7:0] data_in;
    logic [3:0] address;
    static logic [3:0] last_address;
    
    function new(input logic [7:0] data_in = 0, input logic [3:0] address = 0);
        this.data_in = data_in;
        this.address = address;
        last_address = address;
    endfunction //new()

    function void print();
        $display("data_in: %0d", data_in);
        $display("address: %0d", address);
    endfunction
    

endclass //MemTrans

program automatic test();
    initial begin
        MemTrans m1, m2;
        m1 = new(.address(2));
        m2 = new(.data_in(3), .address(4));
        m1.address = 4'hF;
        m1.print();
        m2.print();
        m2 = null;
        $display("Last address: %0d", MemTrans::last_address);
    end

endprogram

module top();
    test t1();
    
endmodule