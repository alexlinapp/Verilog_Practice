`timescale 1ns/1ns

// The external (to the FPGA) serial_rx signal must be synchronized to the
// FPGA clock domain to constrain meta-stability.
// TODO: implement a synchronizer in synthesizable verilog
// it should have 2 clock cycles of latency
// (does not need vendor specific attributes or primitives for this example)
module synchronizer(
    input wire clk,
    input wire in,
    output wire out_sync
);
    reg d2, q2;
    assign out_sync = q2;
    always @(posedge clk) begin
        d2 <= in;
        q2 <= d2;
    end


endmodule

module uart_rx (
    input  wire        clk,       // 100Mhz clk input
    input  wire        rst,       // active-high
    input  wire        serial_rx, // external serial input "8N1" at 10Mbaud (10 million baud)
    output wire  [7:0] data,      // output byte
    output wire        valid      // single clk cycle pulse when data is valid
);
    localparam CLK_RATE  = 100_000_000;
    localparam BAUD_RATE = 10_000_000;


    // TODO: instantiate synchronizer with output to rx_sync wire
    // Synchronizer
    wire rx_sync;
    synchronizer sync_inst (
        .clk      (clk),
        .in       (serial_rx),
        .out_sync (rx_sync)
    );

    // TODO: instantiate this partially connected baud clk
    // it should be configured for 10MHz with output to 'tick' signal
    // can select either baud_clk_pa or baud_clk_ctr version or make one
    // 10MHz Baud clock
    wire tick;
    baud_clk #(
       .CLK_RATE (CLK_RATE), .OUTPUT_RATE(BAUD_RATE), .CTR_INIT(4)
    ) baud_clk_inst (
       .clk  (clk),
       .rst  (rst || edge_detect),
       .tick (tick)
    );

    // TODO: implement rx byte in synthesizable system verilog
    reg [7:0] shift_reg;
    localparam IDLE = 0;
    localparam REC_1 = 1;
    localparam REC_2 = 2;
    localparam REC_3 = 3;
    localparam REC_4 = 4;
    localparam REC_5 = 5;
    localparam REC_6 = 6;
    localparam REC_7 = 7;
    localparam REC_8 = 8;
    localparam STOP = 9;
    
    reg [3:0] c_state, n_state;
    
    always @(*) begin
        n_state = c_state;
        case (c_state)
            IDLE: begin
                if (rx_sync == 1'b0)
                    n_state = REC_1;
            end
            REC_1: n_state = REC_2;
            REC_2: n_state = REC_3;
            REC_3: n_state = REC_4;
            REC_4: n_state = REC_5;
            REC_5: n_state = REC_6;
            REC_6: n_state = REC_7;
            REC_7: n_state = REC_8;
            REC_8: n_state = STOP;
            STOP: n_state = IDLE;
            default: n_state = 'x;
        endcase
    end
    
    
    reg trig_valid;
    always @(posedge clk) begin
        if (rst)
            trig_valid <= 0;
        else if ((c_state == REC_8) && tick)
            trig_valid <= 1;
        else
            trig_valid <= 0;
    end
    // Byte Receive logic
    // ...
    always @(posedge clk) begin
        if (rst) begin
            c_state <= IDLE;
        end
        else if (tick) begin
            c_state <= n_state;  
        end
    end
    
    always @(posedge clk) begin
        if (rst) begin
            shift_reg <= 0;
        end
        else if (tick)
            shift_reg <= {rx_sync, shift_reg[7:1]};
    end
    

    // Output assignments
    assign data = shift_reg;
    assign valid = trig_valid;
    // Can add debug here:
    initial begin
        #1;
//        $display("time,rst,serial_rx,rx_sync,tick,<sig>");
//        $monitor("%4t: %2d %9d %7d %4d %4d %5d %x", $time, rst, serial_rx, rx_sync, rx_edge, tick, state, shift);
    end
    
    
    reg p_edge;
    wire edge_detect;
    always @(posedge clk)
        if (rst)
            p_edge <= 0;
        else
            p_edge <= rx_sync;
    
    assign edge_detect = (p_edge != rx_sync);
    
    
endmodule


// this building block may be used as is or modified or ignored
// this uses a counter-based approach to generating a baud-clock
module baud_clk #(
    parameter CLK_RATE       = 100, // MHz
    parameter OUTPUT_RATE    = 20,   // MHz
    parameter [3:0] CTR_INIT = 0
) (
    input  wire clk,
    input  wire rst,
    output wire tick
);
  reg [3:0] counter = CTR_INIT;

  assign tick = (counter == (CLK_RATE/OUTPUT_RATE)-1);

  always @(posedge clk) begin
    if (rst) begin
      counter <= CTR_INIT;
    end else if (tick) begin
      counter <= 0;
    end else begin
      counter <= counter + 1;
    end
  end
endmodule


// ---------------- Simple testbench ----------------
// do not modify below this point
module tb;
    // 100 MHz clock -> period 10 ns
    // positive clock edges occur on even multiples of 10ns (time=10, 20, 30, etc.)
    reg clk = 0;
    always begin
        #5 clk = 0;
        #5 clk = 1;
    end

    reg  rst = 1;
    reg  rx  = 1;

    wire [7:0] data;
    wire       valid;

    uart_rx uut (
        .clk       (clk),
        .rst       (rst),
        .serial_rx (rx),
        .data      (data),
        .valid     (valid)
    );

    task send_byte;
      input [7:0] b;
      input integer delay;
      integer i;
      begin
        rx = 1'b0;
        #delay;
        for (i = 0; i < 8; i = i + 1) begin
          rx = b[i];
          #delay;
        end
        rx = 1'b1;
        #delay;
      end
    endtask

    reg [7:0]data_capture;
    reg valid2 = 0;
    reg valid3 = 0;
    always @(posedge clk) begin
        valid2 <= valid;
        valid3 <= valid2;

        if (valid && valid2 && !valid3)
            $display("ASSERT FAILED: valid true for more than one clock");
        // only capture on 1st valid
        if (valid && !valid2)
            data_capture <= data;
    end

    integer ret;
    reg [23:0]line;
    initial begin
        ret = $fgets(line, 32'h80000000);

        if (line == "TC0") begin
            // test synchronizer
            $display("Running Test Case #0");
            $display("time, rst, rx, rx_sync");
            $monitor("%4t: %3d  %2d  %7d", $time, rst, rx, uut.rx_sync);
            #43;
            rst = 0;
            #40;
            // stimulus
            rx = 0;
            #100;
            rx = 1;
            #100;
            $finish;
        end else if (line == "TC1") begin
            // test baud rate generator
            $display("Running Test Case #1");
            $display("time, rst, tick");
            $monitor("%4t: %3d  %4d", $time, rst, uut.tick);
            #63;
            //force uut.baud_clk_inst.counter = 5;
            rst = 0;
            #50;
            //release uut.baud_clk_inst.counter;
            #450;
            $finish;
        end else if (line == "TC2") begin
            // test byte rx
            $display("Running Test Case #2");
            //$display("time, rst, rx_sync, tick, valid");
            //$monitor("%4t: %3d  %7d  %4d  %5d", $time, rst, uut.rx_sync, uut.tick, valid);
            #73;
            rst = 0;
            #110;

            // stimulus
            send_byte(8'hEB, 100);

            #2000;

            $display("Data=%X", data_capture);
            if (data_capture == 'hEB)
                $display("SUCCESS!");
            $finish;
        end else if (line == "TC3") begin
            // test byte rx
            $display("Running Test Case #3");
            //$display("time, rst, rx_sync, tick, valid");
            //$monitor("%4t: %3d  %7d  %4d  %5d", $time, rst, uut.rx_sync, uut.tick, valid);
            #43;
            rst = 0;
            #190;

            // stimulus
            send_byte(8'hEB, 100);

            #2000;

            $display("Data=%X", data_capture);
            if (data_capture == 'hEB)
                $display("SUCCESS!");
            $finish;
        end else if (line == "TC4") begin
            // test byte rx
            $display("Running Test Case #4");
            //$display("time, rst, rx_sync, tick, valid");
            //$monitor("%4t: %3d  %7d  %4d  %5d", $time, rst, uut.rx_sync, uut.tick, valid);
            #43;
            rst = 0;
            #190;

            // stimulus
            send_byte(8'hEB, 120);

            #2000;

            $display("Data=%X", data_capture);
            if (data_capture == 'hEB)
                $display("SUCCESS!");
            $finish;
        end
        else
            $finish;
    end
endmodule