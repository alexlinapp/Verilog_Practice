`include "uvm_macros.svh"
package monitor_pkg;
    import uvm_pkg::*;
    import sequence_item_pkg::*;
    import trans_pkg::*;
    `define MON_IF vif.monitor_cb
    class alu_monitor extends uvm_monitor;
        virtual alu_if vif;
        trans_pkg::mon_score_trans t;
        uvm_analysis_port #(trans_pkg::mon_score_trans) item_collected_port;
        `uvm_component_utils(alu_monitor);
        function new(string name, uvm_component parent);
            super.new(name, parent);
            t = new();
            item_collected_port = new("item_collected_port", this);
        endfunction //new()

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            if (!uvm_config_db#(virtual alu_if)::get(this, "", "alu_inf", vif))
                $display("Failed to get virtual interface in alu_monitor!");            
        endfunction

        virtual task automatic run_phase(uvm_phase phase);
            forever begin
                collect();
                item_collected_port.write(t);
            end
            
        endtask //automatic

        virtual task automatic collect();
            @`MON_IF;
            $display("Values being sampled by monitor: a = %0d, b = %0d", t.a, t.b);
            t.a = vif.monitor_cb.a;
            t.b = vif.monitor_cb.b;
            t.ALUControl = vif.monitor_cb.ALUControl;
            t.ALUResult = vif.monitor_cb.ALUResult;
            t.Zero = `MON_IF.Zero;
            t.LessThan = `MON_IF.LessThan;
            t.LessThanUnsigned = `MON_IF.LessThanUnsigned;
        endtask //automatic
    endclass //alu_monitor extends uvm_monitor
endpackage