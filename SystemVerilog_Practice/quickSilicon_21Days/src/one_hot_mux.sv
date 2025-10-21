module one_hot_mux(
        input     wire[3:0] a_i,
        input     wire[3:0] sel_i,

          // Output using ternary operator
          output    wire     y_ter_o,
          // Output using case
          output    logic     y_case_o,
          // Ouput using if-else
          output    logic     y_ifelse_o,
          // Output using for loop
          output    logic     y_loop_o,
          // Output using and-or tree
          output    logic     y_aor_o
    );
   
    assign y_ter_o1 =    (a_i == 4'b0001) ? sel_i[0] : 
                        (a_i == 4'b0010) ? sel_i[1] :
                        (a_i == 4'b0100) ? sel_i[2] :
                        (a_i == 4'b1000) ? sel_i[3] : 'x;
                        
                        
    always_comb begin
        case (a_i)
            4'b0001: y_case_o = sel_i[0];
            4'b0010: y_case_o = sel_i[1];
            4'b0100: y_case_o = sel_i[2];
            4'b1000: y_case_o = sel_i[3];
            default: y_case_o = 'x;
        endcase
    end
    
    logic [3:0] temp;
    
    genvar i;
    generate
        for (i = 0; i < 4; i++) begin
            assign temp[i] = a_i[i] & sel_i[i];
        end
    endgenerate
    
    //assign y_loop_o = |temp;
    
    always_comb begin
        y_loop = '0;
        for (int i = 0; i < 4; i++) begin
            y_loop_o = (sel_i[i] & a_i[i]) | y_loop_o;
        end
    end
    
    
    
    
    assign y_aor_o = (a_i[0] & sel_i[0]) | 
                        (a_i[1] & sel_i[1]) |
                        (a_i[2] & sel_i[2]) |
                        (a_i[3] & sel_i[3]);
endmodule
