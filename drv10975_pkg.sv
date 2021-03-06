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
  `include "phase/phase_scoreboard.sv"
  `include "phase/phase_agent.sv"

  `include "drv10975_defines.svh"
  `include "I2C/i2c_defines.svh"
  `include "I2C/i2c_item.sv"

  `include "I2C/i2c_base_sequence.sv"
  `include "I2C/i2c_read_sequence.sv"
  `include "I2C/i2c_read_write_sequence.sv"
  `include "I2C/i2c_write_sequence.sv"

  `include "drv10975_register_map.sv"

  `include "I2C/i2c_scoreboard.sv"
  `include "I2C/i2c_e2e_scoreboard.sv"
  `include "I2C/i2c_driver.sv"
  `include "I2C/i2c_monitor.sv"
  `include "I2C/i2c_agent.sv"
  `include "drv10975_scoreboard.sv"
  `include "drv10975_env.sv"
  `include "drv10975_base_test.sv"

  `include "phase/phase_accl_to_duty_cycle_sequence.sv"
  `include "phase/phase_change_dirn_sequence.sv"
  `include "phase/phase_lower_spd_2_zero_sequence.sv"
  `include "phase/phase_speedup_wo_accln_sequence.sv"
  `include "phase/phase_startup_w_accln_sequence.sv"

  `include "phase/phase_accl_to_duty_cycle_test.sv"
  `include "phase/phase_change_dirn_test.sv"
  `include "phase/phase_lower_spd_2_zero_test.sv"
  `include "phase/phase_speedup_wo_accln_test.sv"
  `include "phase/phase_startup_w_accln_test.sv"

  `include "I2C/i2c_sanity_read_test.sv"
  `include "I2C/i2c_wrong_slv_addr_test.sv"
  `include "I2C/i2c_invalid_reg_addr_test.sv"
  `include "I2C/i2c_wr_on_ro_reg_test.sv"
  `include "drv10975_eeprom_test.sv"
endpackage

`endif
