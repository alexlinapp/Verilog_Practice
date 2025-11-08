module SYNC_FIFO_1 #(
    parameter DEPTH = 4,
    parameter DATA_W = 1
)(
    input       logic clk, reset,
    input       logic push_i,
    input       logic [DATA_W-1:0] push_data_i,
    
    input       logic               pop_i,
    output      logic [DATA_W-1:0]  pop_data_o,
    
    output      logic               full_o, empty_o
);
    logic [DATA_W-1:0] buffer [DEPTH];  // actual FIFO
    logic FIFO_full, FIFO_full_next, FIFO_empty, FIFO_empty_next;
    
    logic [$clog2(DEPTH)-1:0] head_c, tail_c, head_n, tail_n;
    logic wren;
    // signals
    always_ff @(posedge clk) begin
        if (reset) begin
            FIFO_full <= '0;
            FIFO_empty <= 1'b1;
            tail_c <= '0;
            head_c <= '0;
        end
        else begin
            FIFO_full <= FIFO_full_next;
            FIFO_empty <= FIFO_empty_next;
            tail_c <= tail_n;
            head_c <= head_n;
        end
    end
    
    assign empty_o = FIFO_empty;
    assign full_o = FIFO_full;
    assign pop_data_o = buffer[tail_c];
    assign wren = push_i & ~FIFO_full;
    always_ff @(posedge clk) begin
        if (reset) begin
            for (int i = 0; i < DEPTH; i++) begin
                buffer[i] <= '0;
            end
        end
        else if (wren)
            buffer[head_c] <= push_data_i;    
    end
    
    
    always_comb begin
        head_n = head_c;
        tail_n = tail_c;
        FIFO_full_next = FIFO_full;
        FIFO_empty_next = FIFO_empty;
        case ({push_i, pop_i})
            2'b10: begin
                if (~FIFO_full) begin
                     if (head_c == DEPTH-1) begin
                            head_n = '0;
                     end
                     else
                        head_n = head_c + 1;
                     FIFO_empty_next = 1'b0;
                     if (head_n == tail_c)
                        FIFO_full_next = 1'b1;
                end
            end
            2'b01: begin
                if (~FIFO_empty) begin
                    if (tail_c == DEPTH-1) begin
                        tail_n = '0;
                    end
                    else
                        tail_n = tail_c + 1;
                    FIFO_full_next = 1'b0;
                    if (tail_n == head_c)
                        FIFO_empty_next = 1'b1;
                end
            end
            2'b11: begin
                if (head_c == DEPTH-1) begin
                            head_n = '0;
                     end
                 else
                        head_n = head_c + 1;
                if (tail_c == DEPTH-1) begin
                        tail_c = '0;
                end
                else
                        tail_n = tail_c + 1;
            end
        endcase
        
    
    
    end

endmodule

/*
modports are safer and clearer and allows compile to catch misuse
*/
interface FIFO_intf1#(parameter DEPTH, parameter DATA_W)(input logic clk);
    logic reset;
    logic push_i, pop_i;
    logic [DATA_W-1:0] push_data_i, pop_data_o;
    logic full_o, empty_o;
    
    clocking cb @(posedge clk);  //  output is testbench->DUT
        input pop_data_o, full_o, empty_o;
        output push_i, pop_i, push_data_i;
    endclocking
    
    modport DUT (input clk, reset,push_i,push_data_i,pop_i,output pop_data_o,full_o, empty_o);
    
    modport PROG (clocking cb, output reset);

endinterface

