/*
APB Bridge: Requestor (Master)
Periphereal Device: Completor (Slave)

APB interface is a BUS interface
    -Bus Interface: Hardware logic that connects a MODULE to a bus, handling all bus protocol signals
    timing and handshake logic
    - Literally a protocl translator, so bus side speaks high speed or low speed bus protocl, other side speaks APB
    Usually flow is like this: AXI<-> APB Bridge <-> APB Bus <-> Periphereal Device (that uses APB)
    
Sources: AMBA APB Protocol Specification - ARM architecture family
*/
// oriignal oslution has funcitonal bug. If cmd_i chnages during ACCEESS state SO does pwrite_o!
// master

module APB_master_day20(
    input   logic           clk, reset,
    input   logic [1:0]     cmd_i,
    
    output  logic           psel_o,
    output  logic           penable_o,
    output  logic [31:0]    paddr_o, pwdata_o,
    output  logic           pwrite_o,
    
    input   logic           pready_i,
    input   logic [31:0]    prdata_i

);
// idle, set, access state

typedef enum logic [1:0] {IDLE, SETUP, ACCESS} state;

state curr_s, next_s;

logic pwrite_next;

always_ff @(posedge clk) begin
    if (reset)
        pwrite_o <= '0;
    else
        pwrite_o <= pwrite_next;
end

always_comb begin
    pwrite_next = pwrite_o;
    case (curr_s)
        IDLE: begin
            pwrite_next = next_s == SETUP && cmd_i == 2'b10;
        end
        SETUP: begin
            pwrite_next = pwrite_o;
        end
        ACCESS: begin
            if (next_s != ACCESS) begin
                if (cmd_i == 2'b10)
                    pwrite_next = 1'b1;
                else
                    pwrite_next = 1'b0;
            end
        end
    
    endcase
    
    
end


logic [31:0] read_data;


always_ff @(posedge clk) begin
    if (reset) begin
        curr_s <= IDLE;
    end
    else begin
        curr_s <= next_s;
    end

end

// output logic
always_comb begin
    psel_o = (curr_s == SETUP) || (curr_s == ACCESS);
    penable_o = (curr_s == ACCESS);
    paddr_o = 32'hDEAD_CAFE;
    pwdata_o = read_data + 32'h1;
    //pwrite_o = cmd_i[1];        // can set write early on since we enable INCORRECT!
end


// next state logic
always_comb begin
    next_s = curr_s;
    
    case (curr_s)
        IDLE: begin // HOW we initiate transfer here depends on our other side of the itnerface!!!!!
            if (cmd_i == 2'b01 || cmd_i == 2'b11) begin
                next_s = SETUP;
            end
        end
        SETUP: next_s = ACCESS;
        ACCESS: if (pready_i)
                    if (cmd_i == 2'b01 || cmd_i == 2'b10)
                        next_s = SETUP;
                    else
                        next_s = IDLE;
                else
                    next_s = ACCESS;
        default: next_s = state'('x);   // cast 'x into enum
    endcase
end
always_ff @(posedge clk) begin
    if (reset)
        read_data <= '0;
    else if (curr_s == ACCESS && pready_i)
        read_data = prdata_i;
end

endmodule


interface APB_intf(input clk);
    logic   reset;
    logic [1:0]     cmd_i;
    
    logic           psel_o;
    logic           penable_o;
    logic [31:0]    paddr_o, pwdata_o;
    logic           pwrite_o;
    
    logic           pready_i;
    logic [31:0]    prdata_i;
    
    clocking cb@(posedge clk);
        input psel_o, penable_o, paddr_o, pwdata_o, pwrite_o;
        output  pready_i, prdata_i, cmd_i;
    endclocking
    // if also testing slave, DO NOT use clocking block!!
    modport TEST (clocking cb, output reset);
    
    modport DUT (input reset, pready_i, prdata_i, cmd_i, output psel_o, penable_o, paddr_o, pwdata_o, pwrite_o);
endinterface


program automatic tb_prog(APB_intf.TEST intf);
    // 00: no op, 01: APB read from 0xDEAD_CAFE, 2'b10 Incrememtn previosuly read data
    // 11 Invalid
    task automatic test1;
        intf.cb.cmd_i <= 2'b01;
        @(intf.cb);
        assert (intf.cb.paddr_o == 32'hDEAD_CAFE)
        else $display("Inocrrect cmd_i: 2'b01: Expected: %0h, Actual: %0h", 32'hDEAD_CAFE, intf.cb.paddr_o);
        intf.cb.prdata_i <= 32'h7;
        @(intf.cb);
        assert(intf.cb.psel_o == 1'b1 && intf.cb.penable_o == 1'b0)
        else $display("Not asserted. Failed");
        repeat (2) @(intf.cb);
        assert(intf.cb.psel_o == 1'b1 && intf.cb.penable_o == 1'b1)
        else $display("Failed number 2");
        intf.cb.pready_i <= 1'b1;
        intf.cb.cmd_i <= 2'b10;
        @(intf.cb);
        @(intf.cb);
        assert(intf.cb.pwrite_o == 1'b1)
        else $display("Failed assert 3");
        intf.cb.cmd_i <= 2'b00;
        repeat (3) @(intf.cb);
        
        
        
    endtask
    
    initial begin
        intf1.reset <= 1'b1;
        repeat (3) @(intf1.cb);
        intf1.reset <= 1'b0;
        test1;
        $display("Tests finished!\n");
    end
    
endprogram


module day20_tb_top;
    logic clk = 0;
    always #5 clk = ~clk;
    
    APB_intf intf1(.*);
    tb_prog prog(intf1.TEST);
    APB_master_day20 DUT(.clk, .reset(intf1.reset),
                            .cmd_i(intf1.cmd_i),
                            .psel_o(intf1.psel_o),
                            .penable_o(intf1.penable_o),
                            .paddr_o(intf1.paddr_o), 
                            .pwdata_o(intf1.pwdata_o),
                            .pwrite_o(intf1.pwrite_o),
                            .pready_i(intf1.pready_i),
                            .prdata_i(intf1.prdata_i));

endmodule


