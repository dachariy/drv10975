// Class : I2C Sequence Item(Packet Class)

`ifndef I2C_ITEM
`define I2C_ITEM

class i2c_item extends uvm_sequence_item;
  
  typedef enum bit {MASTER, SLAVE} device_e;
  typedef enum bit {READ, WRITE} action_e;
  
  // Rand Variable declarations
  rand bit [6:0] slave_address;
  rand bit [7:0] reg_address;
  rand action_e wr_rd;
  rand bit [7:0] data;
  rand device_e device;

  //UVM Automation Macro
  `uvm_object_utils_begin(i2c_item)
    `uvm_field_enum(device_e, device, UVM_ALL_ON | UVM_NOCOMPARE)
    `uvm_field_int(slave_address, UVM_ALL_ON)
    `uvm_field_int(reg_address, UVM_ALL_ON)
    `uvm_field_enum(action_e, wr_rd, UVM_ALL_ON)
    `uvm_field_int(data, UVM_ALL_ON)
  `uvm_object_utils_end

  // Constraints

  constraint c_slave_address
  {
    slave_address == `I2C_SLAVE_ADDRESS;
  }

  constraint c_reg_address
  {
    reg_address inside {[8'h00:8'h03], [8'h10:8'h1C], 8'h1E, [8'h20:8'h2B]};
  }

  //Constructor
  function new(string name = "i2c_item");
    super.new(name);
  endfunction : new

endclass : i2c_item

`endif

