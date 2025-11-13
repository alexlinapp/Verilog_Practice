class Transaction;
    rand bit [31:0] src, dst, data[8];  // random variables
    bit [31:0] csm;                     // calcualted variable

    virtual function void calc_csm();   // functions in system verilog classes are automatic by defualt
        csm = src ^ dst ^ data.xor;
    endfunction

    virtual function void display(input string prefix="");
        $display("%sTr: src=%h, dst=%h, csm=%h, data=%p", prefix, src, dst, csm, data); // p is NOT for pointer. It means pretty print in system verilog. REcrueslvey print, used for arrays and etc
    endfunction



endclass


class BadTr extends Transaction;
    rand bit bad_csm;

    virtual function void calc_csm();
        super.calc_csm();           // compute good csm
        if (bad_csm) csm = ~csm;    // corrupt the CSM bits
    endfunction

    virtual function void display(input string prefix="");
        $write("%sBadTr: bad_csm=%b, ", prefix, bad_csm);
        super.display();
    endfunction
endclass


class Base;
    int val;    // by default are public
    function new(input int val);        // constructor
        this.val = val;
    endfunction


endclass

class Extended extends Base;
    function new(input int val);
        super.new(val); // must be first line of new
        // other constructor actions
    endfunction

endclass

// pure virtual class
virtual class BaseTr;
    static int count;   // Number of instances created
    int id;

    function new();
        id = count++;   // give each object a unqiue ID

    endfunction

    pure virtual function bit compare(input BaseTr to); // no need to endfunction or endtask!
    pure virtual function BaseTr copy(input BaseTr to=null);
    pure virtual function void display(input string prefix="");

endclass



program automatic top;
    event e1, e2;
    /*

        All initialk blocks RUN concurrently!! Run in parallel threads. However not the simuluation event scheudlear scheduels each thread to run in some order for each tiem delta
    */
    initial begin
        $display("@%0t: 1:  before trigger", $time);
        -> e1;
        @e2;
        $display("@%0t: 1: after trigger", $time);

    end
    initial begin
        $display("@%0t: 2:  before trigger", $time);
        -> e2;
        @e1;
        $display("@%0t: 2: after trigger", $time);

    end

    final begin
        $display("Finished Program!");
    end

endprogram


program automatic top_assert;


endprogram


class Packet;
// Random variables
rand bit [31:0] src, dst, data[8];
randc bit [7:0] kind;                   // randc means random cyclcic, rnadom solver does nto repeat values until every possible value has been assigned
constraint c {src > 10;
                src < 15;}

endclass

program automatic top_rand;
    Packet p;

    initial begin
        p = new();  //creates a packet
        if (!p.randomize())
            $finish;
        $display("This is src: %0d, dst: %0d, data: %0p\n", p.src, p.dst, p.data);
    end

endprogram