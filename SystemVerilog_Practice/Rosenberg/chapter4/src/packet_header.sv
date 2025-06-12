import uvm_pkg::*;
`include "uvm_macros.svh"
class packet_header extends uvm_object;
    rand bit [5:0] length;
    rand bit [1:0] addr;
    `uvm_object_utils_begin(packet_header)
        `uvm_field_int(length, UVM_DEFAULT);
        `uvm_field_int(addr, UVM_DEFAULT);
    `uvm_object_utils_end

    function new (string name = "packet_header");
        super.new(name);
    endfunction
endclass //packet_header extends uvm_object