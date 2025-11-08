### General Verification Workflow (Non-UVM)
#### Components:
**DUT**: Design Under Test

**Clock-Generator**: Clock generator module. Make sure to have `bit clk = 0` since in simulation at timestep/before timestep 0, clk will be set to an initial value
- Non-synthesizable

[**Interfaces** & **Clocking Blocks**](#interfaces): 
- **Interfaces**: Used to connect the ports for all the components listed in here (except TOP)
- **Clocking Block**: Used in interface to synchronize and prevent race conditions between **DUT** AND **TB**. See chapter5 for more details

[**Program Blocks**](#program-blocks) : Main bulk of where your testbench code should lie. Can contain functions and tasks

**Top Level Module**: Connects everything stated above together. INSTANTIATES the program blocks, DUT, interfaces etc




## Interfaces
- use `modport` and `clocking endclocking`
    - `modport DUT (input s1, s2, output o1, o2)` 
    - When using clocking block, use `@(cb)` NOT `@(posedge cb)`, not sure why but Vivado glitches.. to be figured out


## Program Blocks
- Main place where you place testbench code
- Make sure to declare all signals at the top
- All code is run during the **reactive** REGION in a time delta
- CANNOT have any hiearchy such as instances of other modules, interfaces or other programs
- Alaways declare program blocks as `automatic` so that behaves like routines and stack based
- ### End of Simulation:
    - Simulation ends when all program blocks are completed. 
        - If there is a single program, simulation will end after that program finishes/execute and complete the last statement in every `initial` block of the program
        - Can terminate program early by calling `$exit`
    - `final` block that contaisn code to be run just before the simulator terminates