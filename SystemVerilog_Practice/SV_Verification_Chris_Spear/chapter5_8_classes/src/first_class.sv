
// need to "forward" declare the Statistics class
typedef class Statistics;

class Transaction;
    bit [31:0] addr, csm, data[8];
    static int count = 0;       // shared acorss al isntance so the object
    int id;
    Statistics stats;
    function new();
        addr = 3;
        data = '{default:5};    // set all of data elemetns to 5
        id = count++;
        stats = new();

    endfunction

    // function new(input logic [31:0] a=3, d=5) 
    //     addr = a;
    //     data = '{default:d};
    // endfunction

    function void display();
        $display("Transaction: %h", addr);
    endfunction

    function void calc_csm();
        csm = addr ^ data.xor;
    endfunction

    // can also define functions outside of the class body
    // use the extern keyword for this
    extern function void extern_display();

    endfunction

endclass : Transaction

function void Transaction::extern_display();
    addr = addr + 1;
    $display("Extern Transaction: %h", addr);
endfunction

class Statistics;
    time startT;            // Transaction start time
    static int ntrans = 0;   // Transaction count
    static time total_elapsed_time = 0;

    function void start();
        startT = $time;
    endfunction

    function void stop();
        time how_long = $time - startT;
        ntrans++;
        total_elapsed_time += how_long;
    endfunction


endclass : Statistics






program automatic top;

    initial begin
        Transaction tr1, tr2;     // Declare a handle, intialzied to NULL
        tr1 = new();         // Allocate a transcation object, very similar to malloc() in C; new() is called the construtor
        tr1.extern_display();
        tr1.display();
        $display("Program ends!");
    end


endprogram : top