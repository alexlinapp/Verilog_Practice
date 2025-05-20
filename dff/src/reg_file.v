module reg_file
    #(
        parameter   B = 8, //  bits in each word
                    W = 2   // number of address bits
    
    )
    (
        input wire clk, 
        input wire wr_en,
        input wire[W-1:0] w_addr, r_addr,
        input wire [B-1:0] w_data,
        output wire [B-1:0] r_data
    );
    
    //  signal declaration
    //  note 2D array of [2**W - 1:0] elements and each element is data type
    //  reg[B-1:0]
    reg [B-1:0] array_reg [2**W - 1:0];
    
    //  write operation
    always @(posedge clk)
        if (wr_en)
            array_reg[w_addr] = w_data;
    
    //  read operation
    assign r_data = array_reg[r_addr];
endmodule
