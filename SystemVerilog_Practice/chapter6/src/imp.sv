class Imp2;
    rand bit x; //  0 or 1
    rand bit [1:0] y;   // 0, 1, 2, or 3
    constraint c_xy {
        y > 0;
        (x==0) -> (y==0);
    }
    
    function new();
        
    endfunction //new()
endclass 

//Imp2

class Vars8;
    rand bit [7:0] pkt1_len, pkt2_len;  //  8-bits wide
    constraint total_len {
        pkt1_len + pkt2_len == 9'd64;   //  9-bit sum
    }
    function new();
        
    endfunction //new()
endclass //Vars8
