//  begin with a directive to specify which version of System Verilog is being used
`begin_keywords "1800-2017" //  use same keyword list as System Verilog 2017
module port_connections
    (
        input logic     a, 
        output logic    y
    );
endmodule

module examples
    (
        input logic     a, b, c, d,
        output logic    y
    );
    port_connections pc1(.a, .y);       //  dot name connectionsrgwe    port_connections pc2(.a(a), .y(y)); //  named port connections
    port_connections pc3(.*);   //  dot star connection
    port_connections pc4(a, y); //  port order connection

endmodule
`end_keywords