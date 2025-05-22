module dual_edge_detector(
    input wire clk, reset,
    input wire level,
    output reg tick
    );
    
    //  symbolic state declaration
    localparam[1:0]
        zero = 2'b00,
        up_edge = 2'b01,
        one = 2'b10,
        down_edge = 2'b11;
        
    //  signal declaratino for state signals
    reg[1:0] s_curr, s_next;
    
    //  state register
    always @(posedge clk, posedge reset)
        begin
            if (reset)
                s_curr <= zero;
            else
                s_curr <= s_next;
        end
    
    //  next state logic and output logic combined
    
    always @*
        begin
            //set default state
            s_next = s_curr;
            tick = 1'b0;
            case (s_curr)
                zero:
                    begin
                        if (level)
                            s_next = up_edge;
                    end
                up_edge:
                    begin
                        tick = 1'b1;
                        if (level)
                            s_next = one;
                        else
                            s_next = down_edge;
                    end
                one:
                    begin
                        if (~level)
                            s_next = down_edge;
                    end
                down_edge:
                    begin
                        tick = 1'b1;
                        if (level)
                            s_next = up_edge;
                        else
                            s_next = zero;
                    end  
                default: s_next = zero;
            endcase   
        end
endmodule
