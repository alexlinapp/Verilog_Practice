module procedures;

/*
SystemVerilog supports two types of procedural blocks: Initial versus always

Initial: Verificaton construct, typically not synthesizable

Always: Infinite loops
    -always: repeats infintely
    -always_ff: Sequnetial logic devices like flip flops
    always_comb: Combinational logic
    always_latch: Latched beahvior


    Senesitivty list: List of signals for which a value change trigger execution of procedure
    
    Signals in sensitivty list can be separated by comma or using "or" 
    (or is simply a separator in the context of sensivity list)
    
    Can either use always @(...) with the sensitivity list 
    or use corresponding always_ff, always_comb, always_latch to let Vivado infer
    senesitivty list
*/

    logic clk;
    logic q;
    logic d;
    logic a, b;
    logic [1:0] sum;
    always_ff @(posedge clk)
        q <= d;
    
    
    //  named statement group
    // allows for temporary variable declarations that cannot be referenced outside of the group
    // in synthesizable RTL
    always_comb
        begin: add
            sum = a + b;
            //var logic [7:0] tmp;    //local temp variable
            //  let hand side of procedural assignments can only be variable types
        end
    always_ff @(posedge clk) 
        begin: tempvar
            logic [7:0] tmp;
        
        end
        
        
        
     // Synthesized Mux using if-else
     module mux2to1 #(parameter N =4)
    (input logic   sel,
     input  logic [N-1:0]   a,b,
     output logic [N-1:0]   y
     );
        always_comb begin
            if (sel) y = a;
            else y = b;
        end
     
     
     endmodule
     
     // Synthesis does not allow comparing X and Z values
     
     // use case (selector) inside endcase which uses ==? operator and allows bits
     // to be masked from the comparison
     // Any bit in the case ITEM that is either X or Z or ? is masked 
     // 
     // is ignored
     
     /*
        Case items are evaluted in the order in which they are listed. 
        Thus each case item has priority over all subsequent case items
        Inferred priroity encoding is not desirable
     */
     logic [3:0] selector;
     logic out;
     always_comb begin
        case (selector) inside
            4'b1???: out = a;
            4'b10??: out = 4'b0010;
            default: out = '0;
        
        endcase
     end
     
     // alternate priority4to2encoder using inherent priority in case statement
     logic [3:0] d_in;
     logic [1:0] d_out;
     logic          error;
     
     always_comb begin
        error = '0;
        case (d_in) inside
            4'b1??? : d_out = 2'h3;
            4'b01?? : d_out = 2'h2;
            4'b001? : d_out = 2'h1;
            4'b0001 : d_out = 2'h0;
            4'b0000 : begin
                d_out = 2'b0;
                error = '1;
            end
        
        
        endcase
     
     end
     
     logic [1:0] state;
     // three modifiers for if else and case statements
     // unique, unique0, priority
     // Unqiue: For syntehiss inform compilers that case statmeent is complete
     // even if not functionally complete and that parallel evaluation of case items is OK
     // For simulation, enables two run-time checks and violation report will be generated if
     // the case statement is evaluated and value of state does not match any or multiple items
     // generated in messages view
     always_comb begin
        unique case(state)
            2'b00 : out = 1'b0;
            2'b01 : out = 1'b0;
            2'b10 : out = 1'b0;
        endcase
     end
     
     /*
        For loops
        for (initial assignemnt; end expression; step_assignment) 
            statement_or_statement_group
     
        Synthesizers implement loops by first "unrolling" the lop meaning the statement
        or begin-end statement group in the loop is replicated the number of times that
        loop iterates
     */
     // both statements below are functionally equivalent
     
     parameter N = 4;
     logic [N-1:0] e, f, g;
     always_comb begin 
        for (int i = 0; i <= N-1; i++)
            g[i] = e[i] ^ f[(N-1)-i];
     end
     
     // equivalent to
     always_comb begin
        g[0] = e[0] ^ f[3-0] ;
        g[1] = e[1] ^ f[3-1];
        g[2] = e[2] ^ f[3-2];
        g[3] = e[3] ^ f[3-3]; 
     
     end
     
endmodule
