class phase_speedup_wo_accln_test extends drv10975_base_test;
  `uvm_component_utils(phase_speedup_wo_accln_test)

  phase_speedup_wo_accln_sequence phase_seq;
  phase_seqr phase_sqr;

  function new(string name = "phase_speedup_wo_accln_test", uvm_component parent);
    super.new(name,parent);
  endfunction: new

  virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    phase_seq = phase_speedup_wo_accln_sequence::type_id::create("phase_speedup_wo_accln_sequence", this);
  endfunction

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    super.run_phase(phase);
    phase_seq.start(dut_env.phase_ag.phase_sqr);
    phase.drop_objection(this);
  endtask

endclass
