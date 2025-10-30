### Tasks, Functions and Void Functions

System Verilog Casting:
- Syntax: `<target_type>'(<expression>)`
    - Void cast: `void'(x)`
    - Real cast: `real'(x)`
- CAN return values


Functions:
- **Cannot** consume time (i.e. no delays or waits)
    - Exception is when a thread spawned by function with fork join_none can call a task
- If you want call to function to ignore return value, cast result to `void`
- Syntax: `function/endfunction`
- To return value, either can use `return` or can assign value to be returned to function name which will be returned

Tasks:
- Can consume time (i.e. can have waits or delays like `#5`)
- Syntax: `task/endtask`
- **CANNOT** return values


Shared between Tasks & Functions (Umbrella Term: Routines):
- Argument Direction: 
    - Default to `input logic` and are **sticky** so lasts for rest of arguments unless you explicitly change
    - Pass by referenceusing `ref` as `input`and `output` make copies when entering and exiting respectively
        - Modifying `ref` argument changes it immediately. The changes are instantly seen by calling function
- All functions and tasks have access to module-level signals regardless of `automatic` or not
- Can pass arguments by namem similar to ports: i.e. `.d(8)`
- Routines are `static` by default (common shared storage in global variables section)
- Use `automatic` keyword in function definition to to use automatic storage which causes simulator to use stack for local variables

Storage:
- Static variables: Global variables shared through program/module <span style="color:red">(NOT inter modoule); </span>
- Automatic Variables: Created each time a task/function is called (not shared); limited lifetime to specific call, stack-based
    - CANNOT declare at module scope!! will get an error!

