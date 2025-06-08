class Exercise1;
    rand bit [7:0] data;
    rand bit [3:0] address;
    constraint address_c {address inside {[3:4]};}

    function new();

    endfunction //new()
endclass //Exercise1


class Exercise2;
    rand bit [7:0] data;
    rand bit [3:0] address;
    constraint address_c {address dist {0 := 1, [1:14] :/ 8, 15 := 1}; }
    constraint data_c {data == 5;}
    function new();

    endfunction //new()
endclass //Exercise1

program automatic test();
    Exercise1 e1;
    Exercise2 arrayE3[20];
    initial begin
        e1 = new();
        e1.randomize();
        $display("e1: Address: %0d\nData: %0d", e1.address, e1.data);
        for (int i = 0; i < 20; i++) begin
            arrayE3[i] = new();
            arrayE3[i].randomize();
            $display("E3.%0d: data = %0d, address = %0d", i, arrayE3[i].data, arrayE3[i].address);
        end
    end

endprogram