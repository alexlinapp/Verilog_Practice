/*

Task: Can connsume time (i.e. have delays)
Functions: CANNOT consume time (i.e. no delays)
        - Cannot call a task usually
            - Can only call a task only in a thread spawned with the fork join_none statement

    
    To cast 

*/




module top;
    // Notice how we copy the array by reference using "const ref"
    // const does not allow routine to modify the varaible
    function automatic void print_csmll (const ref bit [31:0] a[]);
        bit [31:0] checksum = 0;
        for(int i = 0; i < a.size(); i++) begin
            checksum ^= a[i];
        end
        $display("The array checksum is %h", checksum);
    endfunction : print_csmll


    task automatic bus_read(input logic [31:0] addr, ref logic [31:0] data);

        // Requesst bus and drive address
        //bus_request <= 1'b1

    endtask : bus_read

    function automatic void init(ref int f[5], input int start);
        foreach (f[i])
            f[i] = start + i;
    endfunction










    
    bit [31:0] data_array[] = new[3];
    int fa[5];

    initial begin
        #5;
        data_array = '{32'hDEAD_BEEF, 32'hC0DE_CAFE, 32'hBAAD_F00D};
        $display("RUNNING\n");
        print_csmll(data_array);    // array literal in system verilog
        init(fa, 10);
        foreach (fa[i]) begin
            $display("fa[%0d] = %0d", i, fa[i]);
        end

    end
    
    
    



endmodule : top