`timescale 1ns / 10ps
module dual_priority_encoder_tb;
    reg[11:0] a;
    wire[3:0] first, second;
    
    dual_priority_encoder dpe1 (.a(a), .first(first), .second(second));
    
    initial
    begin
    a = 12'b101010101010;
    #200;
    a = 12'b111010101010;
    #200;
    a = 12'b001110101010;
    #200;
    
    $stop;
    end
endmodule
