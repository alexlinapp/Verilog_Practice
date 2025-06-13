`include "uvm_macros.svh"
package trans_pkg;

    import uvm_pkg::*;
    class mon_score_trans extends uvm_transaction;
        int a, b, ALUResult;
        int ALUControl;
        bit Zero, LessThan, LessThanUnsigned;
        //`uvm_object_utils(mon_score)
        `uvm_object_utils_begin(mon_score_trans)
            `uvm_field_int(a,  UVM_DEFAULT)
            `uvm_field_int(b,  UVM_DEFAULT)
            `uvm_field_int(ALUControl, UVM_DEFAULT)
            `uvm_field_int(Zero,  UVM_DEFAULT)
            `uvm_field_int(LessThan, UVM_DEFAULT)
            `uvm_field_int(LessThanUnsigned, UVM_DEFAULT)
        `uvm_object_utils_end
        function new(string name = "mon_score_trans");
            super.new(name);
        endfunction //new()
    endclass //mon_score_trans extends superClass
endpackage