/*
Protocol: What signals exist on the bus and what signals need to be active when we do a read or write transfer!
 Does not specify hwo to fetch or store data, ONLY how control signals must behave on the BUS!
 DATA must appear/travel on PWDATA but does not specify how the master fetches teh data to be put on PWDATA
Reference: https://logicmadness.com/apb-protocol/#APB_Protocol_RTL_Code

file:///C:/Users/NODDL/Downloads/IHI0024E_amba_apb_architecture_spec.pdf
https://www.vlsimentor.com/post/amba-protocols-showdown-axi-vs-ahb-vs-apb-choosing-the-right-bus-for-your-soc-design
*/



module APB_master_intf(
    input   logic           clk, reset,
    input   logic [1:0]     cmd_i,      // custom cmd to specify what to do
    
    output  logic           psel_o,     // slave select. only one slave so 1 when slave is slected 0 otherwise
    output  logic           penable_o,  // indicates beginning of access phase
    output  logic [31:0]    paddr_o,    // address that carries adress from master to the slave
    output  logic           pwrite_o,   // 0 = read,  1 = write
    output  logic [31:0]    pwdata_o,   // write data bus that carries data from the master to the slave
    input   logic           pready_i,   // used by slave to request wait states if it cannot complete transfer
    input   logic [31:0]    prdata_i    // read data that carries data frmo the slave to the master

);
    typedef enum logic [1:0] {IDLE, SETUP, ACCESS} state;
    state curr_s, next_s;
    logic [31:0] prdata_prev;
    always_ff @(posedge clk) begin
        if (reset)
            curr_s <= IDLE;
        else
            curr_s <= next_s;
    end
    
    // next state logic
    
    always_comb begin
        next_s = curr_s;
        case (curr_s) 
        IDLE: begin
            case (cmd_i)
                2'b01, 2'b10: next_s = SETUP;
                default: next_s = IDLE;
            endcase
        end
        SETUP: next_s = ACCESS;     // SETUP phase ensures slave sees proper address and etc before egde
        ACCESS: begin
            case (pready_i)
                1'b0: next_s = ACCESS;
                1'b1: begin
                    if(cmd_i == 2'b10 || cmd_i == 2'b01)
                        next_s = SETUP;
                    else
                        next_s = IDLE;
                end
            endcase
        end
        
        endcase
    
    end
    
    // combinatial output logic
    assign psel_o = (curr_s == SETUP) || (curr_s == ACCESS);
    assign penable_o = (curr_s == ACCESS);
    assign pwrite_o= cmd_i[1];
    assign paddr_o = 32'hDEAD_CAFE;
    assign pwdata_o = prdata_prev + 32'h1;
    
    always_ff @(posedge clk) begin
        if (reset)
            prdata_prev <= '0;
        else if (curr_s == ACCESS && pready_i)
            prdata_prev <= prdata_i;
    end
//    always_comb begin
//        {psel_o, penable_o, paddr_o, pwrite_o, pwdata_o} = 'x;  // set to x or don't care automatically
//        case (curr_s)
//            IDLE: {psel_o, penable_o} = 2'b0;
//            SETUP: begin
//                case (cmd_i) 
//                    //{psel_o, penable_o, paddr_o, pwrite_o, pwdata_o} = '0;
//                    2'b01: {psel_o, penable_o, paddr_o, pwrite_o, pwdata_o} = {1'b1, 1'b0, 32'hDEAD_CAFE, 1'b0, 32'b0};
//                    2'b10: {psel_o, penable_o, paddr_o, pwrite_o, pwdata_o} = {1'b1, 1'b0, 32'hDEAD_CAFE, 1'b0, 32'b0};
//                    2'b11, 2'b00: {psel_o, penable_o, paddr_o, pwrite_o, pwdata_o} = 'x;   // invalid not possible
//                endcase
            
//            end
//            ACCESS: {psel_o, penable_o, paddr_o, pwrite_o, pwdata_o} = '0;
//            default: {psel_o, penable_o, paddr_o, pwrite_o, pwdata_o} = 'x; 
//        endcase
//    end
endmodule


/*

Actual interface

*/

