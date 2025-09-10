// Synchronous FIFO
// Default to depth 4 FIFO with WIDTH of 4 bits
module FIFO #(parameter B = 4,
                        W = 2)
(
        input   logic               clk, reset,
        input   logic               rd, wr,
        input   logic [B-1:0]       w_data,
        output  logic               empty, full,
        output  logic [B-1:0]       r_data
    );
    
    logic [B-1:0] array_reg [1 << W]; 
    logic [W-1:0] w_ptr, r_ptr, w_next_ptr, r_next_ptr;
    logic         array_empty, array_empty_next, array_full, array_full_next;
    logic         wr_en;
    
    
    
    assign wr_en = wr & (~array_full | rd);
    
    
    //  outputs
    assign r_data = array_reg[r_ptr];
    assign full = array_full;
    assign empty = array_empty;
    
    
    always_ff @(posedge clk, posedge reset) begin
        if (reset) begin
            w_ptr <= '0;
            r_ptr <= '0;
            array_empty <= 1'b1;
            array_full <= 1'b0;
        end
        else begin
            w_ptr <= w_next_ptr;
            r_ptr <= r_next_ptr;
            array_empty <= array_empty_next;
            array_full <= array_full_next;
        end
    
    end
    always_ff @(posedge clk, posedge reset) begin
        if (reset) begin
            for (int i = 0; i < (1 << W); i++) begin
                array_reg[i] <= '0;   //    reset FIFO 
            end
        end
        else if (wr_en) begin
            array_reg[w_ptr] <= w_data;
        end
    end
    
    always_comb begin
        array_empty_next = array_empty;
        array_full_next = array_full;
        w_next_ptr = w_ptr;
        r_next_ptr = r_ptr;
        
        case ({wr, rd})
            2'b01: begin
                if (~array_empty) begin
                    r_next_ptr = r_ptr + 1;
                    array_full_next = 1'b0;
                    if (w_ptr == r_next_ptr) array_empty_next = 1'b1;
                end
            end
            2'b10:  begin
            if (~array_full) begin
                    w_next_ptr = w_ptr + 1;
                    array_empty_next = 1'b0;
                    if (w_next_ptr == r_ptr) begin
                        array_full_next = 1'b1; 
                    end
                end
            end
            2'b11: begin
            if (~empty) r_next_ptr = r_ptr + 1; //cannot read empty FIFO
            w_next_ptr = w_ptr + 1;             //  allow for FULL FIFO to add and remove at same time
                
            end
        endcase
   end
endmodule
