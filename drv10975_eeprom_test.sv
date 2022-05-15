// Class : DRV10975 EEPROM TEST 
`ifndef DRV10975_EEPROM_TEST 
`define DRV10975_EEPROM_TEST

class drv10975_eeprom_test extends drv10975_base_test;
  
  i2c_write_sequence i2c_write_seq;
  i2c_read_sequence i2c_read_seq;

  `uvm_component_utils(drv10975_eeprom_test)

  //Constructor 
  function new(string name = "drv10975_eeprom_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new 

  //Build Phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    i2c_write_seq = i2c_write_sequence::type_id::create("i2c_write_seq");
    i2c_read_seq = i2c_read_sequence::type_id::create("i2c_read_seq");

  endfunction : build_phase

  //Run Phase
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    super.run_phase(phase);

    //Write EEPROM Register
    i2c_write_seq.reg_addr = `MOTORPARAM1;
    i2c_write_seq.data = 8'hAA;
    i2c_write_seq.start(tb_env.i2c_ag.sequencer);

    // Perform I2C read to ensure write occured
    i2c_read_seq.reg_addr = `MOTORPARAM1;
    i2c_read_seq.start(tb_env.i2c_ag.sequencer);

    if(i2c_read_seq.data !== 8'hAA)
    begin
      `uvm_error(get_full_name(), $sformatf("I2C read data mismatch. Expected=8'h%8h | Actual=8'h%8h", 8'hAA, i2c_read_seq.data))
    end
    else
    begin
      `uvm_info(get_full_name(), "I2C read data matched expected data", UVM_LOW)
    end

    //Reset Register Map and read to ensure default value
    register_map.reset();
    i2c_read_seq.reg_addr = `MOTORPARAM1;
    i2c_read_seq.start(tb_env.i2c_ag.sequencer);

    if(i2c_read_seq.data !== `MOTORPARAM1_DEFAULT)
    begin
      `uvm_error(get_full_name(), $sformatf("I2c read data mismatch. Expected=8'h%8h | Actual=8'h%8h", `MOTORPARAM1_DEFAULT, i2c_read_seq.data))
    end
    else
    begin
      `uvm_info(get_full_name(), "I2C read data matched expected data", UVM_LOW)
    end

    //Write EEPROM Register
    i2c_write_seq.reg_addr = `MOTORPARAM1;
    i2c_write_seq.data = 8'hAA;
    i2c_write_seq.start(tb_env.i2c_ag.sequencer);

    // Perform I2C read to ensure write occured
    i2c_read_seq.reg_addr = `MOTORPARAM1;
    i2c_read_seq.start(tb_env.i2c_ag.sequencer);

    if(i2c_read_seq.data !== 8'hAA)
    begin
      `uvm_error(get_full_name(), $sformatf("I2c read data mismatch. Expected=8'h%8h | Actual=8'h%8h", 8'hAA, i2c_read_seq.data))
    end
    else
    begin
      `uvm_info(get_full_name(), "I2C read data matched expected data", UVM_LOW)
    end

    //Save EEPROM registers

    //Sldata
    i2c_read_seq.reg_addr = `EECTRL;
    i2c_read_seq.start(tb_env.i2c_ag.sequencer);
    i2c_write_seq.reg_addr = `EECTRL;
    i2c_write_seq.data = i2c_read_seq.data;
    i2c_write_seq.data[6] = 1;
    i2c_write_seq.start(tb_env.i2c_ag.sequencer);

    //enProgKey
    i2c_write_seq.reg_addr = `DEVCTRL;
    i2c_write_seq.data = 8'hB6; 
    i2c_write_seq.start(tb_env.i2c_ag.sequencer);

    //eeWrite
    i2c_read_seq.reg_addr = `EECTRL;
    i2c_read_seq.start(tb_env.i2c_ag.sequencer);
    i2c_write_seq.reg_addr = `EECTRL;
    i2c_write_seq.data = i2c_read_seq.data;
    i2c_write_seq.data[4] = 1;
    i2c_write_seq.start(tb_env.i2c_ag.sequencer);

    //Reset Register Map and read to ensure updated value
    register_map.reset();
    i2c_read_seq.reg_addr = `MOTORPARAM1;
    i2c_read_seq.start(tb_env.i2c_ag.sequencer);

    if(i2c_read_seq.data !== 8'hAA)
    begin
      `uvm_error(get_full_name(), $sformatf("I2c read data mismatch. Expected=8'h%8h | Actual=8'h%8h", 8'hAA, i2c_read_seq.data))
    end
    else
    begin
      `uvm_info(get_full_name(), "I2C read data matched expected data", UVM_LOW)
    end
 
    phase.drop_objection(this);
  endtask: run_phase

endclass : drv10975_eeprom_test

`endif

