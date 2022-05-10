class driver_test extends uvm_test;
`uvm_component_utils(driver_test)

phase_agent phase_ag;

function new(string name = "driver_test", uvm_component parent);
    super.new(name,parent);
endfunction: new

virtual function void build_phase (uvm_phase phase);
    phase_ag = phase_agent::type_id::create("phase_agent", this);
endfunction

virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    #1000000;
    phase.drop_objection(this);
endtask

endclass