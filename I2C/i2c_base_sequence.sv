// Class : I2C BASE Sequence

`ifndef I2C_BASE_SEQUENCE
`define I2C_BASE_SEQUENCE

class i2c_base_sequence extends uvm_sequence # (i2c_item);

  bit [7:0] valid_addr[30] = '{ 8'h00, 8'h01, 8'h02, 8'h03, 8'h10, 8'h11, 8'h12, 
                                8'h13, 8'h14, 8'h15, 8'h16, 8'h17, 8'h18, 8'h19, 
                                8'h1A, 8'h1B, 8'h1C, 8'h1E, 8'h20, 8'h21, 8'h22, 
                                8'h23, 8'h24, 8'h25, 8'h26, 8'h27, 8'h28, 8'h29, 
                                8'h2A, 8'h2B };

  bit [7:0] valid_write_addr[16] = '{ 8'h00, 8'h01, 8'h02, 8'h03, 8'h20, 8'h21, 
                                      8'h22, 8'h23, 8'h24, 8'h25, 8'h26, 8'h27, 
                                      8'h28, 8'h29, 8'h2A, 8'h2B };

  bit [7:0] invalid_addr[8] = '{ 8'h04, 8'h05, 8'h06, 8'h07, 8'h08, 8'h09, 8'h1D,
                                 8'h1F};

  rand bit [7:0] reg_addr = 0;
  rand bit [7:0] data = 0;

  `uvm_object_utils(i2c_base_sequence)

  constraint reg_addr_c
  {
     reg_addr inside valid_write_addr;
  }

  //Constructor
  function new(string name = "i2c_base_sequence");
    super.new(name);
  endfunction : new

  virtual task body();

    reg_read(reg_addr);
    data = req.data;
    reg_write(reg_addr, data);  

  endtask : body

  virtual task reg_write (input bit [7:0] addr, 
                          input bit [7:0] reg_data);

    `uvm_do_with(req, {req.reg_address == addr; req.wr_rd == WRITE; req.data == reg_data;})
      
  endtask: reg_write

  virtual task reg_read (input bit [7:0] addr); 

    `uvm_do_with(req, {req.reg_address == addr; req.wr_rd == READ;})
      
  endtask: reg_read

endclass : i2c_base_sequence

`endif

