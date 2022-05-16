class phase_agent extends uvm_agent;
`uvm_component_utils(phase_agent)

get_speed speed;

phase_monitor phase_mon;
pwm_scoreboard pwm_U_sb;
pwm_scoreboard pwm_V_sb;
pwm_scoreboard pwm_W_sb;
dir_scoreboard dir_sb;
phase_driver phase_drv;
phase_seqr phase_sqr;
phase_table tb_U;
phase_table tb_V;
phase_table tb_W;
phase_FETs phase_FETs_U;
phase_FETs phase_FETs_V;
phase_FETs phase_FETs_W;
FG_output FG;



function new(string name="phase_agent", uvm_component parent = null);
    super.new(name,parent);
endfunction: new


virtual function void build_phase (uvm_phase phase);
    speed = get_speed::type_id::create("speed", this);
    
    phase_mon = phase_monitor::type_id::create("phase_monitor", this);
    pwm_U_sb = pwm_scoreboard::type_id::create("pwm_U_scoreboard", this);
    pwm_V_sb = pwm_scoreboard::type_id::create("pwm_V_scoreboard", this);
    pwm_W_sb = pwm_scoreboard::type_id::create("pwm_W_scoreboard", this);

    dir_sb = dir_scoreboard::type_id::create("dir_scoreboard", this);

    FG = FG_output::type_id::create("FG", this);
    tb_U = phase_table::type_id::create("tb_U", this);
    tb_V = phase_table::type_id::create("tb_V", this);
    tb_W = phase_table::type_id::create("tb_W", this);
    phase_drv = phase_driver::type_id::create("phase_drv", this);
    phase_sqr = phase_seqr::type_id::create("phase_sqr", this);
    tb_U.offset = 0;
    tb_V.offset = 200;
    tb_W.offset = 400;
    tb_U.FG_lookup = 1;
   
    phase_FETs_U = phase_FETs::type_id::create("phase_FETs_U", this);
    phase_FETs_V = phase_FETs::type_id::create("phase_FETs_V", this);
    phase_FETs_W = phase_FETs::type_id::create("phase_FETs_W", this);
    phase_FETs_U.which_phase = 2'b00;
    phase_FETs_V.which_phase = 2'b01;
    phase_FETs_W.which_phase = 2'b10;

    tb_U.which_phase = 2'b00;
    tb_V.which_phase = 2'b01;
    tb_W.which_phase = 2'b10;
endfunction


virtual function void connect_phase(uvm_phase phase);
    phase_mon.phaseU_port.connect(pwm_U_sb.message_imp);
    phase_mon.phaseV_port.connect(pwm_V_sb.message_imp);
    phase_mon.phaseW_port.connect(pwm_W_sb.message_imp);

    tb_U.val_port.connect(pwm_U_sb.counter_imp);
    tb_V.val_port.connect(pwm_V_sb.counter_imp);
    tb_W.val_port.connect(pwm_W_sb.counter_imp);

    tb_U.counter_port.connect(dir_sb.U_fifo.analysis_export);
    tb_V.counter_port.connect(dir_sb.V_fifo.analysis_export);
    tb_W.counter_port.connect(dir_sb.W_fifo.analysis_export);

    tb_U.FG_port.connect(FG.message_imp);
    speed.speed_port.connect(tb_U.speed_imp);
    speed.speed_port.connect(tb_V.speed_imp);
    speed.speed_port.connect(tb_W.speed_imp);
    phase_drv.update_port.connect(speed.updated_imp);
    phase_drv.dir_port.connect(tb_U.dir_imp);
    phase_drv.dir_port.connect(tb_V.dir_imp);
    phase_drv.dir_port.connect(tb_W.dir_imp);
    phase_drv.seq_item_port.connect(phase_sqr.seq_item_export);
    tb_U.val_port.connect(phase_FETs_U.message_imp);
    tb_V.val_port.connect(phase_FETs_V.message_imp);
    tb_W.val_port.connect(phase_FETs_W.message_imp);
endfunction

endclass