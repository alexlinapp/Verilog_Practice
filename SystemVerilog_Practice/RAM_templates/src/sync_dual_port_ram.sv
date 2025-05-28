/*
-Two ports for memory access
-Each port can conduct read or write operation independently
-Each has its own set of addresses, data input and ouputt and control signals
-Both read and write a synchronous

*/
module sync_dual_port_ram
    #(
        parameter   DATA_WIDTH = 8,     //  number of bits per word
                    ADDR_WIDTH = 10      //  number of address bits      
    )
    (
        input   logic                   clk,
        input   logic                   we_a, we_b,
        input   logic [ADDR_WIDTH-1:0]  addr_a, addr_b,
        input   logic [DATA_WIDTH-1:0]  din_a, din_b,
        output  logic [DATA_WIDTH-1:0]  dout_a, dout_b
    );
    
    //  signal declaration
    logic [DATA_WIDTH-1:0]  ram [0:2**ADDR_WIDTH-1];
    logic [DATA_WIDTH-1:0]  data_a_reg, data_b_reg;
    
    //  body
    //  port a
    always_ff @(posedge clk)
        begin
            //  write operation
            if (we_a)
                ram[addr_a] <= din_a;
            //  read operation
            data_a_reg <= ram[addr_a];
        end
    
    //  port b
    always_ff @(posedge clk)
        begin
            //  write operation
            if (we_b)
                ram[addr_b] <= din_b;
            //  read operation
            data_b_reg <= ram[addr_b];
        end
    
    assign dout_a = data_a_reg;
    assign dout_b = data_b_reg;
endmodule
