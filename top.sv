`timescale 1ns/100ps

`include "I2C/i2c_defines.svh"
`include "I2C/i2c_if.sv"
`include "phase/phase_if.sv"
`include "drv10975_pkg.sv"

module top();
  import uvm_pkg::*;
  import drv10975_pkg::*;

  bit ref_clk;
  
  // Interface instance
  i2c_if i2c_vif(ref_clk);

  phase_if phase_vif();

  initial
  begin
    ref_clk = 0;
    forever #(`I2C_CLK_PERIOD_US/2 * 1000) ref_clk = ~ref_clk;
  end

  initial 
  begin
    uvm_config_db #(virtual i2c_if)::set(null, "*", "i2c_vif", i2c_vif);
    uvm_config_db #(virtual phase_if)::set(null, "*", "phase_vif", phase_vif);
    run_test("drv10975_base_test");
  end

  //Wavedump
  initial
  begin
   if($test$plusargs("WAVE"))
   begin
     $dumpfile("waves.vcd");
     $dumpvars;
   end
  end

  initial
  begin
   if($test$plusargs("TIMEOUT"))
   begin
    #200ms;
    $finish;
   end
  end

endmodule : top

