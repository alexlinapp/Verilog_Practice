`include "uvm_macros.svh"
package agent_pkg;
    import uvm_pkg::*;
    import driver_pkg::*;
    import seq_pkg::*;
    import sequence_item_pkg::*;
    import sequencer_pkg::*;
    class alu_agent extends uvm_agent;
        dataDriver driver;
        dataSequencer sequencer;

        //  UVM Automation macros for general components
        `uvm_component_utils(alu_agent);


        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction //new()

        //  build_phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            driver = dataDriver::type_id::create("driver", this);
            sequencer = dataSequencer::type_id::create("sequencer", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            driver.seq_item_port.connect(sequencer.seq_item_export);
        endfunction
        //  connect_phase

    endclass //alu_agent
endpackage