`include "uvm_macros.svh"
package sequencer;
    import uvm_pkg::*;
    import sequence_item::*;

    class dataSequence extends uvm_sequence#(sequence_item::dataInput);
        sequence_item::dataInput req;


        `uvm_object_utils(dataSequence);


        function new(string name = "dataSequence");
            super.new(name);
        endfunction //new()

        //  Override build in body() function \
        virtual task body();
            req = sequence_item::dataInput::type_id::create("req");
            wait_for_grant();                           //  built in method, waits for driver to request
            assert(req.randomize());                    //  randomize the sequence item
            send_request(req);                          //  sned req to sequencer and then to driver
            // optional:
            //  wait_for_item_done()                //  will block/wait until the driver calls item_done or put

        endtask //automatic
    endclass //writeSequence extends superClass
endpackage
