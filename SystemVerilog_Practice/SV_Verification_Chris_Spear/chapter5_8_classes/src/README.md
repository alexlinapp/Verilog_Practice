### Classes
- Can use and define classes in `program`, `module`, `package`, or outside any of these

#### Definitions:
- Class: Basic building block containg routines and variables; allows for OOP
- Object: Instance of a class, need to instantiate to use
- Handle: Pointer to an object: Likean address of the object, but stored in a pointer that can only refer to one type
- Method: `task` or `function` defined inside the scope of the class
    - Method in a class uses automatic storage by default, so don't need to worry about remembering the `automatic` modifier
    - Prototype: Header of a routine that shows the name, type, and argument list plus return type



#### Class Specifics:
- Constructors: Method/special function that automatically returns handle to an object of the same type as the class
    - CAN ONLY have **ONE** constructor per class!
- SystemVerilog has automatic garbage collection. Once an object has no more handles referencing it it will be automatically deallocated
- `this` keyword refers to the current object instance of a class; useful to get variables for this class
- Can use `extern` keyword to break method into prototype and body(to put outside of the class)
- `static` variables: Shared among all instances of the class, but scope is limited to the class
- `::` is class scope resolution operator
- `static` method: Class method that belongs to the class itself, not to any particular object instance
    - DO NOT need an object handle to call it
        - Cannot access instance (non-static) member variables or methods cna only access static variables and methods!
- When you call a method that requires the object, you pass a handel to the object NOT THE object itself
    - You pass in a copy of a handle to the object. If you want to modify the actual handle pass in as `ref`
- Use `target_class = new src_class`: to use built-in copy-method to copy fields of src_class to target_class. However better to create your own copy method
- <span style="color:red">Public Vs: Local</span>: By **default** everything in SystemVerilog is <span style="color:red">**PUBLIC**</span>

#### Inheritance
- Use the `extends` keyword
- In the extended class can call parent functions by using `super().parentfunc()`
- If base class constructor has any arguments, the extended class must have a constructor and must call the base class' constructor on its first line
- If you have a **handle** of the base type, it can also point toan object of an extended type
    - Handel can only refernce things in the base class such as teh variabels and the method
    - If overriden and declared as `virtual` then the handle that is of the base type can end up calling the dervied `virtual`
#### Abtract Classes & Pure Virtual Functions:
- **Abstract Class**: Class that can be extended but not instantiated directly. Defined with `virtual` keyword
- **Pure Virtual Method**: A prototype without a body. A class that extendes from an abstrct cllass can only be instantited if all pure virtual methods ahve bodies
    - Can only be declared in abstract classes
##### Virtual Functions:


#### Virtual Interfaces:
- Classes CANNOT directly hold interface instances!!!!. Interfaces are REAL siganls. Classes cannot handle that!
    - Regular interface exist in the static design/heirarchy (they are "hardware objects")
    - Classes exist in the dynamic simulation world. So class is not part of the hardware hiearchy
- **Solution**: Use VIRTUAL interfaces: Which are pointers to the existing interface. So driving these virtual interfaces drives the acutal underlying interface they point to



### Scoping Rules and Variables
- For testbenches, can declare variables in the `program` or the `initial` block
- Can only **define** and assign variables in a procedural block (so does not include program!!)
- System Verilog does nto allow you to assign values directly at the program scope



#### Threads, Processes, Events, Mailboxes:
- All processes/forked threads are **concurrent**/illusion of concurrency
    - They all "run" at the same time, but the simulation scheduler chooses the run order for each time delta. They each run in each time delta but order is dependnent on simulator
        - i.e. all exectued sequentially within the same simulation time slot in NONDETERMINISTIC ORDER
