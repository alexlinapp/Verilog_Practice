`include "uvm_macros.svh"
package env_pkg;
    import agent_pkg::*;
    import monitor_pkg::*;
    import scoreboard_pkg::*;
    import uvm_pkg::*;
    //  container class
    class alu_env extends uvm_env;
        alu_agent agent;
        alu_scoreboard scoreboard;
        `uvm_component_utils(alu_env);
        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction //new()

        //  build phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            agent = alu_agent::type_id::create("agent", this);
            scoreboard = alu_scoreboard::type_id::create("scoreboard", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            //super.build_phase(phase);
            agent.monitor.item_collected_port.connect(scoreboard.item_collected_export);
        endfunction
    endclass //alu_env extends uvm_env
endpackage