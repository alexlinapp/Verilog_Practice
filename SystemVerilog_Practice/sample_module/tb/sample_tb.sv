`timescale 1ns / 1ps
module sample_tb();
    localparam N = 3;   //  number of inputs to test
    logic               clk, reset;
    logic [N-1:0]       a;
    logic [2**N -1:0]   y, yexpected;
    logic [31:0]    vectornum, errors;
    logic [2**N + N - 1:0]     testvectors[64:0];   
    //  10,000 testvectors of N=1 bit widthfomrat: a_yexpected
    
    //  instantiate device under test
    Ndec #(.N(N)) uut(.a, .y);
    
    //  generate clokc
    always
        begin
            clk = 1;
            #5;
            clk = 0;
            #5;          
        end
    
    //  start of test, load vectors and reset
    initial
        begin   
            $readmemb("C:/Users/NODDL/Verilog_Practice/SystemVerilog_Practice/sample_module/test_files/Ndectest.txt", testvectors);
            vectornum = 0;
            errors = 0;
            reset = 1;
            #17;
            reset = 0;
        end
     
     // apply test vectors on rising edge, only works for combinational
     always @(posedge clk)
        begin
            #1;
            {a, yexpected} = testvectors[vectornum];
        end
        
        //  cehck reuslts on falling edge of clk
        always @(negedge clk)
            begin
                if (~reset)
                    begin
                        if (y !== yexpected)
                            begin
                                $display("Error: inputs = %b", a);
                                $display(" outputs = %b (%b expected)", y, yexpected);
                                errors = errors + 1;
                            end
                        vectornum = vectornum + 1;
                        if (testvectors[vectornum] === 'x)
                            begin
                                $display("%d tests completed with %d errors", vectornum, errors);
                                $stop;
                            end
                    end
            end 
endmodule
