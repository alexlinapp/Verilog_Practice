
typedef enum logic [1:0] {IDLE=2'b00, NONSEQ = 2'b10} TRANSTYPE_;
interface AHB_if(input bit HCLK);
    logic [20:0] HADDR;
    logic HWRITE;
    TRANSTYPE_ HTRANS;
    logic [7:0] HWDATA;
    logic [7:0] HRDATA;
    clocking cb @(negedge HCLK)
        assert (HTRANS === IDLE || HTANS == NONSEQ)
        else $error("ERROR. HTRANS INVALID VALUE.");
    endclocking

    modport MASTER (input HRDATA, output HADDR, HWRITE, HTRANS, HWDATA);
 
    modport SLAVE (input HADDR, HWRITE, HTANS, HWDATA, output HRDATA);

endinterface //AHB_if