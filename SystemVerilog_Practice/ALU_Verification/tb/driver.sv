`include "uvm_macros.svh"
package driver_pkg;
    import uvm_pkg::*;
    import sequence_item_pkg::*;

    `define DRIV_IF vif.driver_cb
    class dataDriver extends uvm_driver #(sequence_item_pkg::dataInput);
        sequence_item_pkg::dataInput req;
        virtual alu_if vif;

        `uvm_component_utils(dataDriver);

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction //n
        
        virtual function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            if (!uvm_config_db#(virtual alu_if)::get(this, "", "alu_inf", vif))
                $display("DRIVER FAILED");
        endfunction
        virtual task automatic run_phase(uvm_phase phase);
            super.run_phase(phase);
            //$display("AM I EVEN HERE?");
            forever begin
                seq_item_port.get_next_item(req);   //  protected seq_item_port that lives inside the uvm_driver class
                //$display("IM HERE!");
                drive();
                //$display("IM HERE!");
                seq_item_port.item_done();
            end
            

        endtask //automatic

        //  user defined function
        virtual task automatic drive();
            $display("Values being driven: %0d, %0d, %0d", req.a, req.b, req.ALUControl);
            //$display("Finished dasdasdasdriving values: ");
            @`DRIV_IF;
            vif.driver_cb.a <= req.a;
            `DRIV_IF.b <= req.b;
            `DRIV_IF.ALUControl <= req.ALUControl;
            //$display("Finished driving values: ");
        endtask //automatic
    endclass //dataDriver extends uvm_driver #(sequence_item_pkg::dataInput)
endpackage