//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// https://www.siliconcrafters.com/post/round-robin-arbiter
//
//////////////////////////////////////////////////////////////////////////////////


module priority_arbiter_paper(

    );
endmodule

module naive_priority_arbiter_4 (
    input   logic [3:0] req,
    output  logic [3:0] grant
);
    // use the inside so we can mask out bits usiing ? don't use casex or casez as they 
    // say match any. Not PURE masking
    always_comb begin
        case (req) inside
            4'b???1 : grant = 4'b0001;
            4'b??10 : grant = 4'b0010;
            4'b?100 : grant = 4'b0100;
            4'b1000 : grant = 4'b1000;
            default : grant = 'x;           // should not reach here!
        endcase
    end

endmodule


module param_priority_arbiter#(parameter N = 16)
(
    input   logic [N-1:0] req,
    output  logic [N-1:0] grant

);
    /*
    
        grant[0] = req[0]
        grant[1] = ~req[0] & req[1]
        grant[2] = ~(req[0] | req[1]) & req[2]
        higher_priority[N-1:0] = all the previous req signals
    */
    // remmeber we are specifyin HARDWARE!!!
    // treated as wires!
    logic [N-1:0] higher_pri_regs;
    // weird that this doesnt work..... 
    //assign higher_pri_regs[N-1:1] = higher_pri_regs[N-2:0] | req[N-2:0];
    genvar i;
    assign higher_pri_regs[0] = 1'b0;
    generate
        for (i = 1; i < N; i++) begin
            assign higher_pri_regs[i] = higher_pri_regs[i-1] | req[i-1];
        end
    endgenerate
    //assign higher_pri_regs[0] = 1'b0;   // because for first we have nothing before it to note
    assign grant[N-1:0] = req[N-1:0] & ~higher_pri_regs[N-1:0];
endmodule


//module naive_RR_arbiter
//(
//    input   logic [3:0] req,
//    input   logic clk, reset,
//    output  logic [3:0] grant
//);
//    logic [1:0] pointer_req, next_pointer_req;
    
//    always @(posedge clk) begin
//       if (reset)
//        pointer_req <= '0;
//       else
//        pointer_req <= next_pointer_req;
//    end
    
//    always_comb begin
//        next_pointer_req = '0;  // default state, prevent latches
//        case (grant)
//            4'b0001:
//            4'b0010:
//            4'b0100:
//            4'b1000: next_
        
//        endcase
//    end

//endmodule


/*
    Rotate + Priority + Rotate
    Idea: Rotate based upon pointer, then use priority and then rotate back
    Slower logic but minimal area when synthesized
*/
//module priority_arbiter_RPR#(parameter N = 4)(
//    input   logic 
//);

//endmodule

/*

Muxed parallel priority arbiters:
    - Basically rotate all possible reqest so from 0 to N-1 and precompute. Then use simple priroity on the rotateed.
    Then use MUX with pointer to select. Howevet the original wires are mapped to the grant so proper grant is given!
    
    Much faster! Everyrthign ahs already been precomputed. 
    However area is much much larger
*/



/*

Masked Priroity Arbtier (Most efficient)

*/
module mask_arb_helper#(parameter N = 4)
(
    input       logic [N-1:0]   req,
    output      logic [N-1:0]   grant
);
    assign grant[0] = req[0];
    genvar i;
    generate 
        for (i = 1; i < N; i++) begin
            assign grant[i] = req[i] & ~(|req[i-1:0]);
        end
    endgenerate
endmodule

