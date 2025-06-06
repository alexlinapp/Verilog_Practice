module q7();
    
    logic [23:0] assoa_array[logic [29:0]];

    typedef bit [6:0] sevenBit;
    struct packed {sevenBit header; sevenBit cmd; sevenBit data; sevenBit crc;} myStruct;
    
    typedef enum {RED, BLUE, GREEN} color_e;
    color_e color;
    
    initial begin
        assoa_array[0] = 24'hA50400;
        assoa_array[30'h400] = 24 'h123456;
        assoa_array[30'h401] = 24 'h789ABC;
        assoa_array['1] = 24 'h0F1E2D;
        myStruct.header = 7'h5A;
        foreach(assoa_array[i]) begin
                $display("assoa_array[0x%0h] = 0x%0h", i, assoa_array[i]);
            end
        $display("Array size is: %0d", $size(assoa_array));
        $display("My Struct: %0h", myStruct.header);

        
        color = color.first;
        $display("REACHED HERE");
        do
            begin
                $display("Color = %0d/%s", color, color.name());
                color = color.next();
            end
        while (color != color.first());
    end


endmodule