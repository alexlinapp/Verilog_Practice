task automatic genTask(input int delay, input int taskNum);
    #(delay);
    $display("Task%0d finished!", taskNum);
endtask //automatic
task automatic task1();
    #5;
    $display("Task1 finished!");
endtask //automatic

task automatic task2();
    #5;
    $display("Task2 finished!");
endtask //automatic
task automatic task3();
    #5;
    $display("Task3 finished!");
endtask //automatic


program automatic fork1();
    initial begin
        // $display("====Fork Join====");
        // fork
        //     genTask(3, 1);
        //     genTask(5, 2);
        // join
        // $display("====Fork Join Any====");
        // fork
        //     genTask(3, 3);
        //     genTask(5, 4);
        // join_any

        // $display("====Fork Join None====");
        // fork
        //     genTask(1, 5);
        //     genTask(3, 6);
        // join_none
        // $display("Reached End of Program!");
        for (int j = 0; j < 3; j++)
            fork
                automatic int k = j;
                begin
                   $write(k); 
                end
            join_none
            #0 $display("Finsiedh");
    end
    

endprogram