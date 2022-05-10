class phase_monitor extends uvm_monitor; 
virtual phase_if phase_vif;
drv10975_register_map register_map;
  
uvm_analysis_port #(reg) phaseU_port;
uvm_analysis_port #(reg) phaseV_port;
uvm_analysis_port #(reg) phaseW_port;
uvm_analysis_port #(reg) phaseFG_port;

//Constructor 
function new(string name = "monitor", uvm_component parent = null);
    super.new(name, parent);
endfunction : new 

  //Build Phase
virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if(!(uvm_config_db #(virtual phase_if)::get(this, "*", "phase_vif", phase_vif)))
    begin
      `uvm_fatal(get_type_name, "Cant fetch mon_if from config_db")
    end

    if(!uvm_config_db #(drv10975_register_map)::get(this, "*", "register_map", register_map))
    begin
      `uvm_fatal(get_type_name(), "Cant Fetch register_map from config_db")
    end
endfunction : build_phase

  //Connect Phase
virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
endfunction : connect_phase

  //Run Phase
virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    fork 
    begin
        forever begin
            @(phase_vif.U);
            phaseU_port.write(phase_vif.U);
        end
    end
    
    begin
        forever begin
            @(phase_vif.V);
            phaseV_port.write(phase_vif.V);
        end
    end

    begin
        forever begin
            @(phase_vif.W);
            phaseW_port.write(phase_vif.W);
        end
    end

    begin
        forever begin
            @(phase_vif.FG);
            phaseFG_port.write(phase_vif.FG);
        end
    end
    join_none

endtask: run_phase

endclass

