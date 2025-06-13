`include "uvm_macros.svh"
package env_pkg;
    import agent_pkg::*;
    import uvm_pkg::*;
    //  container class
    class alu_env extends uvm_env;
        alu_agent agent;
        
        `uvm_component_utils(alu_env);
        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction //new()

        //  build phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            agent = alu_agent::type_id::create("agent", this);
            
        endfunction
    endclass //alu_env extends uvm_env
endpackage