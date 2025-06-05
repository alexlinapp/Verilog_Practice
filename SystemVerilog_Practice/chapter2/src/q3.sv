module q3();
    bit [11:0] my_array [4];
    logic my_array1 [5][31];
    bit [4:0] [30:0] my_array2;
    initial begin
        my_array[0] = 12'h012;
        my_array[1] = 12'h345;
        my_array[2] = 12'h678;
        my_array[3] = 12'h9AB;

    //  traverse the array
    for (int i = 0; i < $size(my_array); i++) begin
            $display("%d", my_array[i][5:4]);
        end
    foreach (my_array[i]) begin
            $display("%d", my_array[i][5:4]);
        end
    foreach (my_array[i]) begin
            $display("my_array[%0d]=12'b%b", i, my_array[i]);
        end
    $displayh(my_array);

    my_array2[3] = 32'b1;

    end
    
    




endmodule