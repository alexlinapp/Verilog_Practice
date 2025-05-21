module square_wave_gen
    #(parameter N = 4)
    (
    input wire clk, reset,
    input wire[N-1:0] m, n,
    output wire q,
    output wire[N+2:0] c
    );
    //  period of physical clock. Assumed to be in ns
    // localparam T = 20;
    reg q_curr, q_next;
    reg[N+2:0] counter, counter_next;
    //  register for current state
    always @(posedge clk, posedge reset)
        begin
            if (reset)
                q_curr <= 0;
            else
                q_curr <= q_next;
        end
    //  counter register
    always @(posedge clk, posedge reset)
        begin
            if (reset)
                counter <= 0;
            else
                counter <= counter_next;
        end
    //  next state logic: states: 1 = ON, 0 = OFF
    //  counter
    always @*
        begin
            q_next = q_curr;
            counter_next = counter;
            if (q_curr)
                begin
                    if (counter >= m * 5 - 1) 
                        begin
                            q_next = 1'b0;
                            counter_next = 0;
                        end
                    else
                        counter_next = counter + 1;
                end
            else
                begin
                    if (counter >= n * 5 - 1)
                        begin
                            q_next = 1'b1;
                            counter_next = 0;
                        end
                     else
                        counter_next = counter + 1;
                end
        end
    //  output logic
    assign q = q_curr;
    assign c = counter;
endmodule
