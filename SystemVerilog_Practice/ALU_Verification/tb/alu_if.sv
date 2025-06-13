interface alu_if(input logic clk);
    logic [31:0] a, b, ALUResult;
    logic [3:0] ALUControl;
    logic Zero, LessThan, LessThanUnsigned;
    
    clocking driver_cb @(posedge clk);
        output a, b, ALUControl;
    endclocking
    
    clocking monitor_cb @(posedge clk);
        input a, b, ALUResult, ALUControl, Zero, LessThan, LessThanUnsigned;
    endclocking
    modport DUT (
    input a, b, ALUControl,
    output ALUResult, Zero, LessThan, LessThanUnsigned
    );

    modport DRIVER (
        clocking driver_cb
    );

    modport MONITOR (
        clocking monitor_cb
    );
endinterface //alu_if
