`include "uvm_macros.svh"
package driver;
    import uvm_pkg::*;
    import sequence_item::*;

    class dataDriver extends uvm_driver #(sequence_item::dataInput);
        
        `uvm_component_utils(sequence_item::dataInput);
        function new(string name, uvm_component, parent);
            super.new(name, parent);
        endfunction //n
        
        
    endclass //dataDriver extends uvm_driver #(sequence_item::dataInput)
endpackage