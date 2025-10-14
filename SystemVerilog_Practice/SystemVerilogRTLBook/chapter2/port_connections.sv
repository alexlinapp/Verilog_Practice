`timescale 1ns / 1ps    //  timeunit/ timeprecision
module port_connections(
        input   logic               load,
        input   logic   [31:0]      d,
        input   logic               clk,
        input   logic               setN,
        input   logic               rstN,
        output  logic   [31:0]      q,
        output  logic   [31:0]      qb
    );
endmodule
