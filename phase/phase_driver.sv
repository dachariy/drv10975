typedef class drv10975_register_map; 

class phase_driver extends uvm_driver # (phase_item);
`uvm_component_utils(phase_driver)

virtual phase_if phase_vif;

drv10975_register_map register_map;
phase_item data_obj;
reg [7:0] data;

//Constructor     
function new(string name = "driver", uvm_component parent = null);
    super.new(name, parent);

endfunction : new 

//Build Phase
virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!(uvm_config_db #(virtual phase_if)::get(this, "*", "phase_vif", phase_vif)))
    begin
      `uvm_fatal(get_type_name, "Cant fetch drv_if from config_db")
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

    forever begin
        seq_item_port.get_next_item(data_obj);
        register_map.reg_write(.reg_addr(8'h1B), .reg_data(data_obj.desired_speed));
        register_map.reg_read(.reg_addr(8'h2B), .reg_data(data));
        register_map.reg_write(.reg_addr(8'h2B), .reg_data({data_obj.FGOLsel, data_obj.FGcycle, data[3:0]}));
        seq_item_port.item_done();
    end
endtask: run_phase


endclass
