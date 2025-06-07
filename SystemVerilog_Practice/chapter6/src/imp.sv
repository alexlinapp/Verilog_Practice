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