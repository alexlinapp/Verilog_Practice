/*
Asynchronous for now
-Byte offset of 2 since it is word aligned, can only access whole word

*/
module directcache
    #(parameter DATA_WIDTH = 32,     //  number of bits per word, byte addresable by default
                ADDR_WIDTH = 32,    //  number of address bits
                C = 3               // cache capacity, in bits, default can store 8 words
    )
    (
        input   logic                   clk, reset,
        input   logic                   we,
        input   logic [ADDR_WIDTH-1:0]  addr,
        input   logic [DATA_WIDTH-1:0]  din,
        output  logic [DATA_WIDTH-1:0]  dout  
    );
    logic [DATA_WIDTH+ADDR_WIDTH-C-2:0]  cache [2**C-1:0];   //  V:Tag:Data, 1:C:DATA_WIDTH
    
    initial
        $readmemb("C:/Users/NODDL/Verilog_Practice/SystemVerilog_Practice/RAM_templates/testfiles/test1.txt", cache);
        
    always_ff @(posedge clk)
        begin
            if (we)
                cache[addr[C+1:2]] <= {1'b1, addr[ADDR_WIDTH-1:2], din};
        end
    assign dout = cache[addr][DATA_WIDTH-1:0];
endmodule
