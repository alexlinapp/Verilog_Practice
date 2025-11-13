module FIFO_async #(parameter D = 16, DW = 4)    // assume DEPTH IS power of 2. Easier to implement pointer logic. Otherwise harder
(
        input   logic                       w_clk, w_rst,
        input   logic [DW-1:0]      w_data,
        input   logic                       w_req,
        input   logic                       r_clk, r_rst,
        input   logic                       r_req,
        output  logic [DW-1:0]      r_data,
        output  logic                       full_o, empty_o
);

// We do not explicitly reset the RAM in async FIFO since CDC. usually will use external RAM as well
logic [DW-1:0] mem [D];     // memory

logic[$clog2(D):0] w_ptr;           // use an extra bit to perform modulo for pointers

logic[$clog2(D):0] r_ptr; 

assign r_data = mem[r_ptr[$clog2(D)-1:0]];  // will need to replace eventually
always_ff @(posedge w_clk) begin
    if (w_req && !full_o)
        mem[w_ptr[$clog2(D)-1:0]] <= w_data;
end

// note that prefix with w means write domain, prefix with "r" means read domain. i.e. wq2_r_ptr_gray means write domain r_ptr_gray
/*
    Main issue is crossing clock domains when checking if FIFO is full or not. 
    
    Also need to convert to graycode to prevent invalid access of values (since only one bit will be changing
    in the actual increment)
*/
// graycodes
logic [$clog2(D):0] r_ptr_gray, w_ptr_gray;
assign w_ptr_gray = w_ptr ^ (w_ptr >> 1);           // proof idea: find smallest index of 0, and then go from there
assign r_ptr_gray = r_ptr ^ (r_ptr >> 1);

logic [$clog2(D):0] wq2_r_ptr_gray, wq1_r_ptr_gray;
logic [$clog2(D):0] rq2_w_ptr_gray, rq1_w_ptr_gray;


// crossing clock domains. We use a 2 stage synchronizer
always @(posedge w_clk) begin
    if (w_rst)
        {wq2_r_ptr_gray, wq1_r_ptr_gray} <= '0;
    else
        {wq2_r_ptr_gray, wq1_r_ptr_gray} <= {wq1_r_ptr_gray, r_ptr_gray};
end

// sending write pointer to r_clk domain
always @(posedge r_clk) begin
    if (r_rst)
        {rq2_w_ptr_gray, rq1_w_ptr_gray} <= '0;
    else
        {rq2_w_ptr_gray, rq1_w_ptr_gray} <= {rq1_w_ptr_gray, w_ptr_gray};
end

// to check if empty logic
assign empty_o = rq2_w_ptr_gray == r_ptr_gray;      // gray code preserves equality
// check for full: a bit more complicated. But proof is take original check (module wrap around/MSB) apply gray code and see
assign full_o = (w_ptr_gray[$clog2(D):$clog2(D)-1] == ~wq2_r_ptr_gray[$clog2(D):$clog2(D)-1]) && (w_ptr_gray[$clog2(D)-2:0] == wq2_r_ptr_gray[$clog2(D)-2:0]);


// similar to sync 
always_ff @(posedge w_clk) begin
    if (w_rst)
        w_ptr <= '0;
    else if(w_req && (!full_o))
        w_ptr <= w_ptr + 1;              // bit sloppy here (not separating combinaitonal) but okay  
end

always_ff @(posedge r_clk) begin
    if (r_rst)
        r_ptr <= '0;
    else if (r_req && (!empty_o))
        r_ptr <= r_ptr + 1;

end

endmodule




module FIFO_async_tb;
    // basic test bench since running out of time
    localparam DW = 4;
    localparam D = 16;  //DEPTH = 16
    logic                       w_clk = 0;
    logic w_rst;
    logic [DW-1:0]      w_data;
        logic                       w_req;
        logic                       r_clk = 0;
        logic r_rst;
        logic                       r_req;
        logic [DW-1:0]      r_data;
        logic                       full_o, empty_o;
    
    FIFO_async#(.D(D), .DW(DW)) DUT(.*);
    
    always #5 w_clk = ~w_clk;
    always #10 r_clk = ~r_clk;  // read clock 2x slower
    
    
    initial begin
        w_rst <= 1'b1;
        r_rst <= 1'b1;
        w_req <= 1'b0;
        r_req <= 1'b0;
        repeat (2) @(posedge r_clk);
        w_rst <= 1'b0;
        r_rst <= 1'b0;
        w_req <= 1'b1;
        for (int i = 0; i < 1 << DW; i++) begin
            w_data <= i;
            @(posedge w_clk);
        end
        
        assert final(full_o == 1'b1)
        else $display("Time: %0t, Failed full_o: Exepcted: %0b, Actual: %0b", $time, 1'b1, full_o);
        
        w_data <= 7;
        r_req <= 1'b1;
        for (int i = 0; i < 1 << DW; i++) begin
            // since we are in a module, if we don't use final, possible race coniditon between DUT and TB. 
            // since posedge updates, then since r_data is combinational, then this schuedles to update instead of the other r_data
            // since its possible that we chekc r_data first. Since without final we use immediate assertion.
            // both #0 and final will work here
            assert #0(r_data == i)   // use final here to get it from postponed region....
            else $display("Time: %0t, Failed read: Exepcted: %0d, Actual: %0d", $time, i, r_data);
            @(posedge r_clk);
        end
        #100;
        $finish;
    
    end
    
endmodule

