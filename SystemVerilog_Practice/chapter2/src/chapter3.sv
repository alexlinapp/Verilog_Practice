module chapter3()
    program initailization;
        task check_bus();
            repeat (5) @ (posedge clock);
            if (bus_cmd === READ) begin
                logic [7:0] local_addr = addr << 2;
                $display("Local Addr = %h", local_addr);

            end

        endtask
    endprogram

endmodule