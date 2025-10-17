/*

Capture edge on each clock pulse. Synchronous design

Not asynchronous since could cause metastability

*/


module edge_detect
(
    input     wire    clk,
    input     wire    reset,

    input     wire    a_i,

    output    wire    rising_edge_o,
    output    wire    falling_edge_o
);

typedef enum logic [2:0] {start, low, high, low_high, high_low} state;

state curr_state, next_state;

logic rise_edge_o, fall_edge_o;

logic a_in;


// Need to assign since wire CANNOT be used in procedural blocks
assign rising_edge_o = rise_edge_o;
assign falling_edge_o = fall_edge_o;
assign a_in = a_i;

always_ff @(posedge clk, posedge reset) begin
    if (reset) begin
        curr_state <= start;
        rise_edge_o <= 1'b0;
        fall_edge_o <= '0;
    end
    else begin
        curr_state <= next_state;
    end
end

// state machine
always_comb begin
    next_state = curr_state;
    case (curr_state)
        start: begin
            if (a_in == 1'b0)
                next_state = low;
            else
                next_state = high;
        end
        
        low: begin
            if (a_in == 1'b1)
                next_state = low_high;
        end
        
        high: begin
            if (a_in == 1'b0)
                next_state = high_low;
        end
        
        low_high: begin
            if (a_in == 0)
                next_state = low;
            else
                next_state = high;
        end
        high_low: begin
            if (a_in == 0)
                next_state = low;
            else
                next_state = high;
        end
    
    endcase
end
    // outputs
    always_comb begin
        rise_edge_o = (curr_state == low_high);
        fall_edge_o = (curr_state == high_low);
    end
    
endmodule


module edge_detect_TB;
    logic clk, reset, a_i;
    logic rising_edge_o, falling_edge_o;
    
    edge_detect DUT(.*);
    
    initial begin
        clk = 0;
        reset = 0;
    end
    
    always begin
        clk = ~clk;
        #5;
    end
    
    initial begin
        reset = 1;
        @(negedge clk);
        @(negedge clk);
        reset = 0;
        a_i = 1'b1;
        @(negedge clk);
        @(negedge clk);
        a_i = 1'b0;
        @(negedge clk);
        a_i = 1'b1;
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        a_i = 1'b0;
        @(negedge clk);
        @(negedge clk);
        #10;
        $stop;
    
    end
    
endmodule



// alternative design
module day3 (
  input     wire    clk,
  input     wire    reset,

  input     wire    a_i,

  output    wire    rising_edge_o,
  output    wire    falling_edge_o
);

  logic a_ff;

  always_ff @(posedge clk or posedge reset)
    if (reset)
      a_ff <= 1'b0;
    else
      a_ff <= a_i;

  // Rising edge when delayed signal is 0 but current is 1
  assign rising_edge_o = ~a_ff & a_i;

  // Falling edge when delayed signal is 1 but current is 0
  assign falling_edge_o = a_ff & ~a_i;

endmodule

module day3_tb ();

  logic    clk;
  logic    reset;

  logic    a_i;

  logic    rising_edge_o;
  logic    falling_edge_o;

  day3 DAY3 (.*);

  // clk
  always begin
    clk = 1'b1;
    #5;
    clk = 1'b0;
    #5;
  end

  // Stimulus
  initial begin
    reset <= 1'b1;
    a_i <= 1'b1;
    @(posedge clk);
    reset <= 1'b0;
    @(posedge clk);
    for (int i=0; i<32; i++) begin
      a_i <= $random%2;
      @(posedge clk);
    end
    $finish();
  end

endmodule













