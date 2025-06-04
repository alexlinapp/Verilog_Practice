module array_copy();
    int q[$] = '{3,4};
    int j = 1;
    initial
        begin
            static bit [31:0] src[5] = '{0,1,2,3,4},
                        dst[5] = '{5,4,3,2,1};
    
            //  Aggregate compare the two arrays
            if (src == dst)
                $display("src == dst");
            else
                $display("src != dst");

            //int j = 1;
            
            $write("queue:");
            foreach (q[i])
                begin
                    $write(" %d", q[i]);
                end
            $display;

            j = q[0];
            $display("queue1: %p", q);
            
        end
 endmodule
