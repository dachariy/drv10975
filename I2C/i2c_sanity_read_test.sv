// Class : I2C_TEST_SEQ 
`ifndef I2C_SANITY_READ_TEST
`define I2C_SANITY_READ_TEST

class i2c_sanity_read_test extends drv10975_base_test;
  
  i2c_read_write_sequence i2c_test_seq;

  `uvm_component_utils(i2c_sanity_read_test)

  //Constructor 
  function new(string name = "i2c_sanity_read_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new 

  //Build Phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    i2c_test_seq = i2c_read_write_sequence::type_id::create("i2c_test_seq");
  endfunction : build_phase

  //Run Phase
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    super.run_phase(phase);
    
    i2c_test_seq.randomize();
    
    `uvm_info(get_name(), $sformatf("starting sequnce : %s", i2c_test_seq.get_type_name), UVM_LOW)

    i2c_test_seq.start(tb_env.i2c_ag.sequencer);
    
    phase.drop_objection(this);
  endtask: run_phase

endclass : i2c_sanity_read_test

`endif

