`timescale 1ns / 10ps

module disp_mux_tb();
    //  declaration
    localparam T = 20;  //  clock period
    reg clk, reset;
    reg[7:0] in0, in1, in2, in3;
    wire[3:0] an;
    wire[7:0] sseg;
    
    //  initailize uut
    
    disp_mux uut(.clk(clk), .reset(reset),
                    .in0(in0), .in1(in1), .in2(in2), .in3(in3),
                    .an(an), .sseg(sseg));
    
    //  start clock forever
    always
    begin
        clk = 1'b1;
        #(T/2);
        clk = 1'b0;
        #(T/2);
    end
    
    //  reset initially
    initial
    begin
    reset = 1'b1;
    #(T/2);
    reset = 1'b0;
    end
    
    //  button stimulus
    initial
    begin
    @(negedge reset);
    @(negedge clk);
    in0 = 8'b00000000;
    in1 = 8'b00000001;
    in2 = 8'b00000010;
    in3 = 8'b00000011;
    #1000;
    
    
    
    $stop;
    end
endmodule
