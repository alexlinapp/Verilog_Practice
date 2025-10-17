module alu(
    input     logic [7:0]   a_i,
    input     logic [7:0]   b_i,
    input     logic [2:0]   op_i,

    output    logic [7:0]   alu_o
    );
    
    always_comb begin
        case (op_i)
            3'b000: alu_o = a_i + b_i ;
            3'b001:	alu_o = a_i - b_i;
            3'b010:	alu_o = a_i << b_i[2:0];
            3'b011:	alu_o = a_i >> b_i[2:0];
            3'b100:	alu_o = a_i & b_i;
            3'b101:	alu_o = a_i | b_i;
            3'b110:	alu_o = a_i ^ b_i;
            3'b111:	alu_o = (a_i == b_i) ? 8'b1 : 8'b0;
        endcase
    
    end
    
endmodule


module alu_TB;
    logic [7:0] a_i, b_i, alu_o;
    logic [2:0] op_i;
    
    alu DUT(.*);
    
    initial begin
        op_i <= 3'b001;
        a_i <= 8'd48;
        b_i <= 8'd24;
        #5;
        for (int i = 0; i < 3; i++) begin
            a_i = $urandom_range(0, 8'hFF);
            b_i = $urandom_range(0, 8'hFF);
            for (int j = 0; j < 8; j++) begin
                op_i = j;
                #5;
            end
        
        end
        $finish;
    
    end
    

endmodule
