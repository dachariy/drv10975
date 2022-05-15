// Class : I2C_WRONG_SLV_ADDR_TEST
`ifndef I2C_WRONG_SLV_ADDR_TEST
`define I2C_WRONG_SLV_ADDR_TEST

class i2c_wrong_slv_addr_item extends i2c_item;

  `uvm_object_utils(i2c_wrong_slv_addr_item)

  // Constraints
  constraint c_slave_address
  {
    slave_address != `I2C_SLAVE_ADDRESS;
  }

  //Constructor
  function new(string name = "i2c_wrong_slv_addr_item");
    super.new(name);
  endfunction : new

endclass : i2c_wrong_slv_addr_item

class i2c_wrong_slv_addr_test extends drv10975_base_test;

  i2c_read_write_sequence i2c_test_seq;

  `uvm_component_utils(i2c_wrong_slv_addr_test)

  //Constructor
  function new(string name = "i2c_wrong_slv_addr_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  //Build Phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    set_type_override_by_type(i2c_item::get_type(), i2c_wrong_slv_addr_item::get_type());
    i2c_test_seq = i2c_read_write_sequence::type_id::create("i2c_test_seq", this);
  endfunction : build_phase

  //Run Phase
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    
    // Demote Expected Error
    dut_env.i2c_ag.monitor.set_report_severity_id_override(UVM_ERROR, "i2c_invalid_slv_addr", UVM_INFO);
    tb_env.i2c_ag.monitor.set_report_severity_id_override(UVM_ERROR, "i2c_invalid_slv_addr", UVM_INFO);

    //Push error to demoted error Queue
    demoted_error_q.push_back("i2c_invalid_slv_addr");
    
    super.run_phase(phase);
    i2c_test_seq.start(tb_env.i2c_ag.sequencer);
    phase.drop_objection(this);
  endtask: run_phase

endclass : i2c_wrong_slv_addr_test

`endif
