`include "uvm_macros.svh"
package sequencer;
    import uvm_pkg::*;
    import sequence_item::*;

    class dataSequencer extends uvm_sequencer#(sequence_item::dataInput);
        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction //new()
    endclass //dataSequencer extends uvm_sequencer#(sequence_item::dataInput)
endpackage