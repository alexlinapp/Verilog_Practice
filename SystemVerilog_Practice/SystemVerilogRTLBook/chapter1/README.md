### Chapter 1
#### RTL & Gate Level Modeling
RTL: Register Transfer Level: Layer of modeling that represents digital functionality with programming statements and operators. DOES NOT contain details of implementation on silicon

Vector: Signal that is more than one bit wide

Scalar Signals: 1 bit wide signals

Procedural Block: Encapsulates one or more lines of programming statements

Simulation Time Slot: Each moment in time for finest precision of time represented in sv source code

Event Regions: Each simulation time slot contains several event regions

RTL Modeling Mainly uses the two regions below
    
- Active Event Region: 
    - Continuous Assignemnts: Evluate right hand side and update left hand side
    - Non-blocking assignments: Evalute right hand side
- NBA Update event Region:
    - Non-blocking assignments: Update left hand side

Simulation:

- Does not limit what System Verilog Constructs can be used
- Purely simulation. Uses a user defined test bench to apply stimulus to inputs

Syntehsis:

- Translates RTL functionality into specific gate-level implementation
- Generates net list: List of components and wires (called nets) that connect this components together
    - Components referenced in netlist will be the ASIC standard cells or FPGA CLB blocks
    - CLB (Conifgurable logic) Block: Basic building block of FPGA. Contains MUXes, LUTs, D-flip flops