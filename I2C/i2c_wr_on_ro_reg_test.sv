// Class : I2C_TEST_SEQ 
`ifndef I2C_WR_ON_RO_REG_TEST 
`define I2C_WR_ON_RO_REG_TEST

class i2c_wr_on_ro_reg_seq extends i2c_read_write_sequence; 

  `uvm_object_utils(i2c_wr_on_ro_reg_seq)

  constraint reg_addr_c
  {
     reg_addr inside valid_addr;
     !(reg_addr inside valid_write_addr);
  }

  //Constructor
  function new(string name = "i2c_wr_on_ro_reg_seq");
    super.new(name);
  endfunction : new

  virtual task body();
    super.body();
  endtask : body

endclass : i2c_wr_on_ro_reg_seq

class i2c_wr_on_ro_reg_test extends i2c_sanity_read_test;

  `uvm_component_utils(i2c_wr_on_ro_reg_test)

  //Constructor 
  function new(string name = "i2c_wr_on_ro_reg_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new 

  //Build Phase
  virtual function void build_phase(uvm_phase phase);
    set_type_override_by_type(i2c_read_write_sequence::get_type(), i2c_wr_on_ro_reg_seq::get_type());
    super.build_phase(phase);
  endfunction : build_phase

  //Run Phase
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    // Demote Expected Error
    dut_env.i2c_ag.monitor.set_report_severity_id_override(UVM_ERROR, "i2c_invalid_reg_addr", UVM_INFO);
    tb_env.i2c_ag.monitor.set_report_severity_id_override(UVM_ERROR, "i2c_invalid_reg_addr", UVM_INFO);
    
    //Push error to demoted error Queue
    demoted_error_q.push_back("i2c_invalid_reg_addr");

    super.run_phase(phase);
    phase.drop_objection(this);
  endtask: run_phase

endclass : i2c_wr_on_ro_reg_test

`endif

