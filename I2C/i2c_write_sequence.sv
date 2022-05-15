// Class : I2C Write Sequence

`ifndef I2C_WRITE_SEQUENCE
`define I2C_WRITE_SEQUENCE

class i2c_write_sequence extends i2c_base_sequence; 

  `uvm_object_utils(i2c_write_sequence)

  //Constructor
  function new(string name = "i2c_write_sequence");
    super.new(name);
  endfunction : new

  virtual task body();
    reg_write(reg_addr, data);  
  endtask : body

endclass : i2c_write_sequence

`endif