program automatic prog1#(parameter DEPTH = 4, parameter DATA_W=1)(FIFO_intf1.PROG fifo_if);
    logic temp2;
    task automatic test1;
        int N = 10;
        logic [DATA_W-1:0] q[$];
        int size = 0;
        //int temp2 = 0;
        for (int i = 0; i < N; i++) begin
            int temp1 = $urandom_range(0, DEPTH);
            for (int j = 0; j < temp1 && size < DEPTH; j++) begin
                temp2 = $urandom_range(0, 1 << (DATA_W - 1));
                @(fifo_if.cb);  // we sample the previous front
                fifo_if.cb.push_i <= 1'b1;
                fifo_if.cb.push_data_i <= temp2;
                fifo_if.cb.pop_i <= 1'b0;
                if (q.size() == 0)
                    assert(fifo_if.cb.empty_o == 1)
                    else $display("Time: %t, Supposed to be empty but empty_o: %0b", $time, fifo_if.cb.empty_o);
                else
                    assert(q[0] == fifo_if.cb.pop_data_o)
                    else $display("Time: %t, Incorrect Viewing when pushing data: Expected: %0d, Actual: %0d", $time, q[0], fifo_if.cb.pop_data_o);
                q.push_back(temp2);
                size++;
            end
            @(fifo_if.cb);   // let the new pushed value update.
            
            // start popping
            //temp2 = $urandom_range(0, DEPTH);
            for (int j = 0; j < temp1 && size > 0; j++) begin
                fifo_if.cb.push_i <= 1'b0;
                //fifo_if.push_data_i <= temp2;
                fifo_if.cb.pop_i <= 1'b1;
                int temp3 = q.pop_front();
                @(fifo_if.cb);
                if (q.size() == 0)
                    assert(fifo_if.cb.empty_o)
                    else $display("Time: %t, Popping: Supposed to be empty but empty_o: %0b", $time, fifo_if.cb.empty_o);
                else
                    assert(q[0] == fifo_if.cb.pop_data_o)
                    else $display("Time: %t, Incorrect Viewing when POPPING data: Expected: %0d, Actual: %0d", $time, q[0], fifo_if.cb.pop_data_o);
                q.pop_front();
                size--;
            end
            
        end
    endtask
    
    task automatic test2;
        @(fifo_if.cb);
        fifo_if.cb.pop_i <= 1'b0;
        fifo_if.cb.push_i <= 1'b1;
        fifo_if.cb.push_data_i <= 1'b1;
        @(fifo_if.cb);
        fifo_if.cb.push_i <= 1'b1;
        fifo_if.cb.push_data_i <= 1'b0;
        @(fifo_if.cb);
        fifo_if.cb.push_i <= 1'b1;
        fifo_if.cb.push_data_i <= 1'b0;
        @(fifo_if.cb);
        fifo_if.cb.push_i <= 1'b1;
        fifo_if.cb.push_data_i <= 1'b1;
        @(fifo_if.cb);
        fifo_if.cb.push_i <= 1'b0;
        fifo_if.cb.pop_i <= 1'b1;
        repeat (4) @(fifo_if.cb);
    
    endtask
    initial begin
        fifo_if.reset <= 1'b1;
        fifo_if.cb.push_i <= 1'b0;
        fifo_if.cb.pop_i <= 1'b0;
        repeat(3) @(fifo_if.cb);
        fifo_if.reset <= 1'b0;
        test1;
        //test2;
        $display("Finished Test1!");
    end
endprogram
//



module FIFO_TOP;
    localparam DEPTH = 4;       //inferred logic type I believe
    localparam DATA_W = 1;
    logic clk = 0;
    always #5 clk = ~clk;
    FIFO_intf1 #(DEPTH, DATA_W) fifo_if(clk);
    SYNC_FIFO_1#(DEPTH, DATA_W) DUT(.clk, .reset(fifo_if.reset),
                                    .push_i(fifo_if.push_i),
                                    .push_data_i(fifo_if.push_data_i),
                                    .pop_i(fifo_if.pop_i),
                                    .pop_data_o(fifo_if.pop_data_o),
                                    .full_o(fifo_if.full_o),
                                    .empty_o(fifo_if.empty_o)
                                );
    prog1#(DEPTH, DATA_W) prog(fifo_if);
endmodule






