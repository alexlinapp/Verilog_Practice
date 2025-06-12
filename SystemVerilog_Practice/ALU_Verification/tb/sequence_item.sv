`include "uvm_macros.svh"
package sequence_item;
    import uvm_pkg::*;
    class dataInput extends uvm_sequence_item;
        rand int a, b;
        `uvm_object_utils_begin(dataInput)
            `uvm_field_int(a, UVM_DEFAULT);
            `uvm_field_int(b, UVM_DEFAULT);
        `uvm_object_utils_end
        
        function new(string name = "dataInput");
            super.new(name);
        endfunction //new()
        
    endclass //dataInput extends uvm_sequence_item
endpackage
    