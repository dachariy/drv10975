class threshold_scoreboard extends uvm_scoreboard;
`uvm_component_utils(threshold_scoreboard)

function new(string name = "threshold_scoreboard", uvm_component parent);
    super.new(name, parent);
endfunction

virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction

virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);

endtask

endclass


`uvm_analysis_imp_decl(_port_table)
`uvm_analysis_imp_decl(_port_mon)

class pwm_scoreboard extends uvm_scoreboard;
`uvm_component_utils(pwm_scoreboard)

uvm_analysis_imp_port_table #(realtime, pwm_scoreboard) counter_imp;
uvm_analysis_imp_port_mon #(string, pwm_scoreboard) message_imp;
realtime time_begin, time_end, period, time_diff, expected_val;
bit is_dut;

function new(string name = "pwm_scoreboard", uvm_component parent);
    super.new(name, parent);
endfunction

virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(bit)::get(this, "*", "is_dut", is_dut))
        begin
        `uvm_fatal(get_full_name(), "Cant fetch is_dut from config_db")
        end
    period = 40000;
    message_imp = new("message_imp", this);
    counter_imp = new("counter_imp", this);
endfunction

virtual function void write_port_table(realtime val);
    expected_val = val;
endfunction

virtual function void write_port_mon(string val);
    if (val == "high") begin
        time_begin = $realtime;
    end

    else if (val == "low") begin
        time_end = $realtime;
        time_diff = time_end - time_begin;
        if (is_dut) begin
        if ((time_diff < (expected_val * period * 1.05)) && (time_diff > (expected_val * period*0.95))) begin
            `uvm_info("PWM_Output", $sformatf("PWM Output Expected, Duty Cycle: %f", expected_val), UVM_HIGH)
        end
        else if (time_diff < 0.00001 && expected_val == 0)
            `uvm_info("PWM_Output", $sformatf("PWM Output Expected, Duty Cycle: %f", expected_val), UVM_HIGH)
        else
            `uvm_error("phase_pwm_bad_duty", $sformatf("PWM Duty Cycle incorrect. Expected = %f, Received = %f", expected_val, (time_end-time_begin)/period))
        end
    end
endfunction
endclass


class dir_scoreboard extends uvm_scoreboard;
`uvm_component_utils(dir_scoreboard)

int counter_U;
int counter_V;
int counter_W;

int inter;

virtual phase_if phase_vif;

uvm_tlm_analysis_fifo #(int) U_fifo;
uvm_tlm_analysis_fifo #(int) V_fifo;
uvm_tlm_analysis_fifo #(int) W_fifo;

realtime time_begin, time_end, period, time_diff, expected_val;
bit is_dut;

function new(string name = "pwm_scoreboard", uvm_component parent);
    super.new(name, parent);
endfunction

virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(bit)::get(this, "*", "is_dut", is_dut))
    begin
        `uvm_fatal(get_full_name(), "Cant fetch is_dut from config_db")
    end
    if(!(uvm_config_db #(virtual phase_if)::get(this, "*", "phase_vif", phase_vif)))
    begin
        `uvm_fatal(get_type_name, "Cant fetch drv_if from config_db")
    end

    U_fifo = new ("U_fifo", this);
    V_fifo = new ("V_fifo", this);
    W_fifo = new ("W_fifo", this);
endfunction

virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    U_fifo.get(counter_U);
    V_fifo.get(counter_V);
    W_fifo.get(counter_W);

    if (phase_vif.DIR == 1) begin
        if ((counter_U + 200) > 600) begin
            inter = counter_U - 400;
        end
        else begin
            inter = counter_U + 200;
        end

        if (counter_V == inter) begin
            `uvm_info("Direction", $sformatf("Phases aligned with direction"), UVM_HIGH)
        end
        else begin
            `uvm_error("Direction", $sformatf("Phases not aligned with direction U: %d, V: %d, W: %d", counter_U, counter_V, counter_W))
        end
    end

    if (phase_vif.DIR == 0) begin
        if ((counter_U + 200) > 600) begin
            inter = counter_U - 400;
        end
        else begin
            inter = counter_U + 200;
        end

        if (counter_W == inter) begin
            `uvm_info("Direction", $sformatf("Phases aligned with direction"), UVM_HIGH)
        end
        else begin
            `uvm_info("Direction", $sformatf("Phases not aligned with direction"), UVM_HIGH)
        end
    end
endtask
endclass