- Declare events using: `event` keyword.
- Use `->` to trigger an event
- Instead of using edge senestive blcok `@e1`, use the level-sensitive `wait(e1.triggered)`
- **Mailboxes**: Just a FIFO with a source and sink. The soruce puts data into mailbox, the sink gets values from teh mailbox
    - When source thread tries to pu a value into a sized mailbox that is full, the thread blocks unilt the value is removed
    - Used to send transactions betweeen the generator and driver
    - `put(), get(), peek(), tryget(), trypeek()`
    - `mailbox #(Transaction) mbx_tr`


### System Verilog Assertions
- Two domains **temporal** and **spatial**
    - **Temproal**: Describes relaitonships between events OVERTIME `assert property`
    - **Spatial** (Non-Temporal): Checks actions that happnes instnatlyat one simulation time `assert(a == b)`
- Three types of assertions:
    - **Immediate Assertion**: Exectued immediately, interpreted like procedural `if` statement
        - Do not SAMPLE from observed or preponed region of a simulation tick!. Sampled IMMEDIATELY! I.e. if in active region (DUT) then sampeld there if in `program block` (reactive region) then sample there!
        - Deferred Immediate Assertion: Type of immediate asssertion that evalutes the sequence expression IMMEDIALTY (when all values have settled down). However ERROR reporting is done in the postponed region!
            - Syntax: `assert #0` or `assert final`
            - Action block: What to exectue based upon pass and fail statements. Consists of single subroutine call
            - Deferred assertion flush point, reports are flushed and then updated!!! 
            -  `Observered Deferred Assertion` (using `$0`) Versus `Final Deferred Assertion` using `final`
                - `Observered Deferred Assertion`: Action block executed in the REACTIVE REGION (so report fianlized in observed region)
                - `Final Deferred Assertion`: Action block exectued in the POSTPONED REGION (report finalized in postponed region)
            - Active Region (Reports are genreated or cleared) -> (Observed Any OBSERVERED DEFFERED ASSERTION reports in queue are flushed (hence mature)) -> Reactive (Associated action block exectues for OBSERVED DEFFERED ASSERTION REPORTS THAT WERE NOT CLEARED) -> Postponed (Any FINAL DEFFERED ASSERTIONS REPORTS ARE generated/cleared)
            - EXPRESSION inside the assertion is STILL evaluted immediately in whatever region the assertion was placed in! However it is the **action block** and when it gets executed that changes. As well as possibility of flushing
            - **Deferred Assertion Flush Points**: Occur in the active region usually due to `always_comb` or `always_latch` and execution is resumed due to the transition of one of its dependnet signals

    - Concurrent Assertion: Edge senstive and can smaple the values of variables used in a seuqecne or a property. Sampling edge can be synchrnonous or asynchrnous
        - Defined on edge. Sampled in **preponed** region of the edge!! ALL VARIABLES INCLUDING in sequecnes and properties!
        - `Sequences` and `Propreties`
        - `Sequences`: Edge inherited from property
        - Use implication oeperator:
            - `A |-> B `: Overlapping. A and B must be true eon the same clock edge (exectue B at the same clk)
            - `A |=> B`: Non-overlapping Conseuqncet (B) should start executign one clk later
            - `##n`: Delay n clock edges (sample on the next "nth" clcok edge) 
        - Concurrent assertions can be placed in alawys, intial procedural block. Standloen (static) otusdei of procedural block
    
- Active Region: If there are any processes scheudled due to signal changes INSIDE the active region it will keep on running UNTIL it is stable!!!
- Severity Levels:
    - `$fatal, $error, $warning, $info`


#### Random/Constrained Random Stimulus:
- Use `rand` or `randc` keywords along with `obj.randomize()` to randomize those values
- Constraints are groups of **expressions**. Express using `{}`
    - Using `dist` operator: `constraint c_dst { src dist {0:=40, [1:3] :=60}}`
        - `:=` specifies that the weight is same for very specified value in the rnage i.e. 1 has weight 60, 2 has weight 60 etc
        - `/:` specifies weight is divided up in the range
        - `inside` operator to create sets of values
    - inline constraints: use `t.randomize() with`