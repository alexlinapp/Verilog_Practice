`include "uvm_macros.svh"
package scoreboard_pkg;
    import uvm_pkg::*;
    import trans_pkg::*;
    class alu_scoreboard extends uvm_scoreboard;
        
        uvm_analysis_imp#(trans_pkg::mon_score_trans, alu_scoreboard) item_collected_export;
        
        `uvm_component_utils(alu_scoreboard);
        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction //new()
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            item_collected_export = new("item_collected_export", this);
        endfunction

        virtual function void write(trans_pkg::mon_score_trans t);
            int expectedResult;
            $display("Recieved DUT Output: a = %0d, b = %0d, ALUControl = %0d, ALUResult = %0d, Zero = %0b, LessThan = %0d, LessThanUnsigned = %0d",
                    t.a, t.b, t.ALUControl, t.ALUResult, t.Zero, t.LessThan, t.LessThanUnsigned);  
            case (t.ALUControl)
                4'b0000: expectedResult = t.a + t.b;
                4'b0001: expectedResult = t.a - t.b;
                4'b0010: expectedResult = t.a & t.b;
                4'b0011: expectedResult = t.a | t.b;
                4'b0100: expectedResult = t.a ^ t.b;
                4'b0101: expectedResult = t.a < t.b;
                4'b0110: expectedResult = t.a >> t.b[4:0];
                4'b0111: expectedResult = t.a >>> t.b;
                4'b1000: expectedResult = t.a << t.b;
                4'b1001: expectedResult = unsigned'(t.a) < unsigned'(t.b);
                default: $display("Error in ALUControl Generation");
            endcase
            assert(expectedResult == t.ALUResult)
            else $display("Failed Assertion, expected result = %0d", expectedResult);
        endfunction
    endclass //alu_scoreboard extends uvm_scoreboard
endpackage