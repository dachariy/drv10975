typedef class drv10975_register_map; 

class phase_driver extends uvm_driver # (phase_item);
`uvm_component_utils(phase_driver)

virtual phase_if phase_vif;

drv10975_register_map register_map;
uvm_analysis_port #(string) update_port;
uvm_analysis_port #(reg) dir_port;

phase_item data_obj;
reg [7:0] data;
realtime delay;

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

    dir_port = new ("dir_port", this);
    update_port = new ("update_port", this);

endfunction : build_phase

//Connect Phase
virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
endfunction : connect_phase

//Run Phase
virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);

    forever begin

        update_port.write("initial"); // setup boxes if necessary
        
        //register_map.reg_write(.reg_addr(8'h26), .reg_data(8'b00001000), .backdoor_wr(1'b1));
        //register_map.reg_write(.reg_addr(8'h25), .reg_data(8'b00111011), .backdoor_wr(1'b1));


        seq_item_port.get_next_item(data_obj);
        dir_port.write(data_obj.dir);
        phase_vif.DIR = data_obj.dir;
        // Writing to closed loop threshold, Align not implemented yet
        // (Threshold[7:3] + Aligntime[2:0])
        register_map.reg_write(.reg_addr(8'h26), .reg_data({data_obj.threshold, 3'b000}), .backdoor_wr(1'b1));

        // Writing to acceleration coefficients, Control[7:6] not implemented
        // (controlcoef [7:6], SO accel[5:3], FO accel[2:0])
        register_map.reg_write(.reg_addr(8'h25), .reg_data({2'b00, data_obj.so_accel, data_obj.fo_accel}), .backdoor_wr(1'b1));

        // Writing to speed command, 00 - FF (0-100%)
        register_map.reg_write(.reg_addr(8'h1B), .reg_data(data_obj.speed_cmd), .backdoor_wr(1'b1));

        // Writing to FG options, retaining whatever data[3:0] is
        register_map.reg_read(.reg_addr(8'h2B), .reg_data(data));
        register_map.reg_write(.reg_addr(8'h2B), .reg_data({data_obj.FGOLsel, data_obj.FGcycle, data[3:0]}), .backdoor_wr(1'b1));

        #100;
        // send to boxes that registers are updated
        update_port.write("updated");
        delay = quadratic_eq(second_order(data_obj.so_accel), first_order(data_obj.fo_accel), -1 * threshold(data_obj.threshold));
        delay = delay * 1.25;
        // allow simulation time
        if (data_obj.threshold == 0) begin
            #50000000;
        end
        else begin
            #delay;
        end

        seq_item_port.item_done();
    end
endtask: run_phase

function real first_order;
    input [2:0] in;
    case (in)
        3'b000: first_order = 76/1000000000;
        3'b001: first_order = 29/1000000000;
        3'b010: first_order = 19/1000000000;
        3'b011: first_order = 9.2/1000000000;
        3'b100: first_order = 4.5/1000000000;
        3'b101: first_order = 2.1/1000000000;
        3'b110: first_order = 0.9/1000000000;
        3'b111: first_order = 0.3/1000000000;
    endcase
endfunction

function real second_order;
    input [2:0] in;
    case (in)
        3'b000: second_order = 57/1e+18;
        3'b001: second_order = 29/1e+18;
        3'b010: second_order = 14/1e+18;
        3'b011: second_order = 6.9/1e+18;
        3'b100: second_order = 3.3/1e+18;
        3'b101: second_order = 1.6/1e+18;
        3'b110: second_order = 0.66/1e+18;
        3'b111: second_order = 0.22/1e+18;
    endcase
endfunction

function real threshold;
    input [4:0] in;
    real number;
    if (in[4] == 0) begin
        number = 0.8;
        threshold = number * in[3:0];
    end
    else begin
        number = 12.8;
        threshold = number + (number * (in[3:0]));
    end
endfunction

function real quadratic_eq;
input real a, b, c;
realtime store1, store2;
store1 = (-1*b + ($sqrt($pow(b,2) - (4*a*c)))) / (2*a);
store2 = (-1*b - ($sqrt($pow(b,2) - (4*a*c)))) / (2*a);
if (store1 >= 0)
    quadratic_eq = store1;
else
    quadratic_eq = store2;
endfunction


endclass
