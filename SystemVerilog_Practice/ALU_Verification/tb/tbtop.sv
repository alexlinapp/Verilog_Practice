module tbtop;
    import uvm_pkg::*;
    import test_pkg::*;
    bit clk;
    bit reset;

    initial begin
        clk = 0;
    end
        
    always begin
        #5;
        clk = ~clk;
    end

    alu_if inf(clk);

    //DUT Instance
    alu DUT (
        .a(inf.a), .b(inf.b), .ALUControl(inf.ALUControl), 
        .ALUResult(inf.ALUResult), .Zero(inf.Zero), .LessThan(inf.LessThan), 
        .LessThanUnsigned(inf.LessThanUnsigned)
    );

    initial begin
        $monitor("clk = %0d", clk);
    end
    initial begin
        $display("====Starting Test====");
        uvm_config_db#(virtual alu_if)::set(uvm_root::get(), "*", "alu_inf", inf);
        run_test("alu_test");
    end


endmodule