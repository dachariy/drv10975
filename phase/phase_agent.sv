class phase_agent extends uvm_agent;
`uvm_component_utils(phase_agent)

get_speed speed;
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
    
    
    //FG = FG_output::type_id::create("FG", this);
    tb_U = phase_table::type_id::create("tb_U", this);
    tb_V = phase_table::type_id::create("tb_V", this);
    tb_W = phase_table::type_id::create("tb_W", this);
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

    
endfunction


virtual function void connect_phase(uvm_phase phase);
    //tb_U.FG_port.connect(FG.message_imp);
    //speed.speed_port.connect(tb_U.speed_imp);
    //speed.speed_port.connect(tb_V.speed_imp);
    //speed.speed_port.connect(tb_W.speed_imp);

    tb_U.val_port.connect(phase_FETs_U.message_imp);
    tb_V.val_port.connect(phase_FETs_V.message_imp);
    tb_W.val_port.connect(phase_FETs_W.message_imp);
endfunction

endclass