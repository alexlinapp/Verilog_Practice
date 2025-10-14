`timescale 1ns / 1ps
module chapter2_top(
        input logic a, b,
        output  logic c
    );
    
    
    
    logic load_b, load_d;
    logic rstN, clk;
    logic [31:0] a_data, b_data, i_data, data_out;
    
    
    /*
        Port order connections: Connect local  net names to the ports of the module instance
        using the order in which the ports of the module where definedv
        
        Will infer netlist/net for local signal if not defined before
    
    */
    
    port_connections pc1(load_b, a_data, clk, , rstN, b_data,);
    
    
    /*
        Named port connections: 
            - Explicit named connection: 
                - Will infer netlist/net for local signal if not defined before
            - Dot name connection shortcut: Only use name. Local signal nameneeds to match port signal name
                - Can mix explicit connection with dot name
                - Net or variable with name that exactly matches port name must be delcared prior to module instance
                - Net or variable vector size must match eactly the port vector size
                - Data types for each side need to be compatible
                - WILL NOT infer an implicit net
            - Dot-start connection: all ports and signals of the same name should be automaticlly connected
                - Nets mus tbe explicitly declared and name and vector size must match exactly
                - Will not infer unconnected ports. Ports must expictly use empty paranetheses to shwo no connection
                - Can mix and match with explicit name
        
        Port connections can be listed in any order
        Unused Ports can be left out of the connection list or use .port_siganl()
        
        
    */
    
    port_connections pc2(.load(load_b), .d(a_data));
    
    
    assign c = a & b;
    
    
endmodule
