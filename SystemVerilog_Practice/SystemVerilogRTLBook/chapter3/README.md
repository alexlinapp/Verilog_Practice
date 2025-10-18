### Chapter 3

#### Variables
- By default, reg, logic, bit, time are unsigned variables while int, integer, byte are signed


##### Nets
- Specify net type and optional data type (net type is usually specified using `wire` keyword)
- Net vectors cannot be divided into subfields (cannot have multiple packed dimensions)
- Nets cannot be used on the left hand side of procedural assignments
- Must use continuous assignments (`assign`) or connection to an output or inout port



#### 3.6: Port Declarations:
- Module definitions include port list
- Port Declaration: Defines port's direction, type, data type, sign, size and name
    - Port Direction: `input`, `output`, `inout`
    - Port type and data type: `var` or any of the net types and datatype

#### Inherited Port Declarations:
- Explicit port direction delcaration remains in effect until new driection is specified
- 


#### 3.7 Unpacked arrays of nets and variables
- Packed Arrays: Collection of btis that are stored contiguosly and are commonly referred to as vectors
    - Hardware mapping singel big vector/bus of wires/register
- Unpacked Arrays: Collection of nets or variables 
    - i.e.: logic [7:0] data [3:0] (packed dimesnion is [7:0], always on left side of variable name), unpacked dimesnion on right side ([3:0])
    - Each logic [7:0] is NOT contiguous: Hardware mapping, seperate regs/memory cells
    - Use `'{}` to initialize explictily


#### 3.8 Paramter Constants:
- Allows modules to be configurable
- `parameter`: Run-time constant that can be externally modified
    - Module parameter list enclosed between the tokens `#(` and `)`
- `localparam`: Run-time constant that can only be set **internally**
    - Does not have to be placed inside the parameter list. **CAN** be placed in module body!
    - Similar to #define in C, except here it is a run-time constant