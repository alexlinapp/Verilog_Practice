class Packet;
    //  The random variables
    rand bit [31:0] src, dst, data[8];
    randc bit [7:0] kind;
    //  Limit the values of src
    constraint c {src > 10; src < 15; }
    function new();
        
    endfunction //new()
endclass //Packet

program automatic test();


    initial begin
        $display("PEOGRAM RUN!");
    end

endprogram