module debouncer(
         input logic clk,
         input logic btn_in,
         output logic btn_out
    );
    
    logic [17:0] counter;       //17 bit counter, ~ 1.3ms for 100MHz clock
    logic btn_sync_0, btn_sync_1;
    
    always_ff @(posedge clk) begin
        btn_sync_0 <= btn_in;
        btn_sync_1 <= btn_sync_0;
    end
    always_ff @(posedge clk) begin
        if (btn_sync_1 == btn_out) begin
            counter <= 0;   // button is stable
        end
        else begin
            counter <= counter + 1;
            if (counter == 17'h1FFFF)
                btn_out <= btn_sync_1;
        end
    
    end
endmodule
