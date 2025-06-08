/*
* Constraining a dynamic array


*/
class good_sum5;
    rand int unsigned len[];
    constraint c_len {foreach (len[i])
                        len[i] inside {[1:255]};
                    len.sum() < 1024;
                    len.size() inside {[1:8]};}


endclass

//  general class to generate max_value unqiue random numbers, cyclic
class RandcRange;
    randc bit [15:0] value;
    int max_value;  //  maximum possible value

    function new(input int max_value = 10);
        this.max_value = max_value;
    endfunction

    constraint c_max_value {value < max_value;}
endclass

//  generate a random array of unqiue values
class UniqueArray;
    int max_array_size, max_value;
    rand bit [15:0] ua[];   //  array of unique values
    constraint c_size {ua.size() inside {[1:max_array_size]};}
    
    
    function new(input int max_array_size=2, max_value=2);
        this.max_array_size = max_array_size;
        if (max_array_size > max_value)
            this.max_value = max_array_size;
        else
            this.max_value = max_value;
    endfunction //new()

    function void post_randomize();
        RandcRange rr;
        rr = new(max_value);
        foreach (ua[i]) begin
            rr.randomize();
            ua[i] = rr.value;
        end

    endfunction

    function void display();
        $write("Size: %3d:", ua.size());
        foreach (ua[i]) $write("%4d", ua[i]);
        $display();
    endfunction
endclass //UniqueArray

class RandStuff;
    rand bit [31:0] value;
endclass

class RandArray;
    rand RandStuff array[];
    int MAX_SIZE = 10;
    constraint c {array.size() inside {[1:MAX_SIZE]};}
    function new();
        array = new[MAX_SIZE];
        foreach (array[i])
            array[i] = new();
    endfunction

    function pre_randomize();
        array = new[MAX_SIZE];
        foreach (array[i])
            array[i] = new();
    endfunction
endclass

program automatic test();
    UniqueArray ua;
    initial begin
        ua = new(50);

        repeat (10) begin
            ua.randomize();
            ua.display();
        end

        ra = new();
        ra.randomize();
        foreach (ra.array[i])
            $display(ra.array[i].value);
    end

endprogram