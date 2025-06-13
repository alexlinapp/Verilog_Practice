`include "uvm_macros.svh"
package sequence_item_pkg;
    import uvm_pkg::*;
    class dataInput extends uvm_sequence_item;
        rand int a, b;
        rand bit [3:0] ALUControl;
        constraint ALUControl_c {ALUControl inside {[0:9]};}
        `uvm_object_utils_begin(dataInput)
            `uvm_field_int(a, UVM_DEFAULT);
            `uvm_field_int(b, UVM_DEFAULT);
        `uvm_object_utils_end
        
        function new(string name = "dataInput");
            super.new(name);
        endfunction //new()

    endclass //dataInput extends uvm_sequence_item
endpackage
    