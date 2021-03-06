// Class : DVR10975 TEST
`ifndef DRV10975_BASE_TEST
`define DRV10975_BASE_TEST

class drv10975_base_test extends uvm_test;
  

  drv10975_register_map register_map;

  drv10975_env dut_env;
  drv10975_env tb_env;

  string demoted_error_q[$];

  i2c_e2e_scoreboard i2c_e2e_scbd;
  
  `uvm_component_utils_begin(drv10975_base_test)
    `uvm_field_object(register_map, UVM_DEFAULT)
  `uvm_component_utils_end



  //Constructor 
  function new(string name = "drv10975_base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new 

  //Build Phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    dut_env = drv10975_env::type_id::create("dut_env", this);
    tb_env  = drv10975_env::type_id::create("tb_env", this);
    i2c_e2e_scbd = i2c_e2e_scoreboard::type_id::create("i2c_e2e_scbd", this);

    register_map = drv10975_register_map::type_id::create("register_map");
    uvm_config_db #(drv10975_register_map)::set(this, "*", "register_map", register_map);

    //Pass necessary config to ENVs
    uvm_config_db#(bit)::set(dut_env, "*", "is_dut", 1);
    uvm_config_db#(bit)::set(tb_env, "*",  "is_dut", 0);
    uvm_config_db#(bit)::set(this, "*dut_env*", "is_master", 0);
    uvm_config_db#(bit)::set(this, "*tb_env*",  "is_master", 1);

  endfunction : build_phase

  //Connect Phase
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    dut_env.i2c_ag.monitor.mon_ap.connect(i2c_e2e_scbd.dut_fifo.analysis_export);
    tb_env.i2c_ag.monitor.mon_ap.connect(i2c_e2e_scbd.tb_fifo.analysis_export);
  endfunction : connect_phase

  //End Of Elaboration Phase
  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction : end_of_elaboration_phase

  //Run Phase
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
  endtask: run_phase

  function void report_phase(uvm_phase phase);
    
    uvm_report_server svr;
    super.report_phase(phase);
    svr = uvm_report_server::get_server();

    foreach(demoted_error_q[i])
    begin
      if(svr.get_id_count(demoted_error_q[i]) == 0)
      begin
        `uvm_error(get_full_name(), $sformatf("%s was demoted but never fired in simulation", demoted_error_q[i]))
      end
    end
 
    if (svr.get_severity_count(UVM_FATAL) + svr.get_severity_count(UVM_ERROR) + svr.get_severity_count(UVM_WARNING) > 0)
     `uvm_info("final_phase", "TEST_RESULT: FAIL", UVM_LOW)
    else
     `uvm_info("final_phase", "TEST_RESULT: PASS", UVM_LOW)
 
  endfunction : report_phase

endclass : drv10975_base_test

`endif

