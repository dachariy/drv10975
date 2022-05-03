// Class : I2C Sequence

`ifndef I2C_SEQUENCE
`define I2C_SEQUENCE

class i2c_sequence extends uvm_sequence # (i2c_item);

  bit [7:0] valid_addr[30] = '{ 8'h00, 8'h01, 8'h02, 8'h03, 8'h10, 8'h11, 8'h12, 8'h13, 8'h14, 8'h15, 8'h16, 8'h17, 8'h18, 8'h19, 8'h1A, 8'h1B, 8'h1C, 8'h1E, 8'h20, 8'h21, 8'h22, 8'h23, 8'h24, 8'h25, 8'h26, 8'h27, 8'h28, 8'h29, 8'h2A, 8'h2B };
  bit [7:0] valid_write_addr[16] = '{ 8'h00, 8'h01, 8'h02, 8'h03, 8'h20, 8'h21, 8'h22, 8'h23, 8'h24, 8'h25, 8'h26, 8'h27, 8'h28, 8'h29, 8'h2A, 8'h2B };

  `uvm_object_utils(i2c_sequence)

  //Constructor
  function new(string name = "i2c_sequence");
    super.new(name);
  endfunction : new

  virtual task body();

    bit [7:0] data;

    reg_read(8'h2B);
    data = req.data;
    reg_write(8'h2B, data);  

  endtask : body


  virtual task reg_write (input bit [7:0] addr, 
                          input bit [7:0] reg_data);

    `uvm_do_with(req, {req.reg_address == addr; req.wr_rd == WRITE; req.data == reg_data;})
      
  endtask: reg_write

  virtual task reg_read (input bit [7:0] addr); 

    `uvm_do_with(req, {req.reg_address == addr; req.wr_rd == READ;})
      
  endtask: reg_read

endclass : i2c_sequence

`endif

