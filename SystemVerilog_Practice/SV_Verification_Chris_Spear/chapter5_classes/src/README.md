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

### Scoping Rules and Variables
- For testbenches, can declare variables in the `program` or the `initial` block
- Can only **define** and assign variables in a procedural block (so does not include program!!)
- System Verilog does nto allow you to assign values directly at the program scope



### Inheritance

#### Defintions:
- Base Class: Original class that is a new class can extend
- Extended Class: Class that inherits from another class. We say it extends the (base) class
    - Extended class can see all variables, and properties of base class
    - Use `super` keyword to reference base class 
        - Not allowed to do `super.super` though
    - **Constructors**: If base class constructor has any arguments, the extended class must have a constrcutor and mus call the base's constructor on its first line
- Downcasting/Conversion: Act of casting a base class hanlde to point to an object that is a class extended from that base type
    - Can automaticlaly assing extended class handle to base class, no cast is needed
    - CANNOT assign base class handel to extneded class. Needs to use `$cast` and the actual object type that base class handle points to must be the extended class
- `virtual`: Modifier that tells SystemVerilog whether to check the type of handle to determine which function to call or the type of object
    - Since say base class `Trans` and we have `BadTrans extends Trans`. If an object say `BadTrans b = new()` and `Trans a = b` doing `a.func()` will call the `b.func()` if `func` has virtual
    - Constructors CANNOT be virtual!
