`include "uvm_macros.svh"
package seq_pkg;
    import uvm_pkg::*;
    import sequence_item_pkg::*;

    class dataSequence extends uvm_sequence#(sequence_item_pkg::dataInput);
        sequence_item_pkg::dataInput req;


        `uvm_object_utils(dataSequence);


        function new(string name = "dataSequence");
            super.new(name);
        endfunction //new()

        //  Override build in body() function \
        virtual task body();
            req = sequence_item_pkg::dataInput::type_id::create("req");
            wait_for_grant();                           //  built in method, waits for driver to request
            assert(req.randomize());                    //  randomize the sequence item
            send_request(req);                          //  send req to sequencer and then to driver
            // optional:
            //  wait_for_item_done()                //  will block/wait until the driver calls item_done or put
            toGenerate();

        endtask //automatic

        virtual task toGenerate(int n = 10);
            for (int i = 0; i < n; i++) begin
                req = sequence_item_pkg::dataInput::type_id::create("req");
                $display("i: %0d, waiting for grant in sequence", i);
                wait_for_grant(); 
                assert(req.randomize()); 
                send_request(req);
            end
        endtask //automatic
    endclass //writeSequence extends superClass
endpackage
