// Class : DRV10975 ENV
`ifndef DRV10975_ENV
`define DRV10975_ENV

class drv10975_env extends uvm_env;

  i2c_agent i2c_ag;
  i2c_scoreboard i2c_scbd;

  phase_agent phase_ag;

  drv10975_register_map register_map;

  bit is_dut;

  //UVM Utility Macro
  `uvm_component_utils_begin(drv10975_env)
    `uvm_field_int(is_dut, UVM_ALL_ON)
    `uvm_field_object(register_map, UVM_DEFAULT)
  `uvm_component_utils_end

  //Constructor 
  function new(string name = "env", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new 

  //Build Phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(!uvm_config_db #(bit)::get(this, "*", "is_dut", is_dut))
    begin
      `uvm_fatal(get_full_name(), "Cant fetch is_dut from config_db")
    end
    else
    begin
      if(is_dut)
      begin
        `uvm_info(get_full_name(), "Configuring ENV as DUT", UVM_LOW)
      end
      else
      begin
        `uvm_info(get_full_name(), "Configuring ENV as TB", UVM_LOW)
      end

      if(!uvm_config_db #(bit)::exists(this, "", "is_master"))
      begin
      `uvm_warning(get_full_name(), "Cant fetch is_master from config_db")
        if(is_dut)
        begin
          `uvm_info(get_full_name(), "Configuring I2C agent as SLAVE", UVM_LOW)
          uvm_config_db#(bit)::set(this, "*", "is_master", 0);
        end
        else
        begin
          `uvm_info(get_full_name(), "Configuring I2C agent as MASTER", UVM_LOW)
          uvm_config_db#(bit)::set(this, "*", "is_master", 1);
        end
      end
    end


    if(!uvm_config_db #(drv10975_register_map)::get(this, "*", "register_map", register_map))
      `uvm_fatal(get_full_name(), "Cant fetch register_map from config_db")

    phase_ag = phase_agent::type_id::create("phase_agent", this);

    i2c_ag = i2c_agent::type_id::create("i2c_agent", this);
    i2c_scbd  = i2c_scoreboard::type_id::create("i2c_scbd", this);
  endfunction : build_phase

  //Connect Phase
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    i2c_ag.monitor.mon_ap.connect(i2c_scbd.ap_imp);
  endfunction : connect_phase

  //Run Phase
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
  endtask: run_phase

endclass : drv10975_env

`endif

