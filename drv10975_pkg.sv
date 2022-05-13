//DRV10975 PKG

`ifndef DRV10975_PKG
`define DRV10975_PKG

package drv10975_pkg;
  import uvm_pkg::*;
  `include "phase/placeholder.sv"
  `include "phase/phase_item.sv"
  `include "phase/phase_driver.sv"
  `include "phase/phase_seqr.sv"
  `include "phase/phase_sequence.sv"
  `include "phase/phase_monitor.sv"
  `include "phase/phase_agent.sv"
  `include "phase/phase_test.sv"
  

  `include "drv10975_defines.svh"
  `include "I2C/i2c_defines.svh"
  `include "I2C/i2c_item.sv"
  `include "I2C/i2c_sequence.sv"
  `include "drv10975_register_map.sv"
  `include "I2C/i2c_scoreboard.sv"
  `include "I2C/i2c_e2e_scoreboard.sv"
  `include "I2C/i2c_driver.sv"
  `include "I2C/i2c_monitor.sv"
  `include "I2C/i2c_agent.sv"
  `include "drv10975_scoreboard.sv"
  `include "drv10975_env.sv"
  `include "drv10975_base_test.sv"
  
  `include "I2C/i2c_sanity_read_test.sv"
  `include "I2C/i2c_wrong_slv_addr_test.sv"
  `include "I2C/i2c_invalid_reg_addr_test.sv"
endpackage

`endif

