#!/bin/bash
rm -rf SIMULATION_LOGS
mkdir SIMULATION_LOGS

./sv_uvm top.sv
mv sim.log SIMULATION_LOGS/compile_test.log

./simv top.sv +UVM_TESTNAME=i2c_sanity_read_test | tee sim.log
mv sim.log SIMULATION_LOGS/i2c_sanity_read_test.log

./simv top.sv +UVM_TESTNAME=i2c_wrong_slv_addr_item | tee sim.log
mv sim.log SIMULATION_LOGS/i2c_wrong_slv_addr_item.log

./simv top.sv +UVM_TESTNAME=i2c_invalid_reg_addr_test | tee sim.log
mv sim.log SIMULATION_LOGS/i2c_invalid_reg_addr_test.log

