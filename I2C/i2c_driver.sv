// Class : I2C Driver 

`ifndef I2C_DRIVER
`define I2C_DRIVER

typedef class drv10975_register_map; 

class i2c_driver extends uvm_driver # (i2c_item);

  //Enum for States
  typedef enum {IDLE, DRV_START, RCV_START, DRV_SLAVE_ADDRESS, RCV_SLAVE_ADDRESS, DRV_REG_ADDRESS, RCV_REG_ADDRESS, DRV_DATA, RCV_DATA, RCV_ACK, DRV_ACK, DRV_STOP} state_e;

  //Virtual Interface instance
  virtual i2c_if drv_vif;
  
  i2c_item packet;
  drv10975_register_map register_map;

  bit is_master;
  state_e prev_state, curr_state, next_state;

  bit ack0_nack1;
  bit [7:0] reg_data;

  // UVM Utility Macro
  `uvm_component_utils_begin(i2c_driver)
    `uvm_field_int(is_master, UVM_ALL_ON)
    `uvm_field_object(register_map, UVM_ALL_ON | UVM_NOPRINT)
  `uvm_component_utils_end

  //Constructor     
  function new(string name = "driver", uvm_component parent = null);
        super.new(name, parent);

  endfunction : new 

  //Build Phase
  virtual function void build_phase(uvm_phase phase);
    
    super.build_phase(phase);
    
    if(!(uvm_config_db #(virtual i2c_if)::get(this, "*", "i2c_vif", drv_vif)))
    begin
      `uvm_fatal(get_type_name, "Cant fetch drv_if from config_db")
    end

    if(!uvm_config_db #(drv10975_register_map)::get(this, "*", "register_map", register_map))
    begin
      `uvm_fatal(get_type_name(), "Cant Fetch register_map from config_db")
    end
    
    if(uvm_config_db #(bit)::get(this, "*", "is_master", is_master))
    begin
      if(is_master)
        `uvm_info(get_type_name, "Driver Configured as I2C_MASTER", UVM_LOW)
      else
        `uvm_info(get_type_name, "Driver Configured as I2C_SLAVE", UVM_LOW)
    end
    else
    begin
        `uvm_fatal(get_type_name, "Cant fetch is_master from config_db, configuring as I2C Slave")
    end

    curr_state = is_master ? IDLE : RCV_START;
    next_state = is_master ? IDLE : RCV_START;
  endfunction : build_phase

  //Connect Phase
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction : connect_phase

  //Run Phase
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);

    if(is_master == 1)
    begin
      // IDLE -> DRV_START -> DRV_SLAVE ADDRESS -> DRV_REG_ADD -> DRV_DATA/RCV_DATA -> DRV_STOP -> IDLE
      forever
      begin
        case(curr_state)
          IDLE:  
            begin
              //Master is the initiator.
              //Stay in IDLE till able to fetch a new Sequence.
              drv_vif.SCL = 1;
              seq_item_port.get_next_item(packet);
              next_state = DRV_START;
            end
          DRV_START: 
            begin
              // I2C start : 
              // SCL  -------
              // SDA  ---\___
              @(negedge drv_vif.ref_clk);
              drv_vif.SDA = 0;

              #(`I2C_DELAY)
              
              //ALways release SDA after driving
              drv_vif.SDA = 'z;
              drv_vif.SCL = drv_vif.ref_clk;
              next_state = DRV_SLAVE_ADDRESS; 
            end
          DRV_SLAVE_ADDRESS: 
            begin
              for(int indx = $size(packet.slave_address) - 1; indx >= 0; indx++)
              begin
               @(negedge drv_vif.ref_clk);
               drv_vif.SDA = packet.slave_address[indx];
              end
              
              // Release SDA so that Slave can drive ACK
              drv_vif.SDA = 'z;
              next_state = RCV_ACK; 
            end
          DRV_REG_ADDRESS: 
            begin
              for(int indx = $size(packet.reg_address) - 1; indx >= 0; indx++)
              begin
               @(negedge drv_vif.ref_clk);
               drv_vif.SDA = packet.reg_address[indx];
              end
              
              // Release SDA so that Slave can drive ACK
              drv_vif.SDA = 'z;
              next_state = RCV_ACK; 
            end
          DRV_DATA: 
            begin
              for(int indx = $size(packet.data) - 1; indx >= 0; indx++)
              begin
               @(negedge drv_vif.ref_clk);
               drv_vif.SDA = packet.data[indx];
              end

              // Release SDA so that Slave can drive ACK
              drv_vif.SDA = 'z;
              next_state = RCV_ACK; 
            end
          RCV_DATA: 
            begin
              // Will Only RCV data if Slave ACK
              for(int indx = $size(packet.reg_address) - 1; indx >= 0; indx++)
              begin
               @(posedge drv_vif.SCL);
               packet.data[indx] = drv_vif.SDA;
              end

              next_state = DRV_ACK;
            end
          RCV_ACK: 
            begin
              @(posedge drv_vif.SCL);
              ack0_nack1 = drv_vif.SDA;

              // ACK = 0 / NACK = 1
              if(ack0_nack1 == 1)
                next_state = IDLE;
              else
              begin
                case(prev_state)
                   DRV_SLAVE_ADDRESS : next_state = DRV_REG_ADDRESS; 
                   DRV_REG_ADDRESS : next_state = (packet.wr_rd) ? DRV_DATA : RCV_DATA;
                   DRV_DATA : next_state = DRV_STOP;
                   default : 
                     begin
                       `uvm_error(get_full_name(), "Invalid State detected, Moving to IDLE")
                       next_state = IDLE;
                     end
                endcase
              end
            end
          DRV_ACK:
            begin
              // Master drives ACK only on receiving data
              @(negedge drv_vif.SCL);
              drv_vif.SDA = 1;

              @(negedge drv_vif.SCL);
              drv_vif.SDA = 'z;
              
              next_state = DRV_STOP;
            end
          DRV_STOP:
            begin
              // I2C Stop:
              // SCL  __/------
              // SDA  ____/----

              @(posedge drv_vif.ref_clk);
              drv_vif.SDA = 0;
              drv_vif.SCL = 1;
              
              #(`I2C_DELAY);

              drv_vif.SDA = 'z;
              
              next_state = IDLE; 
              seq_item_port.item_done();
            end
          default:
            begin
              next_state = IDLE;
              `uvm_error(get_full_name(), "Invalid State detected, Moving to IDLE")
            end
        endcase
        
        prev_state = curr_state;
        curr_state = next_state;
      end
    end
    else
    begin
      // Detect Start -> RCV_SLAVE_ADDRESS -> RCV_REG_ADD -> DRV/RCV_DATA -> Detect_Start
      forever
      begin
        case(curr_state)
          RCV_START: 
            begin
              @(posedge drv_vif.SCL);
              while(drv_vif.SCL == 1)
              begin
                @(negedge drv_vif.SDA);
                packet = new();
                packet.device =  i2c_item::SLAVE;
                next_state = RCV_SLAVE_ADDRESS;
              end
            end
          RCV_SLAVE_ADDRESS:
            begin
              for(int indx = $size(packet.slave_address); indx >= 0; indx++)
              begin
                @(posedge drv_vif.SCL);
                packet.slave_address[indx] = drv_vif.SDA;
              end
             
              //Wr_Rd
              @(posedge drv_vif.SCL);
              packet.wr_rd = drv_vif.SDA;

              // If Slave address matches drive ACK
              // Else ignore and restart detecting Start
              //
              // Default SDA is 1 so Master will recieve NACK if only 1 slave
              if(packet.wr_rd == `I2C_SLAVE_ADDRESS)
              begin
                ack0_nack1 = 0;
                next_state = DRV_ACK;
              end
              else
              begin
                ack0_nack1 = 1;
                next_state = RCV_START;
              end
            end
          RCV_REG_ADDRESS:
            begin
              // Slave should respond since message is targeted to it
              for(int indx = $size(packet.reg_address) - 1; indx >= 0; indx++)
              begin
                @(posedge drv_vif.SCL);
                packet.reg_address[indx] = drv_vif.SDA;
              end

              //Check address exist by using reg_read
              ack0_nack1 = ~(register_map.reg_read(packet.reg_address, reg_data));
              next_state = DRV_ACK;
            end
          DRV_ACK:
            begin
              @(negedge drv_vif.SCL);
              drv_vif.SDA = ack0_nack1;
              
              @(negedge drv_vif.SCL);
              drv_vif.SDA = 'z;

              if(ack0_nack1 == 0)
              begin
                case(prev_state)
                  RCV_SLAVE_ADDRESS : next_state = RCV_REG_ADDRESS;
                  RCV_REG_ADDRESS : next_state = (ack0_nack1) ? RCV_START : (packet.wr_rd) ? RCV_DATA : DRV_DATA; 
                  DRV_DATA : next_state = RCV_START; 
                  default:
                    begin
                      `uvm_error(get_full_name(), "Invalid State detected, Moving to RCV_START")
                      next_state = RCV_START;
                    end
                endcase
              end
              else
              begin
                next_state = RCV_START;
              end
            end
          DRV_DATA:
            begin
              ack0_nack1 = ~(register_map.reg_read(packet.reg_address, packet.data));
              
              for(int indx = $size(packet.data) - 1; indx >= 0; indx++)
              begin
               @(negedge drv_vif.ref_clk);
               drv_vif.SDA = packet.data[indx];
              end

              drv_vif.SDA = 'z;
              next_state = RCV_ACK; 
            end
          RCV_DATA:
            begin
              for(int indx = $size(packet.data) - 1; indx >= 0; indx++)
              begin
               @(posedge drv_vif.ref_clk);
               packet.data[indx] = drv_vif.SDA;
              end

              ack0_nack1 = ~(register_map.reg_write(packet.reg_address, packet.data));
              next_state = DRV_ACK; 
            end
          RCV_ACK:
            begin
              @(posedge drv_vif.SCL);
              ack0_nack1 = drv_vif.SDA;
              next_state = IDLE;
            end
          default:
            begin
              next_state = RCV_START;
              `uvm_error(get_full_name(), "Invalid State detected, Moving to RCV_START")
            end
        endcase
      end

      prev_state = curr_state;
      curr_state = next_state;
    end

  endtask: run_phase

endclass : i2c_driver

`endif

