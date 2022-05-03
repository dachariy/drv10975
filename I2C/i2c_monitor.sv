// Class : I2C Monitor

`ifndef I2C_MONITOR
`define I2C_MONITOR

class i2c_monitor extends uvm_monitor; 

  typedef enum {ST_START, ST_SLAVE_ADDRESS, ST_REG_ADDRESS, ST_DATA, ST_STOP} state_e;

  virtual i2c_if mon_vif;

  i2c_item packet;
  
  drv10975_register_map register_map;
  
  uvm_analysis_port #(i2c_item) mon_ap;
  
  bit is_master;
  bit ack0_nack1;
  bit [7:0] data;

  state_e next_state, curr_state;

  // UVM Utility Macro
  `uvm_component_utils_begin(i2c_monitor)
    `uvm_field_int(is_master, UVM_ALL_ON)
    `uvm_field_object(register_map, UVM_ALL_ON | UVM_NOPRINT)
  `uvm_component_utils_end

  //Constructor 
  function new(string name = "monitor", uvm_component parent = null);
    super.new(name, parent);

    curr_state = ST_START;
    next_state = ST_START;
  endfunction : new 

  //Build Phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if(!(uvm_config_db #(virtual i2c_if)::get(this, "*", "i2c_vif", mon_vif)))
    begin
      `uvm_fatal(get_type_name, "Cant fetch mon_if from config_db")
    end

    if(!uvm_config_db #(drv10975_register_map)::get(this, "*", "register_map", register_map))
    begin
      `uvm_fatal(get_type_name(), "Cant Fetch register_map from config_db")
    end
    
    
    mon_ap = new("mon_ap", this);

    if(uvm_config_db #(bit)::get(this, "*", "is_master", is_master))
    begin
      if(is_master)
        `uvm_info(get_type_name, "Monitor Configured as I2C_MASTER", UVM_LOW)
      else
        `uvm_info(get_type_name, "Monitor Configured as I2C_SLAVE", UVM_LOW)
    end
    else
    begin
        `uvm_warning(get_type_name, "Cant fetch is_master from config_db, configuring as I2C Slave")
    end
  endfunction : build_phase

  //Connect Phase
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction : connect_phase

  //Run Phase
  virtual task run_phase(uvm_phase phase);
    
    bit [9:0] start_scl;
    bit [9:0] start_sda;
    bit [9:0] stop_scl;
    bit [9:0] stop_sda;

    super.run_phase(phase);
    
    // Continuously check for start stop
    fork
      begin
        forever
        begin
          @(mon_vif.ref_clk);

          start_scl = start_scl << 1;
          start_scl[0] = mon_vif.SCL;

          start_sda = start_sda << 1;
          start_sda[0] = mon_vif.SDA;

          if(start_sda == 10'b1_1111__0_0000 && start_scl == 10'b11_1111_1111)
          begin
            if(curr_state != ST_START)
            begin
              `uvm_error("i2c_invalid_start_position", $sformatf("I2C start detected while expecting %s", curr_state.name()))
            end
            next_state = ST_SLAVE_ADDRESS;
          end
        end
      end
      begin
        forever
        begin
          @(mon_vif.ref_clk);

          stop_scl = stop_scl << 1;
          stop_scl[0] = mon_vif.SCL;

          stop_sda = stop_sda << 1;
          stop_sda[0] = mon_vif.SDA;

          if(stop_sda == 10'b0_0000__1_1111 && start_scl == 10'b11_1111_1111)
          begin
            if(curr_state != ST_STOP)
            begin
              `uvm_error("i2c_invalid_stop_position", $sformatf("I2C stop detected while expecting %s", curr_state.name()))
            end
            next_state = ST_START;
          end
        end
      end
    join_none

    forever
    begin

      `uvm_info(get_full_name(), $sformatf("Current_State = %s", curr_state.name()), UVM_HIGH)
      
      case(curr_state)
        ST_START: 
          begin
            @(next_state);
            packet = new("packet");
          end
        ST_SLAVE_ADDRESS: 
          begin
            for(int indx = $size(packet.slave_address) - 1; indx >= 0; indx--)
            begin
              @(posedge mon_vif.SCL);
              packet.slave_address[indx] = mon_vif.SDA;
            end

            if(packet.slave_address != `I2C_SLAVE_ADDRESS)
            begin
              `uvm_error("i2c_invalid_slv_addr", $sformatf("Slave address %0h recieved while expecting %0h", packet.slave_address, `I2C_SLAVE_ADDRESS))
            end
            else
            begin
              `uvm_info(get_full_name(), $sformatf("Slave_Address = %0h", packet.slave_address), UVM_HIGH)
            end
            
            // WR_RD
            @(posedge mon_vif.SCL);
            packet.wr_rd = i2c_item::action_e'(mon_vif.SDA);

            `uvm_info(get_full_name(), $sformatf("WR_RD = %s", packet.wr_rd.name()), UVM_HIGH)

            // ACK/NACK 
            @(posedge mon_vif.SCL);
            ack0_nack1 = mon_vif.SDA;

            // Check ACK/NACK
            if(ack0_nack1 == 0 && packet.slave_address != `I2C_SLAVE_ADDRESS)
            begin
              `uvm_error("i2c_ack_invalid_slv_addr", $sformatf("ACK driven for invalid Slave address %0h", packet.slave_address))
              next_state = ST_REG_ADDRESS;
            end
            else if(ack0_nack1 == 1 && packet.slave_address == `I2C_SLAVE_ADDRESS)
            begin
              `uvm_error("i2c_nack_valid_slv_addr", $sformatf("NACK driven for valid Slave address %0h", packet.slave_address))
              next_state = ST_STOP;
            end
            else if(ack0_nack1 == 0 && packet.slave_address == `I2C_SLAVE_ADDRESS)
            begin
              `uvm_info(get_full_name(), $sformatf("ACK driven for Slave Address"), UVM_HIGH)
              next_state = ST_REG_ADDRESS;
            end
            else 
            begin
              `uvm_info(get_full_name(), $sformatf("NACK driven for invalid Slave Address"), UVM_HIGH)
              next_state = ST_STOP;
            end
          end
        ST_REG_ADDRESS:
          begin
            for(int indx = $size(packet.reg_address) - 1; indx >= 0; indx--)
            begin
              @(posedge mon_vif.ref_clk);
              packet.reg_address[indx] = mon_vif.SDA;
            end
              
            `uvm_info(get_full_name(), $sformatf("Reg_Address = %0h", packet.reg_address), UVM_HIGH)

            // Read the reg to check if reg exit
            // For Write rewrite the same value
            ack0_nack1 = ~(register_map.reg_read(.reg_addr(packet.reg_address), .reg_data(packet.data)));

            if(ack0_nack1 == 1)
            begin
              `uvm_error("i2c_invalid_reg_addr", $sformatf("Invalid Register address %0h", packet.reg_address))
            end

            if(packet.wr_rd == i2c_item::WRITE)
            begin
              ack0_nack1 = ~(register_map.reg_write(.reg_addr(packet.reg_address), .reg_data(packet.data)));
            end

            if(ack0_nack1 == 1)
            begin
              `uvm_error("i2c_invalid_reg_addr", $sformatf("Write attempt on RO Register address %0h", packet.reg_address))
            end

            //ACK/NACK on next posedge
            @(posedge mon_vif.SCL);

            // Check ACK/NACK
            if(ack0_nack1 == 0 && ack0_nack1 == mon_vif.SDA)
            begin
              next_state = ST_DATA;
              `uvm_info(get_full_name(), $sformatf("ACK driven for Reg Address %0h", packet.reg_address), UVM_HIGH)
            end
            else if(ack0_nack1 == 1 && ack0_nack1 == mon_vif.SDA)
            begin
              `uvm_info(get_full_name(), $sformatf("ACK driven for Reg Address %0h", packet.reg_address), UVM_HIGH)
              next_state = ST_STOP;
            end
            else if(ack0_nack1 == 0 && ack0_nack1 != mon_vif.SDA)
            begin
              `uvm_error("i2c_invalid_ack_reg_addr", $sformatf("ACK driven for Reg address %0h, while NACK was expected", packet.reg_address))
              next_state = ST_DATA;
            end
            else if(ack0_nack1 != 0 && ack0_nack1 != mon_vif.SDA)
            begin
              `uvm_error("i2c_invalid_nack_reg_addr", $sformatf("NACK driven for Reg address %0h, while ACK was expected", packet.reg_address))
              next_state = ST_STOP;
            end
          end
        ST_DATA: 
          begin
            for(int indx = $size(packet.data) - 1; indx >= 0; indx--)
            begin
              @(posedge mon_vif.ref_clk);
              packet.data[indx] = mon_vif.SDA;
            end

            //Sample ACK/NACK
            @(posedge mon_vif.SCL);
            ack0_nack1 = mon_vif.SDA;
              
            next_state = ST_STOP;

            if(ack0_nack1 == 0)
            begin
              `uvm_info(get_full_name(), $sformatf("ACK driven for Data"), UVM_HIGH)
            end
            else
            begin
              `uvm_error("i2c_nack_data", $sformatf("NACK driven for Data"))
            end
          end
        ST_STOP:
          begin
            @(next_state);
            mon_ap.write(packet);
          end
        default:
          begin
            next_state = ST_START;
            `uvm_error(get_full_name(), "Invalid State detected, Moving to START")
          end
      endcase

      curr_state = next_state;
    end
  endtask: run_phase

endclass : i2c_monitor

`endif

