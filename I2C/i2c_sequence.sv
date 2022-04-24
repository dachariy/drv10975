// Class : I2C Sequence

`ifndef I2C_SEQUENCE
`define I2C_SEQUENCE

class i2c_sequence extends uvm_sequence # (i2c_item);

  int txn_no;

  `uvm_object_utils(i2c_sequence)

  //Constructor
  function new(string name = "i2c_sequence");
    super.new(name);
  endfunction : new

  virtual task body();
    txn_no = 0;
  endtask : body

endclass : i2c_sequence

`endif

