class Bathtub;
    int value;
    int WIDTH = 50, DEPTH = 6, seed = 1;

    function void pre_randomize();
        //  Calcualte an exponential curve
        value = $dist_exponential(seed, DEPTH);
        if (value > WIDTH) value = WIDTH;

        //  Randomly put point on the left or right curve
        if ($urandom_range(1))  //  random = 0 or 1
            value = WIDTH - value;
    endfunction
    
    
    function new();
        
    endfunction //new()
endclass //Bathtub


program automatic test();

    int randValue;
    Bathtub Bt1;
    initial begin
        Bt1 = new();
        for (int i = 0; i < 9; i++) begin
            $write("%0d", $urandom_range(1));
        end
        for (int i = 0; i < 1000; i++) begin
            Bt1.randomize();
            $write("%0d ", Bt1.value);
            if (i % 10 == 0)
                $display();
        end
        $display("\nFinished Simualtion.");
    end


endprogram