module priority_arbriter#(
    parameter NUM_PORTS = 4
    )
(
        input       wire[NUM_PORTS-1:0] req_i,
        output      wire[NUM_PORTS-1:0] gnt_o   // One-hot grant signal
    );
    
    logic [NUM_PORTS-1:0] out;
    assign gnt_o = out;
    
    always_comb begin
        // find highest bit in vector
        out = 1'b0;
        for (int i = 0; i < NUM_PORTS; i++) begin
            if (req_i[i]) begin
                out = (1 << i);
            end
        end 
    end
endmodule


module priority_arbitrer_TB;
    localparam int NUM_PORTS = 8;
    logic [NUM_PORTS-1:0] req_i;
    logic [NUM_PORTS-1:0] gnt_o;
    
    priority_arbriter #(.NUM_PORTS(NUM_PORTS)) DUT(.*);
    
    int num;
    initial begin
        for (int i = 0; i < 32; i++) begin
            req_i = $urandom_range(0, (1 << NUM_PORTS) - 1);
            #1;
        end
        $finish;
        
    end

endmodule





module priority_arbriter2#(
    parameter NUM_PORTS = 4
    )
(
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



module priority_arbriter_top(
    input       wire[8-1:0] req_i,
        output      wire[8-1:0] gnt_o   // One-hot grant signal
);
    //priority_arbriter #(.NUM_PORTS(8)) DUT(.*);
    
    priority_arbriter2 #(.NUM_PORTS(8)) DUT2(.*);

endmodule