module mask_arbiter #(parameter N = 4)
(
    input       logic           clk, reset,
    input       logic [N-1:0]   req,
    output      logic [N-1:0]   grant
);
    logic [N-1:0] curr_mask, next_mask;     // directly use it as states!
    logic [N-1:0] masked_grant, raw_grant;
    
    logic [N-1:0] masked_req;
    assign masked_req = curr_mask & req;
    
    /*
        Basically check if the masked part has anything if not, loop back
    */
    mask_arb_helper#(.N(N)) m_arb(.req(masked_req), .grant(masked_grant));
    mask_arb_helper#(.N(N)) r_arb(.req(req), .grant(raw_grant));
    
    assign grant = |masked_grant ? masked_grant : raw_grant;    // MUX to see if there is anything in masked_grant
    
    
    
    always_ff @(posedge clk) begin
        if (reset)
            curr_mask <= '0;
        else
            curr_mask <= next_mask;    
    end
    
    always_comb begin
        if (grant == '0)
            next_mask = curr_mask;
        else begin
            next_mask = '1;
            for (int i = 0; i < N; i++) begin
                next_mask[i] = 1'b0;
                if (grant[i]) break;        // check to see if the current grant signal is 1. Should only have 
                // one grant signal. If it is then we break and we mask eveythign until we reacht teh first grant signal
            end
        
        end
    end
endmodule


// output is synchrnonous and not combinational
module mask_arbiter_sync #(parameter N = 4)
(
    input       logic           clk, reset,
    input       logic [N-1:0]   req,
    output      logic [N-1:0]   grant
);
    logic [N-1:0] curr_mask, next_mask;     // directly use it as states!
    logic [N-1:0] masked_grant, raw_grant;
    
    logic [N-1:0] masked_req;
    assign masked_req = curr_mask & req;
    
    /*
        Basically check if the masked part has anything if not, loop back
    */
    mask_arb_helper#(.N(N)) m_arb(.req(masked_req), .grant(masked_grant));
    mask_arb_helper#(.N(N)) r_arb(.req(req), .grant(raw_grant));
    
    assign grant = |masked_grant ? masked_grant : raw_grant;    // MUX to see if there is anything in masked_grant
    
    
    
    always_ff @(posedge clk) begin
        if (reset)
            curr_mask <= '0;
        else
            curr_mask <= next_mask;    
    end
    
    always_comb begin
        if (grant == '0)
            next_mask = curr_mask;
        else begin
            next_mask = '1;
            for (int i = 0; i < N; i++) begin
                next_mask[i] = 1'b0;
                if (grant[i]) break;        // check to see if the current grant signal is 1. Should only have 
                // one grant signal. If it is then we break and we mask eveythign until we reacht teh first grant signal
            end
        
        end
    end
endmodule





// ideally use a program block as all statements in progam blocko execute in teh REACTIVE region!!
// Don't put clock generator in progam block as it can create a race condition
/*
Simluation ends when the last progam (block) completes. IF tehre are several proram blocks, simulation
ends when teh last progam completes. This way the simulation ends when the last test completes!
Simulation ends EVEN if ther are threads running in the progam or moduels!!!

- However can have FINAL block block that contaisn code to be run just before the simulator terminates


*/

program automatic priority_arbiter_program#(parameter N = 4)(input logic clk, output logic reset, input logic [N-1:0] grant, output logic [N-1:0] req);
    task automatic naive_tb;
         repeat (3) @(negedge clk);
         for (int i = 1; i < $pow(2, N); i++) begin
            req = i;
            @(negedge clk);
            // do not put asssert right afterwards!!!
            // as same time delta (program executes in reactive region, DUT executes in active region
            
            assert(grant == (i & -i))
            else $display("Req: %0d, Expected: %0d, Actual: %0d", req, (i&-i), grant);
         end
    endtask
    
    
    task automatic RR_arbiter_tb;
        int prevGrant = 0;
        int x;
        int counter = (1 << N) < 200 ? (1 << N) : 200;
        for (int i = 0; i < counter; i++) begin
            @(negedge clk);
            req = $urandom_range(0, 1 << N - 1);
            #0;                     // delays the delta cycle, so we 
            // goback to active region and DUT updates based upon request
            // and then we get the correct ouput grant!
            // if we don't do this, then the grant will use the "old" req. 
            /*
                And the GRANT does not Rerun!!! It has not been schuedled to runa nymore in teh reactive region
            
            */
            prevGrant = grant;
            @(posedge clk);
            assert ($countones(grant) == 1 || $countones(grant) == 0)
            else $display("Too many ones: Grant: %0b", grant);
            //$display("Iteration %0d, prevGrantL %0d", i, prevGrant);
            // use bit trick ~(x-1)
            if (~(prevGrant - 1) & req) begin
                x = ~(prevGrant - 1) & req;
                assert ((x & -x) == grant)
                else $display("Failed Grant1: Iteration: %0d, Expected: %0d, Actual: %0h", i, (x&-x), grant);
            end
            else begin
                x = req;
                assert ((x & -x) == grant)
                else $display("Failed Grant2: Iteration: %0d, Expected: %0h, Actual: %0h", i, (x&-x), grant);
            end
        end
        
    endtask
    
//    task para_pri_arbiter_tb;
//        repeat (3) @(negedge clk);
//        for (int i = 0; i < $pow(2, N); i++) begin
        
        
//        end
    
//    endtask
    
    initial begin
    // reset <= '0;         inisde a program block, scheduled to active in the Re-NBA REGION! NOT THE NBA REGION!
    // if you look at chatper 4.5 in the refernece manual you can see that after post-Re-NBA, 
    // that we can go back to the ACTIVE  region!!!! So then the DUT can be exectued again!    
        reset <= 1'b1;
        repeat (3) @(negedge clk);
        reset <= 1'b0;
        //repeat (3) @(negedge clk);
        //naive_tb();
        RR_arbiter_tb();
    end

endprogram

module priority_arbiter_paper_tb;

    localparam N = 4;
    // top leevel signals all functions can see
    logic [3:0] grant;
    logic [3:0] req;
    logic clk, reset;
    
    clock_generator_sim clk_gen(.*);
    
    //naive_priority_arbiter_4 DUT1 (.*);
    
    //param_priority_arbiter #(.N(N)) DUT2 (.*);
    
    priority_arbiter_program#(.N(N)) test1(.*);
    
   // mask_arb_helper#(.N(N)) DUT3 (.*);
    mask_arbiter #(.N(N)) DUT4 (.*);
    
    final begin
        $display("All tests have ended\n");
    end
endmodule
