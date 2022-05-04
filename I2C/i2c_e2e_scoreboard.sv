// I2C Scoreboard
`ifndef I2C_E2E_SCOREBOARD
`define I2C_E2E_SCOREBOARD

class i2c_e2e_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(i2c_e2e_scoreboard)

  uvm_tlm_analysis_fifo #(i2c_item) dut_fifo;
  uvm_tlm_analysis_fifo #(i2c_item) tb_fifo;

  function new(string name = "i2c_e2e_scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    dut_fifo = new("dut_fifo", this);
    tb_fifo = new("tb_fifo", this);
  endfunction : build_phase

  task run_phase (uvm_phase phase);

    i2c_item dut_pkt;
    i2c_item tb_pkt;

    super.run_phase(phase);

    forever
    begin
      fork
        dut_fifo.get(dut_pkt);
        tb_fifo.get(tb_pkt);
      join

      if(dut_pkt.compare(tb_pkt))
      begin
        `uvm_info(get_full_name(), "DUT and TB I2C packets match", UVM_HIGH)
      end
      else
      begin
        `uvm_error("i2c_e2e_scbd_mismatch", "DUT and TB I2C packets mismatch")
      end
    end
      
  endtask: run_phase

endclass : i2c_e2e_scoreboard

`endif

