// Class : I2C Monitor

`ifndef I2C_MONITOR
`define I2C_MONITOR

class i2c_monitor extends uvm_monitor; 

  virtual i2c_if mon_vif;

  i2c_item packet;
  
  drv10975_register_map register_map;
  
  uvm_analysis_port #(i2c_item) mon_ap;
  
  bit is_master;
  int txn_no;


  // UVM Utility Macro
  `uvm_component_utils_begin(i2c_monitor)
    `uvm_field_int(is_master, UVM_ALL_ON)
    `uvm_field_object(register_map, UVM_ALL_ON | UVM_NOPRINT)
  `uvm_component_utils_end

  //Constructor 
  function new(string name = "monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new 

  //Build Phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if(!(uvm_config_db #(virtual i2c_if)::get(this, "*", "i2c_vif", mon_vif)))
    begin
      `uvm_fatal(get_type_name, "Cant fetch mon_if from config_db")
    end

    if(!uvm_config_db #(drv10975_register_map)::get(this, "*", "register_map", register_map))
    begin
      `uvm_fatal(get_type_name(), "Cant Fetch register_map from config_db")
    end
    
    
    mon_ap = new("mon_ap", this);

    if(uvm_config_db #(bit)::get(this, "*", "is_master", is_master))
    begin
      if(is_master)
        `uvm_info(get_type_name, "Monitor Configured as I2C_MASTER", UVM_LOW)
      else
        `uvm_info(get_type_name, "Monitor Configured as I2C_SLAVE", UVM_LOW)
    end
    else
    begin
        `uvm_warning(get_type_name, "Cant fetch is_master from config_db, configuring as I2C Slave")
    end
  endfunction : build_phase

  //Connect Phase
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction : connect_phase

  //Run Phase
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
  endtask: run_phase

endclass : i2c_monitor

`endif

