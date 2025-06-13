`include "uvm_macros.svh"
package test_pkg;
    import seq_pkg::*;
    import env_pkg::*;
    import uvm_pkg::*;
    class alu_test extends uvm_test;
        dataSequence seq;
        alu_env env;

        //  always needed for UVM factory, i.e. typeid() and run_test()
        `uvm_component_utils(alu_test);
        function new(string name, uvm_component parent = null);
            super.new(name, parent);
        endfunction //new()

        virtual function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            
            env = alu_env::type_id::create("env", this);
            seq = dataSequence::type_id::create("seq");
            
        endfunction

        virtual task automatic run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);
            $display("SO IM RUNNINGNGNGNi?");
            seq.start(env.agent.sequencer);
            //$display("IN MY RUN PHASE!");
            phase.drop_objection(this);
        endtask //automatic
    endclass //alu_test
endpackage