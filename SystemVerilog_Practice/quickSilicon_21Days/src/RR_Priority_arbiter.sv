/*
Resources: https://www.siliconcrafters.com/post/round-robin-arbiter




*/

module arbiter_helper(
    input   wire [3:0] req_i,
    output  wire [3:0] gnt_o    //  one hot grant signal
);
    // assume port[0] has highest priority
    assign gnt_o[0] = req_i[0];
    
    genvar i;
    for (i=1; i < 4; i++) begin
        assign gnt_o[i] = req_i[i] & ~(|gnt_o[i-1:0]);
    end

endmodule


module RR_Priority_arbiter(
        input   wire          clk,
        input   wire            reset,
        
        input   wire [3:0]      req_i,
        output  logic [3:0]     gnt_o 
    );
    
    // use mask to identify last grant
    logic [3:0] c_mask, n_mask;
    
    always_ff @(posedge clk, posedge reset) begin
        if (reset)
            c_mask <= 4'b1111;
        else
            c_mask <= n_mask;
    end
    
    always_comb begin
        n_mask = c_mask;
        case (gnt_o) inside
            4'b???1: n_mask = 4'b1110;
            4'b??10: n_mask = 4'b1100;
            4'b?100: n_mask = 4'b1000;
            4'b1000: n_mask = 4'b1111;
            default: n_mask = 'x;
        endcase
    end
    
    logic [3:0] mask_gnt, raw_gnt;
    
    logic [3:0] mask_req;
    assign mask_req = req_i & c_mask;
    
    arbiter_helper mask_arb(.req_i(mask_req), .gnt_o(mask_gnt));
    
    arbiter_helper raw_arb(.req_i(req_i), .gnt_o(raw_gnt));
    
    assign gnt_o = |mask_gnt ? mask_gnt : raw_gnt;  // no requests avaialble in the mask, then set to the raw
    
    
endmodule

module RR_arbiter_TB;
    logic clk, reset;
    logic [3:0] req_i;
    logic [3:0] gnt_o;
    
    RR_Priority_arbiter DUT(.*);
    
    always begin
        clk = 0;
        #5;
        clk = 1;
        #5;
    end
    
    initial begin
        reset <= 1;
        repeat(2) @(negedge clk);
        reset <= 0;
        req_i <= 4'b1000;
        @ (negedge clk);
        req_i <= 4'b1001;
        repeat (2) @(negedge clk);
        req_i <= 4'b1110;
        repeat (3) @(negedge clk);
        req_i <= 4'b1000;
        repeat (3) @(negedge clk);
        req_i <= 4'b0001;
        repeat (2) @(negedge clk);
        $finish;
    end
endmodule



module day15 (
  input     wire        clk,
  input     wire        reset,

  input     wire[3:0]   req_i,
  output    logic[3:0]  gnt_o
);

  // Use mask to identify the last grant
  logic [3:0] mask_q;
  logic [3:0] nxt_mask;

  always_ff @(posedge clk or posedge reset)
    if (reset)
      mask_q <= 4'hF;
    else
      mask_q <= nxt_mask;

  // Next mask based on the current grant
  always_comb begin
    nxt_mask = mask_q;
         if (gnt_o[0]) nxt_mask = 4'b1110;
    else if (gnt_o[1]) nxt_mask = 4'b1100;
    else if (gnt_o[2]) nxt_mask = 4'b1000;
    else if (gnt_o[3]) nxt_mask = 4'b0000;
  end

  // Generate the masked requests
  logic [3:0] mask_req;

  assign mask_req = req_i & mask_q;

  logic [3:0] mask_gnt;
  logic [3:0] raw_gnt;
  // Generate grants for req and masked req
  day14 #(4) maskedGnt (.req_i (mask_req), .gnt_o (mask_gnt));
  day14 #(4) rawGnt    (.req_i (req_i),    .gnt_o (raw_gnt));

  // Final grant based on mask req
  assign gnt_o = |mask_req ? mask_gnt : raw_gnt;

endmodule

module day14 #(
  parameter NUM_PORTS = 4
)(
    input       wire[NUM_PORTS-1:0] req_i,
    output      wire[NUM_PORTS-1:0] gnt_o   // One-hot grant signal
);
  // Port[0] has highest priority
  assign gnt_o[0] = req_i[0];

  genvar i;
  for (i=1; i<NUM_PORTS; i=i+1) begin
    assign gnt_o[i] = req_i[i] & ~(|gnt_o[i-1:0]);
  end

endmodule

module day15_tb ();

  logic         clk;
  logic         reset;

  logic [3:0]   req_i;
  logic [3:0]   gnt_o;

  // Instatiate the module
  day15 DAY15 (.*);

  // Clock
  always begin
    clk = 1'b1;
    #5;
    clk = 1'b0;
    #5;
  end

  // Stimulus
  initial begin
    reset <= 1'b1;
    req_i <= 4'h0;
    @(posedge clk);
    reset <= 1'b0;
    @(posedge clk);
    @(posedge clk);
    for (int i =0; i<32; i++) begin
      req_i <= $urandom_range(0, 4'hF);
      @(posedge clk);
    end
    $finish();
  end

endmodule
