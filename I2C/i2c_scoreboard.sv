// I2C Scoreboard
`ifndef I2C_SCOREBOARD
`define I2C_SCOREBOARD

typedef class drv10975_register_map; 

class i2c_scoreboard extends uvm_scoreboard;

  drv10975_register_map register_map;

  `uvm_component_utils_begin(i2c_scoreboard)
    `uvm_field_object(register_map, UVM_DEFAULT)
  `uvm_component_utils_end

  uvm_analysis_imp #(i2c_item, i2c_scoreboard) ap_imp;

  function new(string name = "i2c_scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);

    super.build_phase(phase);
    ap_imp = new("ap_imp", this);

    if(!uvm_config_db #(drv10975_register_map)::get(this, "*", "register_map", register_map))
    begin
      `uvm_fatal(get_type_name(), "Cant Fetch register_map from config_db")
    end
    
  endfunction : build_phase

  function void write(i2c_item packet);
    bit reg_access;
    bit [7:0] reg_data;

    reg_access = register_map.reg_read(.reg_addr(packet.reg_address), .reg_data(reg_data));

    //Ignore Invalid fields
    case(packet.reg_address)
      `SPEEDCTRL2 :    packet.data[6:1] = 0;
      `EECTRL :        packet.data[4:0] = 0;
      `STATUS :        packet.data[3:0] = 0;
      `MOTORCURRENT1 : packet.data[7:3] = 0;
      `FAULTCODE :     packet.data[7:6] = 0;
      `SYSOPT6 :       packet.data[0:0] = 0;   
    endcase

    if(reg_data != packet.data)
    begin
      `uvm_error("i2c_scb_data_mismatch", $sformatf("Register data mismatch. Expected = %0h | In Reg_MAP =%0h", packet.data, reg_data ))
    end
    else
    begin
      `uvm_info(get_full_name(), $sformatf("Register data match. Expected = %0h | In Reg_MAP =%0h", packet.data, reg_data ), UVM_HIGH)
    end
      
  endfunction : write

endclass : i2c_scoreboard

`endif

