/*
-Template for synchronous rom
-Constructed with FPGA's BRAM module
*/
module sync_rom
    (
        input   logic       clk,
        input   logic [3:0] addr,
        output  logic [6:0] data
    );
    
    //  signal declarations
    logic [6:0] rom [0:15];  // ascending range
    logic [6:0] data_reg;
    
    //load initial values from file "test.txt"
    
    initial
        $readmemb("test.txt", rom);
    //  body
    always_ff @(posedge clk)
        data_reg <= rom[addr];
    assign data = data_reg
endmodule
