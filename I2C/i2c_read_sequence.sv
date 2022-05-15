// Class : I2C Read Sequence

`ifndef I2C_READ_SEQUENCE
`define I2C_READ_SEQUENCE

class i2c_read_sequence extends i2c_base_sequence; 

  `uvm_object_utils(i2c_read_sequence)

  //Constructor
  function new(string name = "i2c_read_sequence");
    super.new(name);
  endfunction : new

  virtual task body();
    reg_read(reg_addr);
  endtask : body

endclass : i2c_read_sequence

`endif

