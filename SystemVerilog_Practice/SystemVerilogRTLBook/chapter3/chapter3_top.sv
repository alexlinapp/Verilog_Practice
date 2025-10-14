`timescale 1ns / 1ps

module chapter3_top(
        input logic                 shift_clk, shift_enable,
        output  logic [31:0]        byte_out,
        output  logic [31:0]        byte_out2
    );
    
    
    
    /*
    
     Vector: array of consecutive bits. IEEE standard refers to them as packed arrays   
     
     By default logic is unsigned, can change to be signed using signed keyword
     
     Result of part select is ALWAYS unsigned, even if full variable is signed
    */
    
    logic [31:0]        v9; // 32-bit vector, little endian
    
    /*
        Index number of bit select for packed arrays can also be a variable
        However the number after +: must be CONSTNAT. It must be a number.
        Usually a multiplixer of the like is inferred using i as the select line
    */
    
    logic [31:0]        data;
    logic               bit_out;
    
    always @(posedge shift_clk)
        if (shift_enable) begin
            for (int i = 0; i < 31; i=i+8) begin
                byte_out[i+:8] <= data[i+:8];
            end
        end
        
     always @(posedge shift_clk)
        if (shift_enable) begin
            byte_out2 <= data;
        end
        
     /*
     
        Variables can only be assigned from a single source
        So if a variabel is assigend a valeu from an assign continuouts assignment statement
        then it is illegal to also assign teh variable a value in a procedural block
     
     */
     
     /*
        SystemVerilog allows vairabels to be intialized as part of declarign the variable,
        referred to as in-line initialization: only exectued one time, at the beginning of simulation
        
        In-line not supported by ASIC technologies and might be supported by some FPGA
        
        If FPGA device supports registers to power up to known state, in-line variable can be used
            -only use variable initialization in RTL models that will implmented on FPGA and for power up values of flip flops
            - Synteheis compilers and some FPGA devices that support in-line variabel initailization also allow using intiial proecedures
            to model the power-up value of flip flops
     
     */
     
     // following may or may not be syntehszible
     int i = 5;
     
     /*
        Datatype of nets MUST be logic
        the type is wire: can be wire, tri, supply0, supply1
        
        use logic data tuype to connect deisng componentes whenver the desing intent is to 
        have single drive functionality, use wire when design intnet is to permit multiepl drivers
     
     */
endmodule
