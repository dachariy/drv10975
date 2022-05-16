class phase_monitor extends uvm_monitor; 
`uvm_component_utils(phase_monitor);
virtual phase_if phase_vif;
drv10975_register_map register_map;
  
uvm_analysis_port #(string) phaseU_port;
uvm_analysis_port #(string) phaseV_port;
uvm_analysis_port #(string) phaseW_port;
uvm_analysis_port #(string) phaseFG_port;
uvm_analysis_port #(string) dir_port;

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

    phaseFG_port = new("phaseFG_port", this);
    phaseU_port = new("phaseU_port", this);
    phaseV_port = new("phaseV_port", this);
    phaseW_port = new("phaseW_port", this);
    dir_port = new("dir_port", this);
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
            @(phase_vif.U) begin
                //$display("Writing to Phase U");
                if (phase_vif.U == 1)
                    phaseU_port.write("high");
                else
                    phaseU_port.write("low");
            end
        end
    end
    
    begin
        forever begin
            @(phase_vif.V) begin
                if (phase_vif.V == 1)
                    phaseV_port.write("high");
                else
                    phaseV_port.write("low");
            end
        end
    end

    begin
        forever begin
            @(phase_vif.W) begin
                if (phase_vif.W == 1)
                    phaseW_port.write("high");
                else
                    phaseW_port.write("low");
            end
        end
    end
    
    begin
        forever begin
            @(phase_vif.DIR) begin
                if (phase_vif.DIR == 1)
                    dir_port.write("high");
                else
                    dir_port.write("low");
            end
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

