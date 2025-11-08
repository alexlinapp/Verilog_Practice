/*
Clock generator for simulation
*/
module clock_generator_sim(
        output bit clk
    );
    // not synthesizable. But will be assigned at timestep before 0 ONCE
    bit local_clk = 0;
    assign clk = local_clk;
    always #5 local_clk = ~local_clk;
endmodule
