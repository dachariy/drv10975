class phase_change_dirn_test extends drv10975_base_test;
  `uvm_component_utils(phase_change_dirn_test)

  phase_change_dirn_sequence phase_seq;
  phase_seqr phase_sqr;

  function new(string name = "phase_change_dirn_test", uvm_component parent);
    super.new(name,parent);
  endfunction: new

  virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    phase_seq = phase_change_dirn_sequence::type_id::create("phase_change_dirn_sequence", this);
  endfunction

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    super.run_phase(phase);
    phase_seq.start(dut_env.phase_ag.phase_sqr);
    phase.drop_objection(this);
  endtask

endclass
