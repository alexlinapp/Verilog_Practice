/*

Race Conditions Between DUT and TB during simulation
    - If TB drives DUT at the clock edge say in same simulation phase, could have value propage to some DUT inputs
    before testbench stimulus and is later to other parts


Solution? Use program blocks:
    - Cannot instanites other moduels, itnerfaces or programs i.e. no hierarchy
    - Tells SystemVerilog to sepearete the testbench events from design events

    From previous timeslot->Active Region -> Observed region -> Reactive Region (can loop back to Active if more events) -> Postponed
        - Active Region: Simulation of design code in modules
        - Observed: Evaluation of SystemVerilog Assertions
        - Reactive: Execution of testbench code in programs (PROGRAM BLCOKS!!)
        - Postponsed: Sampling design signals for testbench input
*/

/*
Use Clocking block:

clocking cb @(posedge clk);
    input sig_in;   // from DUT to testbench
    output sig_out; // from testbench to DUT


    // Input: Sampled by testbench: JUST AFTER the active region of DUT, just before the last clock edge, in POSTPONED region, i.e. postponed region in the previous STEP
    IEEE Standard: 
    "Unless otherwise specified, the default input skew is 1step and the default output skew is 0. A step is a
    special time unit whose value is defined in 3.14.3
    . A 1step input skew allows input signals to sample their
    steady-state values in the time step immediately before the clock event (i.e., in the preceding Postponed
    region)
    // Output: Driven to DUT: Driven during the Reactive region, after curent active & observed but BEFORE the active region in the NEXT time step

    // Both input and output are sampled/driven in the Reactive Region in a singel delta cycle

    // when you READ signal from a clocking block (INPUT SIGNALS), you get the values sampled from just befor ethe LAT clcok edge (i.e. postponed region)


*/

// use automatic keyword for tests





interface arb_if(input bit clk);
    logic [1:0] grant, request;
    bit rst;
    
    clocking cb @(posedge clk);
        output request;
        input grant;
    endclocking : cb

    modport TEST (clocking cb, output rst);
    modport DUT (input request, rst, clk, grant);
endinterface : arb_if





program automatic test(arb_if.TEST arbif);
    initial begin
        $monitor("@%0t: grant=%h", $time, arbif.cb.grant);
        #500ns $display("End of test");
    end

endprogram : test

module arb_dummy(arb_if.DUT arbif);
    initial
        fork
            #70ns arbif.grant = 1;
            #170ns arbif.grant = 2;
            #250ns arbif.grant = 3;
        join

endmodule : arb_dummy

module top;
    bit clk;
    always #50 clk = ~clk;

    arb_if arbif(clk);
    arb_dummy dut(arbif);
    test tb(arbif); // once program is instantiated it starts running immedaitley
    initial begin
        $display("TEST FINISHED!");
    end

endmodule : top