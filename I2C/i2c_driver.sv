// Class : I2C Driver 

`ifndef I2C_DRIVER
`define I2C_DRIVER

typedef class drv10975_register_map; 

class i2c_driver extends uvm_driver # (i2c_item);

  //Enum for States
  typedef enum {ST_START, ST_SLAVE_ADDRESS, ST_REG_ADDRESS, ST_DATA, ST_STOP} state_e;

  //Virtual Interface instance
  virtual i2c_if drv_vif;
  
  i2c_item packet;
  drv10975_register_map register_map;

  bit is_master;
  state_e curr_state, next_state;

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

    curr_state = ST_START;
    next_state = ST_START;
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
      fork
        master_fsm();
      join_none
    end
    else
    begin
      fork
        slave_fsm();
      join_none
    end

  endtask: run_phase

  virtual task master_fsm();
    
    forever
    begin
      `uvm_info(get_full_name(), $sformatf("Current_State = %s", curr_state.name()), UVM_HIGH)
      case(curr_state)
        ST_START: 
          begin
            //Master is the initiator.
            //Stay IDLE till able to fetch a new Sequence.
            // I2C start : 
            // SCL  -------
            // SDA  ---\___

            drv_vif.SCL = 1;
            seq_item_port.get_next_item(packet);

            packet.print();
            
            repeat(`I2C_DELAY) @ (posedge drv_vif.ref_clk);
            drv_vif.SDA = 0;
            repeat(`I2C_DELAY) @ (posedge drv_vif.ref_clk);
            
            //DA_TODO : ASSERT SCLK
            drv_vif.SCL = 0;
            next_state = ST_SLAVE_ADDRESS;
          end
        ST_SLAVE_ADDRESS: 
          begin
            
            `uvm_info(get_full_name(), $sformatf("Slave_Address = %0h", packet.slave_address), UVM_HIGH)
            
            for(int indx = $size(packet.slave_address) - 1; indx >= 0; indx--)
            begin
              @(negedge drv_vif.SCL);
              drv_vif.SDA = packet.slave_address[indx];
            end
            
            `uvm_info(get_full_name(), $sformatf("WR_RD = %s", packet.wr_rd.name()), UVM_HIGH)
            //Drive WR_RD
            @(negedge drv_vif.SCL);
            drv_vif.SDA = packet.wr_rd;

            // SLAVE Will drive ACK/NACK on next negedge
            // Release SDA
            @(posedge drv_vif.SCL);
            #(`I2C_CLK_PERIOD_US/4 * 1000);
            drv_vif.SDA = 'z; 
            @(negedge drv_vif.SCL);

            //We sample at Posedge
            @(posedge drv_vif.SCL);
            ack0_nack1 = drv_vif.SDA;

            // Check ACK/NACK
            // ACK : Send REG_ADDRESS
            // NACK : drop the packet, move to stop
            if(ack0_nack1 ==0)
            begin
              next_state = ST_REG_ADDRESS;
            end
            else
            begin
              @(negedge drv_vif.SCL);
              next_state = ST_STOP;
            end
          end
        ST_REG_ADDRESS:
          begin

            `uvm_info(get_full_name(), $sformatf("Reg_Address = %0h", packet.reg_address), UVM_HIGH)
            
            for(int indx = $size(packet.reg_address) - 1; indx >= 0; indx--)
            begin
              @(negedge drv_vif.SCL);
              drv_vif.SDA = packet.reg_address[indx];
            end
              
            // SLAVE Will drive ACK/NACK on next negedge
            // Release SDA
            @(posedge drv_vif.SCL);
            #(`I2C_CLK_PERIOD_US/4 * 1000);
            drv_vif.SDA = 'z; 
            @(negedge drv_vif.SCL);

            //We sample at Posedge
            @(posedge drv_vif.SCL);
            ack0_nack1 = drv_vif.SDA;
            
            // Check ACK/NACK
            // ACK : DATA
            // NACK : drop the packet, move to stop
            if(ack0_nack1 ==0)
            begin
              next_state = ST_DATA;
            end
            else
            begin
              @(negedge drv_vif.SCL);
              next_state = ST_STOP;
            end
          end
        ST_DATA: 
          begin
            
            if(packet.wr_rd == i2c_item::WRITE)
            begin
              `uvm_info(get_full_name(), $sformatf("DATA = %0h", packet.data), UVM_HIGH)
            end

            for(int indx = $size(packet.data) - 1; indx >= 0; indx--)
            begin
              if(packet.wr_rd == i2c_item::WRITE)
              begin
                @(negedge drv_vif.ref_clk);
                drv_vif.SDA = packet.data[indx];
              end
              else
              begin
                @(posedge drv_vif.ref_clk);
                packet.data[indx] = drv_vif.SDA;
              end
            end

            if(packet.wr_rd == i2c_item::READ)
            begin
              `uvm_info(get_full_name(), $sformatf("DATA = %0h", packet.data), UVM_HIGH)
            end

            //ACK/NACK
            if(packet.wr_rd == i2c_item::WRITE)
            begin
              //Release SDA
              @(posedge drv_vif.SCL);
              #(`I2C_CLK_PERIOD_US/4 * 1000);
              drv_vif.SDA = 'z; 
              @(negedge drv_vif.SCL);
            
              //We sample at Posedge
              @(posedge drv_vif.SCL);
              ack0_nack1 = drv_vif.SDA;
              @(negedge drv_vif.SCL);
              next_state = ST_STOP;
            end
            else
            begin
              // Master responds with ACK
              @(negedge drv_vif.SCL);
              drv_vif.SDA = 0; 

              //Slave samples at posedge
              @(posedge drv_vif.SCL);
              @(negedge drv_vif.ref_clk);
              next_state = ST_STOP;
            end
          end
        ST_STOP:
          begin
            // I2C Stop:
            // SCL  __/------
            // SDA  ____/----
            drv_vif.SCL = 1; 
            drv_vif.SDA = 0; 
            
            repeat(`I2C_DELAY)
            begin
              @ (posedge drv_vif.ref_clk);
            end

            drv_vif.SDA = 1;

            repeat(`I2C_DELAY)
            begin
              @ (posedge drv_vif.ref_clk);
            end

            next_state = ST_START;
            seq_item_port.item_done();
          end
        default:
          begin
            next_state = ST_START;
            `uvm_error(get_full_name(), "Invalid State detected, Moving to START")
          end
      endcase

      curr_state = next_state;
    end
  
  endtask : master_fsm

  virtual task slave_fsm();

    bit [9:0] start_scl;
    bit [9:0] start_sda;
    bit [9:0] stop_scl;
    bit [9:0] stop_sda;
    
    // Continuously check for start stop
    fork
      begin
        forever
        begin
          @(drv_vif.ref_clk);

          start_scl = start_scl << 1;
          start_scl[0] = drv_vif.SCL;

          start_sda = start_sda << 1;
          start_sda[0] = drv_vif.SDA;

          if(start_sda == 10'b1_1111__0_0000 && start_scl == 10'b11_1111_1111)
          begin
            next_state = ST_SLAVE_ADDRESS;
          end
        end
      end
      begin
        forever
        begin
          @(drv_vif.ref_clk);

          stop_scl = stop_scl << 1;
          stop_scl[0] = drv_vif.SCL;

          stop_sda = stop_sda << 1;
          stop_sda[0] = drv_vif.SDA;

          if(stop_sda == 10'b0_0000__1_1111 && start_scl == 10'b11_1111_1111)
          begin
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
              @(posedge drv_vif.SCL);
              packet.slave_address[indx] = drv_vif.SDA;
            end

            `uvm_info(get_full_name(), $sformatf("Slave_Address = %0h", packet.slave_address), UVM_HIGH)
            
            // WR_RD
            @(posedge drv_vif.SCL);
            packet.wr_rd = drv_vif.SDA;

            `uvm_info(get_full_name(), $sformatf("WR_RD = %s", packet.wr_rd.name()), UVM_HIGH)

            // drive ACK/NACK on next negedge
            @(negedge drv_vif.SCL);
            ack0_nack1 = (packet.slave_address == `I2C_SLAVE_ADDRESS) ? 0 : 1; 
            drv_vif.SDA = ack0_nack1; 

            //Master sample at Posedge
            @(posedge drv_vif.SCL);

            // Release SDA 
            #(`I2C_CLK_PERIOD_US/4 * 1000);
            drv_vif.SDA = 'z; 
            @(negedge drv_vif.SCL);

            // Check ACK/NACK
            // ACK : Send REG_ADDRESS
            // NACK : drop the packet, move to stop
            if(ack0_nack1 ==0)
            begin
              next_state = ST_REG_ADDRESS;
            end
            else
            begin
              next_state = ST_STOP;
            end
          end
        ST_REG_ADDRESS:
          begin
            for(int indx = $size(packet.reg_address) - 1; indx >= 0; indx--)
            begin
              @(posedge drv_vif.ref_clk);
              packet.reg_address[indx] = drv_vif.SDA;
            end
              
            `uvm_info(get_full_name(), $sformatf("Reg_Address = %0h", packet.reg_address), UVM_HIGH)

            // Read the reg to check if reg exit
            // For Write rewrite the same value
            ack0_nack1 = ~(register_map.reg_read(.reg_addr(packet.reg_address), .reg_data(packet.data)));

            if(packet.wr_rd == i2c_item::WRITE)
            begin
              ack0_nack1 = ~(register_map.reg_write(.reg_addr(packet.reg_address), .reg_data(packet.data)));
            end

            // Drive ACK/NACK on next negedge
            @(negedge drv_vif.SCL);
            drv_vif.SDA = ack0_nack1; 

            //Master sample at Posedge
            @(posedge drv_vif.SCL);

            // If Read Slave drive, retain SDA
            // If Write Master drive, release SDA
            if(packet.wr_rd == i2c_item::WRITE)
            begin
              #(`I2C_CLK_PERIOD_US/4 * 1000);
              drv_vif.SDA = 'z; 
              @(negedge drv_vif.SCL);
            end
            
            // Check ACK/NACK
            // ACK : Send REG_ADDRESS
            // NACK : drop the packet, move to stop
            if(ack0_nack1 == 0)
            begin
              next_state = ST_DATA;
            end
            else
            begin
              next_state = ST_STOP;
            end
          end
        ST_DATA: 
          begin
            if(packet.wr_rd == i2c_item::READ)
            begin
              `uvm_info(get_full_name(), $sformatf("DATA = %0h", packet.data), UVM_HIGH)
            end

            for(int indx = $size(packet.data) - 1; indx >= 0; indx--)
            begin
              if(packet.wr_rd == i2c_item::WRITE)
              begin
                @(posedge drv_vif.ref_clk);
                packet.data[indx] = drv_vif.SDA;
              end
              else
              begin
                @(negedge drv_vif.ref_clk);
                drv_vif.SDA = packet.data[indx];
              end
            end

            if(packet.wr_rd == i2c_item::WRITE)
            begin
              `uvm_info(get_full_name(), $sformatf("DATA = %0h", packet.data), UVM_HIGH)
            end

            //ACK/NACK
            if(packet.wr_rd == i2c_item::WRITE)
            begin
              // Write register
              ack0_nack1 = ~(register_map.reg_write(.reg_addr(packet.reg_address), .reg_data(packet.data)));

              //DRV ACK
              @(negedge drv_vif.SCL);
              drv_vif.SDA = ack0_nack1; 

              //Master sample at Posedge
              @(posedge drv_vif.SCL);

              // Release SDA 
              #(`I2C_CLK_PERIOD_US/4 * 1000);
              drv_vif.SDA = 0; 
              @(negedge drv_vif.SCL);

              next_state = ST_STOP;
            end
            else
            begin
              //Master sample lat data bit at posedge
              @(posedge drv_vif.ref_clk);

              // Master drv ACK, Release SDA
              #(`I2C_CLK_PERIOD_US/4 * 1000);
              drv_vif.SDA = 'z; 
              @(negedge drv_vif.ref_clk);
              
              //Sample ACK/NACK
              @(posedge drv_vif.SCL);
              ack0_nack1 = drv_vif.SDA;
              
              next_state = ST_STOP;
            end
          end
        ST_STOP:
          begin
            @(next_state);
            next_state = ST_START;
          end
        default:
          begin
            next_state = ST_START;
            `uvm_error(get_full_name(), "Invalid State detected, Moving to START")
          end
      endcase

      curr_state = next_state;
    end
  
  endtask : slave_fsm

endclass : i2c_driver

`endif

