class phase_test extends drv10975_base_test;
`uvm_component_utils(phase_test)

phase_sequence phase_seq;
phase_seqr phase_sqr;

function new(string name = "driver_test", uvm_component parent);
    super.new(name,parent);
endfunction: new

virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    phase_seq = phase_sequence::type_id::create("phase_sequence", this);
endfunction

virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    $display("Reached this point");
    //phase_seq.start(tb_env.phase_ag.phase_sqr);
    phase_seq.start(dut_env.phase_ag.phase_sqr);
    //#3000;
    phase.drop_objection(this);
endtask

endclass