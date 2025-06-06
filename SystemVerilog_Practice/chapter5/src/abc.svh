package abc;
    class Transaction;

        //  class body
        logic [31:0] addr, csm, data[8];

        function new();
            addr = 3;
            data = '{default:5};
        endfunction
    endclass


endpackage