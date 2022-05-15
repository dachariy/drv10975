typedef class drv10975_register_map; 

class get_speed extends uvm_component;
`uvm_component_utils(get_speed)

uvm_analysis_imp #(string, get_speed) updated_imp;
uvm_analysis_port #(reg [7:0]) speed_port;
reg [7:0] speed_cmd, speed_to_table;
reg [4:0] closed_loop_threshold; // max speed?
reg [7:0] closed_loop_data;
reg [7:0] accel_data;
reg [2:0] accel_fo;
reg [2:0] accel_so;
real fo, so, thres, accel_time;
real current_speed, initial_time, percent_speed;

real inter1, inter2;

drv10975_register_map register_map;
bit is_dut;

function new(string name = "get_speed", uvm_component parent = null);
    super.new(name,parent);
endfunction

virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    updated_imp = new ("updated_imp", this);
    speed_port = new ("speed_port", this);

    if(!uvm_config_db #(bit)::get(this, "*", "is_dut", is_dut))
    begin
      `uvm_fatal(get_full_name(), "Cant fetch is_dut from config_db")
    end
    
    if(!uvm_config_db #(drv10975_register_map)::get(this, "*", "register_map", register_map)) begin
      `uvm_fatal(get_type_name(), "Cant Fetch register_map from config_db")
    end
endfunction

virtual task run_phase(uvm_phase phase);
    forever begin
        #1000;
        if (thres != 0) begin
            if (current_speed < thres) begin
                current_speed = fo*($realtime - initial_time) + (so* $pow(($realtime - initial_time),2)  /   2);
                if (current_speed > thres)
                    current_speed = thres;
            end
            else if (current_speed > thres) begin
                current_speed = thres;
            end
                
            speed_to_table = int'((current_speed / thres) * 8'hFF);
            /*
            if(is_dut == 1)
                //`uvm_info(get_name(), $sformatf("Current speed: %f, current threshold: %f, speedtotable: %b", current_speed, thres, speed_to_table), UVM_LOW)
                `uvm_info(get_name(), $sformatf("fo: %e, so: %e, Current Time: %f, initial time: %f, currentspeed: %f, thres: %f", fo, so, $realtime, initial_time, current_speed, thres), UVM_LOW)
            */
            speed_port.write(speed_to_table);
        end
        else begin
            speed_port.write(speed_cmd);
        end
    end
endtask

function void write(string val);
    `uvm_info(get_full_name(), $sformatf("val: %s", val), UVM_HIGH)
    if (val == "initial") begin
            //`uvm_info(get_name(), $sformatf("INITIAL FOR SPEED BOX"), UVM_LOW)
           current_speed = 0;
           thres = 0;
           speed_cmd = 0;
    end

    if (val == "updated") begin
            register_map.reg_read(.reg_addr(8'h1b), .reg_data(speed_cmd));
            `uvm_info(get_name(), $sformatf("%b, Read in Speed", speed_cmd), UVM_LOW)
            //speed_port.write(speed);
            initial_time = $realtime;
            inter1 = speed_cmd;

            percent_speed = inter1 / 8'hFF;
            `uvm_info(get_name(), $sformatf("Percent_speed: %f", percent_speed), UVM_LOW)
            register_map.reg_read(.reg_addr(8'h26), .reg_data(closed_loop_data));
            closed_loop_threshold = closed_loop_data[7:3];
            `uvm_info(get_name(), $sformatf("%b, Read in closed loop", closed_loop_threshold), UVM_LOW)
            register_map.reg_read(.reg_addr(8'h25), .reg_data(accel_data)); 
            `uvm_info(get_name(), $sformatf("%b, Read in accel_date", accel_data), UVM_LOW)

            accel_fo = accel_data[2:0];
            accel_so = accel_data[5:3];

            thres = threshold(closed_loop_threshold) * percent_speed;
            so = second_order(accel_so);
            fo = first_order(accel_fo);
    end
endfunction

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


class phase_table extends uvm_component;
`uvm_component_utils(phase_table)

reg FG_lookup; // only one phase needed for FG output

uvm_analysis_imp #(reg [7:0], phase_table) speed_imp;

uvm_analysis_port #(realtime) val_port;
uvm_analysis_port #(string) FG_port;

bit is_dut;
virtual phase_if phase_vif;

realtime offset, amplitude;
realtime period;
int fd,counter;
string line;
realtime values[600];
reg [7:0] speed;

real inter;

function new(string name="phase_table", uvm_component parent = null);
    super.new(name,parent);
endfunction: new

virtual function void build_phase (uvm_phase phase);
  bit temp;
	super.build_phase (phase);

    if(!uvm_config_db #(bit)::get(this, "*", "is_dut", is_dut))
        begin
          `uvm_fatal(get_full_name(), "Cant fetch is_dut from config_db")
        end

    if(!(uvm_config_db #(virtual phase_if)::get(this, "*", "phase_vif", phase_vif)))
    begin
      `uvm_fatal(get_type_name, "Cant fetch drv_if from config_db")
    end

    speed_imp = new ("speed_imp", this);
    val_port = new ("val_port", this);
    FG_port = new ("FG_port", this);
    //amplitude = 1.0;
    counter = 0;
    period = 40000;

    fd = $fopen("./phase/wave.txt", "r");
    if (fd) begin
        while (!$feof(fd)) begin
           temp =  $fgets(line, fd);
            values[counter] = line.atoreal();
            counter += 1;
        end
        counter = offset;
        $fclose(fd);
    end
    
    else
        `uvm_fatal("FILE", "File could not be opened");
    //`uvm_info(get_name(), $sformatf(values), UVM_LOW)
endfunction

virtual task run_phase(uvm_phase phase);
        FG_port.write("initial");
        forever begin
            //`uvm_info(get_name(), $sformatf("Writing value: %f", values[counter] * amplitude), UVM_LOW)
            val_port.write(values[counter] * amplitude);

            if (phase_vif.DIR == 1) begin
                counter += 1;
                if (counter == 600)
                    counter = 0;
            end
            else begin
                counter -= 1;
                if (counter == -1)
                    counter = 599;
            end

            // FG
            
            if (counter == 200 || counter == 400 || counter == 600)
                if (amplitude > 0 && FG_lookup)
                    FG_port.write("placeholder");
            
            #period;
        end  
endtask : run_phase

virtual task get (output int counter);
    
endtask

function void write(reg [7:0] val);
    //`uvm_info(get_name(), $sformatf("We're writing to speed, "), UVM_LOW)
    inter = val;
    amplitude = inter / 8'hFF;
    //if (is_dut)
       // `uvm_info(get_name(), $sformatf("Speed request: %b, Amplitude: %f", val, amplitude), UVM_LOW)
    //`uvm_info(get_name(), $sformatf("New amplitude: %f", amplitude), UVM_LOW)
endfunction

endclass


class phase_FETs extends uvm_component;
`uvm_component_utils(phase_FETs)

virtual phase_if phase_vif;
bit is_dut;


reg [1:0] which_phase;
realtime value, time_high, time_low, period;
uvm_analysis_imp #(realtime, phase_FETs) message_imp;

function new(string name="phase_FETs", uvm_component parent);
    super.new(name,parent);
endfunction: new

virtual function void build_phase (uvm_phase phase);
	super.build_phase (phase);

    if(!uvm_config_db #(bit)::get(this, "*", "is_dut", is_dut))
    begin
          `uvm_fatal(get_full_name(), "Cant fetch is_dut from config_db")
        end

    if(!(uvm_config_db #(virtual phase_if)::get(this, "*", "phase_vif", phase_vif)))
    begin
      `uvm_fatal(get_type_name, "Cant fetch drv_if from config_db")
    end
    message_imp = new ("message_imp", this);
    period = 40000;
    //value = 1.0;
endfunction

task run_phase(uvm_phase phase);

forever begin
    //`uvm_info(get_name(), $sformatf("reached run_phase of phase %b", which_phase), UVM_LOW)
	time_high = value * period;
    //`uvm_info(get_name(), $sformatf("Changed value: %f", value), UVM_LOW)
    time_low = period - time_high;

    if (is_dut) begin
        case (which_phase)
        2'b00: 
            phase_vif.U = 1;
        2'b01:
            phase_vif.V = 1;
        2'b10:
            phase_vif.W = 1;   
        endcase
    end
        #time_high;

    if(is_dut) begin
        // output low
        case (which_phase)
        2'b00: 
            phase_vif.U = 0;
        2'b01:
            phase_vif.V = 0;
        2'b10:
            phase_vif.W = 0;   
        endcase
    end
    #time_low;
    //`uvm_info(get_name(), $sformatf("High: %f, Low: %f, Duty Cycle: %f", time_high, time_low, time_high/period), UVM_LOW)
end
endtask : run_phase

function void write(realtime val);
    //`uvm_info(get_name(), $sformatf("Arrrived Value: %f", value), UVM_LOW)
    value = val;
endfunction
endclass 




class FG_output extends uvm_component;
`uvm_component_utils(FG_output)
uvm_analysis_imp #(string, FG_output) message_imp;

drv10975_register_map register_map;
virtual phase_if phase_vif;

reg [2:0] counter;
reg [2:0] target;


reg FG_output;
reg closed_loop;
reg first_open;
reg [1:0] FGOLsel, prev_sel;
reg [1:0] FGcycle;
reg [7:0] data;
bit is_dut;

function new(string name="FG_output", uvm_component parent = null);
    super.new(name,parent);
endfunction: new

virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);

    if(!uvm_config_db #(bit)::get(this, "*", "is_dut", is_dut))
    begin
      `uvm_fatal(get_full_name(), "Cant fetch is_dut from config_db")
    end

    if(!uvm_config_db #(drv10975_register_map)::get(this, "*", "register_map", register_map)) begin
      `uvm_fatal(get_type_name(), "Cant Fetch register_map from config_db")
    end

    if(!(uvm_config_db #(virtual phase_if)::get(this, "*", "phase_vif", phase_vif)))
    begin
      `uvm_fatal(get_type_name, "Cant fetch drv_if from config_db")
    end

    message_imp = new("message_imp", this);
    register_map.reg_read(.reg_addr(8'h2b), .reg_data(data));
    FGOLsel = data[7:6];
    prev_sel = data[7:6];
    FGcycle = data[5:4];
    first_open = 1;
    closed_loop = 0; // idk how to check
    counter = 0;
    
endfunction

virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
        #500;
        if (closed_loop) begin
            first_open = 0;
        end
        register_map.reg_read(.reg_addr(8'h2b), .reg_data(data));
        FGOLsel = data[7:6];
        FGcycle = data[5:4];
        target = target_count(FGcycle);
        if (prev_sel != 2'b10 && FGOLsel == 2'b10) // if changed FG mode to 2, reset first open loop
            first_open = 1;
        
    end
endtask


function void write(string val);
    if (is_dut) begin
        if (val == "initial")
            phase_vif.FG = 0;
        if (FGOLsel == 2'b00 || (FGOLsel == 2'b01 && closed_loop == 1) || (FGOLsel == 2'b10 && (closed_loop || (!closed_loop && first_open))))
            counter += 1;
        //`uvm_info(get_name(), $sformatf("Counter: %d, Target: %d, FG: %b, String: %s", counter, target, phase_vif.FG, val), UVM_LOW)
        if (counter >= target) begin
            phase_vif.FG = ~phase_vif.FG;
            counter = 0;
        end
    end
        

endfunction

function [2:0] target_count;
    input [1:0] in;
    case (in)
        2'b00: target_count = 1;
        2'b01: target_count = 2;
        2'b10: target_count = 3;
        2'b11: target_count = 4;
    endcase
endfunction

endclass
