module top;
    
    
    
    
    function automatic void sum1(input int a, input int b);
        int c;
        c = a + b;
        $display("The sum of %0d and %0d is %0d", a, b, c);
    endfunction : sum1
    
    
    
    
    
    /*
    
    fixed size arrays

    */

    // two equivalent ways
    int lo_hi[0:15];    // 16 ints, [0], ... [15]
    int c_style[16];
    // $clog2() ceiling log base two function, synthesizble

    // multi-dimensioanl fixed-size arrays
    int array2 [0:7][0:3]; // 8 rows, 4 columns
    // equivalent
    int array3d [8][4]; 
    // out of bounds reads will return default value for the array element type



    /*
        dynamic arrays: Array size not specified at compile time, NOT syntehsizable

        -Use the new[size] where size is the size of the dynamic array
        -Can also use array literal to initialize dynamic arrays
        use arrr.delete() to delete and deallocate the array
    */

    int dyn[], d2[];


    /*
        queue:
        - Syntax: int q[$]; // dynamic size, can grow and shrink at runtime
           - use the $ sign for queue
           - Queue literalys do not use '
           - Never CALL the new method for a queue

    */

    /*
        Associative Arrays: Unpacked array whose index type is not reuqired to be an interge range
            - Index type can be any scalar type, string type or class type
            - Elements are allocated dynamiclaly as they are written (so not necessarily contiguous)
            - Essentially hashtable/hashmap/dictionary for System Verilog

            - Syntax:
                type array_name [index_type];
                    e.g. int aa[string]; // string indexed associative array of integers
            - Reading an element from an associate array that has not been written will return the default value for the arays base type
                - use exists() to check if a key exists in the associative array
    */

    int q2[$] = {3,4};
    int j;

    /*
        General Array Methods:
            - min, max, unique, sum, product, and

        - Use the with clause
        tq = d.find_index with (item > 3);
            - item here is the iterator argyment and represents teh single element of teh array, item is a keyword here
        -equivalent: tq = d.find_index(x) with (x > 3);
            - x is user defined iterator variable
            - if the conidtion after with is true then it returns that/or icnludes that
        array locator methods that return an index such as fine_indx return a queue of type int and nto inegeer

    */
    /*
        structs in systemverilog are synthesizable

    */

    // struct {bit [7:0], r, g, b;} pixel;
    // the above creates a singel pixel of this type

    // use typedef to create a new type
    typedef struct {bit [7:0] r, g, b;} pixel_s;
    pixel_s my_pixel;

    // initialize strucutre using struct literal which is '{}

    // my_pixel = 

    // static case: 'type
    // Dynamic cast: $cast(to, from)

    int switch[string], min_address, max_address, i, file;
    string s;
    initial begin
        // 2009 LRM states these variables MUST be delcared either in static block or have static keyword
        // ALL varaiblesl must be DELCARED before any other statements
        static int ascend[4] = '{0,1,2,3};  // intialize four elmenets using array literal '{}
        int descend[5];
        static int a = 21;

        descend = '{4,3,2,1,0}; // array literal

        descend[0:2] = '{7,6,5};
        $display("Descend: %p", descend);
        ascend = '{4{8}}; // replicate value 8 four times   
        $display("Ascend: %p", ascend);

        // default: num is used to set all members or elements in an array or struct to a value    
        ascend = '{default:9}; // set all elements to 9 
        $display("Ascend: %p", ascend);


        dyn = new[5]; // allocate 5 elements
        foreach (dyn[i]) dyn[i] = i;            // intiliaze the elments
        d2 = dyn;                       // copy by value
        d2[0] = 41;                     // modify d2 only
        $display("%0d, %0d", dyn[0], d2[0]);
        dyn = new[20](dyn);           // reisze to 20 ints, copy, old 5 element array is deallocated
        dyn = new[100];              // resize to 100 ints, old values are lost; 20 element array is deallocated

        dyn.delete();              // delete all the elements. size of 0 now

        dyn = '{1,3,5,7,9};

        foreach (dyn[j]) $display("dyn[%0d] = %0d", j, dyn[j]); foreach (dyn[j]) $display("dyn[%0d] = %0d", j, dyn[j]);

        $display("Queue in Action:");

        q2.insert(1, 5);  // insert 5 at index 1
        j = q2.pop_back(); // remove last element and return it
        q2.push_front(6);
        q2.push_back(9);
        $display("Queue: %p", q2);
        // $size() function returns the size of an array (for both fixed and dynamic arrays)

        file = $fopen("switch.txt", "r");
        while (! $feof(file)) begin
            $fscanf(file, "%d %s", i, s);
            switch[s] = i;
        end
        $fclose(file);

        // Get the min address
        // if not found default value of 0 for int array is used
        min_address = switch["min_address"];

        // get max address
        if (switch.exists("max_address"))
            max_address = switch["max_address"];
        else 
            max_address = 1000;
        
        foreach (switch[s])
            $display("switch['%s']=%0d", s, switch[s]);


        sum1(5, 6);
    end

endmodule : top