interface APB_if (input logic clk);
    logic reset;
    logic [1:0]     cmd_i;      // custom cmd to specify what to do
    logic           psel_o, penable_o, pwrite_o, pready_i;
    logic [31:0]    paddr_o, pwdata_o, prdata_i;     // slave select. only one slave so 1 when slave is slected 0 otherwise
    
    // create a clokcing block using clocking keyword
    /*
        When using clocking block ALWAYS use <= to drive ouptut signals!!!
        Because using = is sequnetial thus races, while <= is concurrent
    */
    clocking cb @(posedge clk);
        default input #1step;  // sample inputs every edge
        // output and input viewed with respect to the program/testbench. So ouptut means program->DUT
        // input means DUT->program/testbench
        input psel_o, penable_o, paddr_o, pwrite_o, pwdata_o;
        output cmd_i, pready_i, prdata_i;
    endclocking
    
    clocking cb2 @(posedge clk);
    
    endclocking
    
    modport TEST (clocking cb, output reset);   // use clocking block
    
    modport DUT (input prdata_i, pready_i, cmd_i, output psel_o, penable_o, pwrite_o, paddr_o, pwdata_o);
    
endinterface

program automatic APB_prog(APB_if.TEST arb_if);
    task automatic test1();
        arb_if.cb.cmd_i <= 2'b01;
        arb_if.cb.pready_i <= 1'b0;
        while (~arb_if.cb.psel_o || ~arb_if.cb.penable_o) begin
            $display("ETNERED: Time %0t", $time);
            @(arb_if.cb);
            $display("ETNERED2: Time %0t", $time);
        end
        // if passed we are sampling the previous/right before the current edge
        assert(arb_if.cb.paddr_o == 32'hDEAD_CAFE)
        else $display("Failed test1_1: Exepected: %0h, Actual: %0d", 32'hDEAD_CAFE, arb_if.cb.paddr_o);
        $display("Time = %0t ns", $time);
        repeat (2) @(arb_if.cb);
        arb_if.cb.pready_i <= 1'b1;
        arb_if.cb.prdata_i <= 5;
        @(arb_if.cb);   // will sample previous
        arb_if.cb.pready_i <= 1'b0;
        arb_if.cb.cmd_i <= 2'b10;
        repeat(2) @(posedge arb_if.cb);
        assert(arb_if.cb.pwdata_o == 6)
        else $display("Failed test1_2: Expected: %0h, Actual: %0d", 6, arb_if.cb.pwdata_o);
        
        
    endtask
    
    
    initial begin
        arb_if.reset <= 1'b1;
        repeat (3) @(arb_if.cb);    //
        arb_if.reset <= 1'b0;   // driven immediately, seen at next clock edges
        repeat (1) @(arb_if.cb);
        test1();
        $display("Finsihed all tests!");
    end



endprogram


//module APB_clk(output logic clk);
//    logic local_clk = 0;
//    assign clk = local_clk;
//    always #5 local_clk = ~local_clk;
//endmodule


module APB_day16_top;
    // declare the interfaces
    logic clk = 0;
    always #5 clk = ~clk;
    
    //APB_clk clk_gen(.*);
    APB_if intf1(clk);
    //if using interface must always provide
    APB_master_intf DUT1 (.clk, .reset(intf1.reset), .cmd_i(intf1.cmd_i),
                    .psel_o(intf1.psel_o),
                    .penable_o(intf1.penable_o),  // indicates beginning of access phase
                    .paddr_o(intf1.paddr_o),    // address that carries adress from master to the slave
                    .pwrite_o(intf1.pwrite_o),        // 0 = read,  1 = write
                    .pwdata_o(intf1.pwdata_o),                      // write data bus that carries data from the master to the slave
                    .pready_i(intf1.pready_i),                              // used by slave to request wait states if it cannot complete transfer
                    .prdata_i(intf1.prdata_i));                                                     // read data that carries data frmo the slave to the master
                    
    APB_prog prog1(intf1);            
//    initial begin
//    $recordvars(0, intf1); // recursively records all signals in the interface
//    end
//always @(intf1.cb2) begin
//    $display("cb2 posedge at time %0t", $time);
//end
//always @(posedge intf1.clk) begin
//    $display("clk posedge at time %0t", $time);
//end


endmodule


