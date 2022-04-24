// Class : I2C Agent

`ifndef I2C_AGENT
`define I2C_AGENT

class i2c_agent extends uvm_agent;

  bit is_master = 0;

  `uvm_component_utils_begin(i2c_agent)
    `uvm_field_int(is_master, UVM_ALL_ON)
  `uvm_component_utils_end
  
  uvm_sequencer # (i2c_item) sequencer;
  i2c_driver driver;
  i2c_monitor monitor;

  //Constructor 
  function new(string name = "agent", uvm_component parent = null);
    super.new(name, parent);

    if(uvm_config_db #(bit)::get(this, "*", "is_master", is_master))
    begin
      if(is_master)
        `uvm_info(get_type_name, "Agent Configured as I2C_MASTER", UVM_LOW)
      else
        `uvm_info(get_type_name, "Agent Configured as I2C_SLAVE", UVM_LOW)
    end
    else
    begin
        `uvm_fatal(get_type_name, "Cant fetch is_master from config_db, configuring as I2C Slave")
    end
  endfunction : new 

  //Build Phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    monitor = i2c_monitor::type_id::create("monitor", this);

    if(get_is_active() == UVM_ACTIVE)
    begin
      driver = i2c_driver::type_id::create("driver", this);
      sequencer = uvm_sequencer#(i2c_item)::type_id::create("sequencer", this);
    end
  endfunction : build_phase

  //Connect Phase
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    if(get_is_active() == UVM_ACTIVE)
    begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

  //Run Phase
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
  endtask: run_phase

endclass : i2c_agent

`endif
