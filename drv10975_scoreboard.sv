// DRV10975 Scoreboard
`ifndef DRV10975_SCOREBOARD
`define DRV10975_SCOREBOARD

class drv10975_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(drv10975_scoreboard)

  uvm_analysis_imp #(i2c_item, drv10975_scoreboard) ap_imp;

  function new(string name = "drv10975_scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    ap_imp = new("ap_imp", this);
  endfunction : build_phase

  function void write(i2c_item packet);
  endfunction : write

endclass : drv10975_scoreboard

`endif

