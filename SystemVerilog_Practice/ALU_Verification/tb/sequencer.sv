`include "uvm_macros.svh"
package sequencer_pkg;
    import uvm_pkg::*;
    import sequence_item_pkg::*;


    class dataSequencer extends uvm_sequencer#(sequence_item_pkg::dataInput);

        `uvm_component_utils(dataSequencer);
        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction //new()
    endclass //dataSequencer extends uvm_sequencer#(sequence_item::dataInput)
endpackage