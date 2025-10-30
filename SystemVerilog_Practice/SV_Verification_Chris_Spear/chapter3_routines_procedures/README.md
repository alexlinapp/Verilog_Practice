### Tasks, Functions and Void Functions

System Verilog Casting:
- Syntax: `<target_type>'(<expression>)`
    - Void cast: `void'(x)`
    - Real cast: `real'(x)`


Functions:
- **Cannot** consume time (i.e. no delays or waits)
    - Exception is when a thread spawned by function with fork join_none can call a task
- If you want call to function to ignore return value, cast result to `void`
- Syntax: `function/endfunction`

Tasks:
- Can consume time (i.e. can have waits or delays like `#5`)
- Syntax: `task/endtask`


Shared between Tasks & Functions:
- Argument Direction: 
    - Default to `input logic` and are **sticky** so lasts for rest of arguments unless you explicitly change
    - Pass by referenceusing `ref` as `input`and `output` make copies when entering and exiting respectively
        - Modifying `ref` argument changes it immediately. The changes are instantly seen by calling function
- All functions and tasks have access to module-level signals regardless of `automatic` or not

