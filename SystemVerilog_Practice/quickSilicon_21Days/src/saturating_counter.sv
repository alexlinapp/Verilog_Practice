/*
Saturating counter that DOES NOT WRAP!

*/
module saturating_counter#(parameter N = 3)
(
    input   logic           clk, reset, enable,
    input   logic           up_down,
    output  logic [N-1:0]   out 
);
logic [N-1:0] out_n;        // next output
logic [N-1:0] state_c, state_n;     // states
assign out_n = state_n;             // state direcltly outputs its number
// output flip flop
always_ff @(posedge clk) begin
    if (reset)
        out <= '0;
    else if (enable)
        out <= out_n;
end

// design decission to use enable directly as in flip flop
always_ff @(posedge clk) begin
    if (reset)
        state_c <= '0;              // let the state be equal to whatever current output we have
    else if (enable)
        state_c <= state_n;
end

always_comb begin
    state_n = state_c;
    if (up_down && (state_c != ((1 << N) - 1)))    // if it is one
        state_n = state_c + 1;
    else if (~up_down && state_c != '0)           // it is 0, we down count
        state_n = state_c - 1;
    // we don't use enables here as it is easier to just put enables to flip flops
end


endmodule

interface sat_intf#(parameter N = 3)(input logic clk);
    logic reset, enable;
    logic up_down;
    logic [N-1:0] out;
    
    clocking cb @(posedge clk);
        // relative to TB
        input out;
        output enable, up_down;
    endclocking
    
    modport TEST(clocking cb, output reset, input clk, input enable, input out);
    
    modport DUT(input reset, enable, up_down, output out);

endinterface
program automatic prog#(parameter N = 3)(sat_intf.TEST intf);

    assert property (@(intf.clk) ~intf.enable |-> ##1 $stable(intf.out))
    else $display("Assertion failed at time %0t, enable=%b, out=%0d", $time, intf.enable, intf.out);
    


    task automatic test1;
        $display("Starting test1!\n=========\n");
        intf.cb.up_down <= 1'b1;
        intf.cb.enable <= 1'b1;
        // assertions are checked during the observed region!
        repeat (3) @(intf.cb);         // sampled in preponed regiono fcurrent time slot (post poned of previous_
        // should see up by 3;
        // driven (rght) AFTER the rising edge
        intf.cb.up_down <= 1'b0;
        assert (intf.cb.out == 2)
        else $display("Time: %0t: Failed assert 1: Expected: %0d, Actaul: %0d", $time, 2, intf.cb.out);
        repeat (2) @(intf.cb);
        assert (intf.cb.out == 2)   // 
        else $display("Time: %0t: Failed assert 2: Expected: %0d, Actaul: %0d", $time, 2, intf.cb.out);
        intf.cb.up_down <= 1'b1;
        repeat (10) @(intf.cb);
        assert (intf.cb.out == (1 << N)- 1)
        else $display("Time: %0t: Failed assert 3: Expected: %0d, Actaul: %0d", $time, (1 << N)- 1, intf.cb.out);
        intf.cb.up_down <= 1'b0;
        repeat (3) @(intf.cb);
        assert (intf.cb.out == (1 << N)- 3)
        else $display("Time: %0t: Failed assert 4: Expected: %0d, Actaul: %0d", $time, (1 << N)- 3, intf.cb.out);
        intf.cb.enable <= 1'b0;
        repeat (3) @(intf.cb);
        assert (intf.cb.out == (1 << N)- 4)
        else $display("Time: %0t: Failed assert 5: Expected: %0d, Actaul: %0d", $time, (1 << N)- 4, intf.cb.out);
    endtask
    
    initial begin
        intf.reset <= 1'b1;
        repeat (3) @(intf.cb);
        intf.reset <= 1'b0;
        test1;
    end

endprogram


module sat_count_top;
    logic clk = 0;
    always #5 clk = ~clk;
    localparam N = 3;
    sat_intf #(.N(N)) intf(.*);
    saturating_counter #(.N(N)) DUT(.clk, .reset(intf.reset),
                                    .enable(intf.enable),
                                    .up_down(intf.up_down),
                                    .out(intf.out));
    prog #(.N(N)) prog1(intf);
    
    
    
endmodule


