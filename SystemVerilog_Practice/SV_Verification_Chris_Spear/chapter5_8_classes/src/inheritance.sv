class Transaction;
    rand bit [31:0] src, dst, data[8];
    bit [31:0] csm;

    virtual function void calc_csm();
        csm = src^ dst ^ data.xor;
    endfunction

    virtual function void display(input string prefix="");
        $display("%sTr: src=%0h, dst=%0h, csm=%0h", prefix, src, dst, csm);
    endfunction

endclass : Transaction

class BadTr extends Transaction:
    rand bit bad_csm;

    virtual function void calc_csm();
        super.calc_csm();
        if (bad_csm) csm = ~csm;
    endfunction

endclass

program automatic top;

    initial begin
        Transaction tr;
        BadTr bad, bad2;

        bad = new();
        tr = bad;       // base handle points to an extended object

        $cast(bad2, tr);    // cast tr to bad2, tr doesnt change but bad2 changes; basically bad2 = (type of bad2) (tr) in C language

    end


endprogram