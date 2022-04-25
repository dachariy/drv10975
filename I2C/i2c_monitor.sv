// Class : I2C Monitor

`ifndef I2C_MONITOR
`define I2C_MONITOR

class i2c_monitor extends uvm_monitor; 

  typedef enum {ST_START, ST_SLAVE_ADDRESS, ST_ACK, ST_REG_ADDRESS, ST_DATA, ST_STOP} state_e;

  virtual i2c_if mon_vif;

  i2c_item packet;
  
  drv10975_register_map register_map;
  
  uvm_analysis_port #(i2c_item) mon_ap;
  
  bit is_master;
  bit ack0_nack1;

  state_e prev_state, next_state, curr_state;

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
    super.run_phase(phase);

    forever 
    begin
      case(curr_state)
        ST_START: 
          begin
            @ (posedge mon_vif.SCL);
            while (mon_vif.SCL == 1) 
            begin
              @(negedge mon_vif.SDA);
              packet = new();
              next_state = ST_SLAVE_ADDRESS;
            end
          end
        ST_SLAVE_ADDRESS: 
          begin
            for(int indx = $size(packet.slave_address) - 1; indx >= 0; indx++)
              begin
                @(posedge mon_vif.SCL);
                packet.slave_address[indx] = mon_vif.SDA;
              end
             
            //Wr_Rd
            @(posedge mon_vif.SCL);
            packet.wr_rd = mon_vif.SDA;

            if(packet.slave_address != `I2C_SLAVE_ADDRESS) 
            begin
              `uvm_error(get_full_name(), $sformatf("Invalid Slave Address detected. Driven Slave Address : %7h | Expected : %7h", packet.slave_address, `I2C_SLAVE_ADDRESS))  
            end

            next_state = ST_ACK;
          end
        ST_ACK: 
          begin
            @(posedge mon_vif.SCL);
            ack0_nack1 = mon_vif.SDA;

            case(prev_state)
              ST_SLAVE_ADDRESS : 
                begin
                  // Check if ACK Driven for Invalid Address
                  if((ack0_nack1 == 0) && (packet.slave_address != `I2C_SLAVE_ADDRESS))      
                  begin
                    `uvm_error(get_full_name(), "ACK recieved for invalid SLave Address")
                    next_state = ST_REG_ADDRESS;
                  end
                  else if((ack0_nack1 == 1) && (packet.slave_address == `I2C_SLAVE_ADDRESS))
                  begin
                    `uvm_error(get_full_name(), "NACK driven for Valid Slave Address")
                    next_state = ST_START;
                  end
                end
              ST_REG_ADDRESS:
                begin
                  // ACK for Wr on RO register
                  if(ack0_nack1 == 0 && packet.wr_rd == 1 &&  (packet.reg_address inside {[`STATUS : `SPDCMDBUFFER], `FAULTCODE})) 
                  begin
                    `uvm_error(get_full_name(), "ACK driven for register Write attempt on READ-ONLY Register");
                    next_state = ST_DATA;
                  end
                  else
                  begin
                    next_state = ST_START;
                  end
                end
              ST_DATA:
                begin
                  next_state = ST_STOP;
                end
            endcase
          end
        ST_REG_ADDRESS: 
          begin
            for(int indx = $size(packet.reg_address) - 1; indx >= 0; indx++)
            begin
              @(posedge mon_vif.SCL);
              packet.reg_address[indx] = mon_vif.SDA;
            end
            
             if(packet.wr_rd == 1 && packet.reg_address inside {[`STATUS : `SPDCMDBUFFER], `FAULTCODE}) 
             begin
               `uvm_error(get_full_name(), "Register Write attempt on READ-ONLY Register");
             end
            next_state = ST_ACK;
          end
        ST_DATA: 
          begin
            for(int indx = $size(packet.data) - 1; indx >= 0; indx++)
            begin
              @(posedge mon_vif.SCL);
              packet.slave_address[indx] = mon_vif.SDA;
            end
            
            next_state = ST_ACK;

          end
        ST_STOP:
          begin
            while (mon_vif.SCL == 1) 
            begin
              @(posedge mon_vif.SDA);
              mon_ap.write(packet);
              next_state = ST_START;
            end
          end
      endcase

      prev_state = curr_state;
      curr_state = next_state;
    end

  endtask: run_phase

endclass : i2c_monitor

`endif

