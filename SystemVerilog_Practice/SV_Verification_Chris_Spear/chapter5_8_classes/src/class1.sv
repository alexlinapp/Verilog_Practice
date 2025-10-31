class MemTrans;
    logic [7:0] data_in;
    logic [3:0] address;
    static logic [3:0] last_address;
    function new(input logic [7:0] data_in = '0, logic [3:0] address = '0);
        this.data_in = data_in;
        this.address = address;
        last_address = address;
    endfunction
    function void print();
        $display("Data_in: %0h, Address: %0h", data_in, address);
    endfunction

endclass



program automatic top;
    initial begin
        MemTrans m1, m2;
        m1 = new(.address(2));
        m2 = new(.data_in(3), .address(4));
        m1.address = 4'hF;
        m1.print();
        m2.print();
        m2 = null;
        m2 = new(.address(-1));
        $display("Last Address used: %0h", MemTrans::last_address);
        $display("Program Finished!");
        
    end


endprogram