#!/bin/bash
rm -rf SIMULATION_LOGS
mkdir SIMULATION_LOGS

./sv_uvm top.sv
mv sim.log SIMULATION_LOGS/compile_test.log

./simv top.sv +UVM_TESTNAME=i2c_sanity_read_test | tee sim.log
mv sim.log SIMULATION_LOGS/i2c_sanity_read_test.log

./simv top.sv +UVM_TESTNAME=i2c_wrong_slv_addr_test | tee sim.log
mv sim.log SIMULATION_LOGS/i2c_wrong_slv_addr_test.log

./simv top.sv +UVM_TESTNAME=i2c_invalid_reg_addr_test | tee sim.log
mv sim.log SIMULATION_LOGS/i2c_invalid_reg_addr_test.log

./simv top.sv +UVM_TESTNAME=drv10975_eeprom_test | tee sim.log
mv sim.log SIMULATION_LOGS/drv10975_eeprom_test.log

./simv top.sv +UVM_TESTNAME=i2c_wr_on_ro_reg_test | tee sim.log
mv sim.log SIMULATION_LOGS/i2c_wr_on_ro_reg_test.log

./simv top.sv +UVM_TESTNAME=phase_accl_to_duty_cycle_test | tee sim.log
mv sim.log SIMULATION_LOGS/phase_accl_to_duty_cycle_test.log

./simv top.sv +UVM_TESTNAME=phase_change_dirn_test | tee sim.log
mv sim.log SIMULATION_LOGS/phase_change_dirn_test.log

./simv top.sv +UVM_TESTNAME=phase_lower_spd_2_zero_test | tee sim.log
mv sim.log SIMULATION_LOGS/phase_lower_spd_2_zero_test.log

./simv top.sv +UVM_TESTNAME=phase_speedup_wo_accln_test | tee sim.log
mv sim.log SIMULATION_LOGS/phase_speedup_wo_accln_test.log

./simv top.sv +UVM_TESTNAME=phase_startup_w_accln_test | tee sim.log
mv sim.log SIMULATION_LOGS/phase_startup_w_accln_test.log
