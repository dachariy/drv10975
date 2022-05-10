typedef class drv10975_register_map; 

class get_speed extends uvm_component;
`uvm_component_utils(get_speed)

uvm_analysis_port #(reg [7:0]) speed_port;
reg [7:0] speed;

drv10975_register_map register_map;

function new(string name = "get_speed", uvm_component parent = null);
    super.new(name,parent);
endfunction

virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    speed_port = new ("speed_port", this);

    
    if(!uvm_config_db #(drv10975_register_map)::get(this, "*", "register_map", register_map)) begin
      `uvm_fatal(get_type_name(), "Cant Fetch register_map from config_db")
    end
    else
    speed = 0;
endfunction

virtual task run_phase(uvm_phase phase);
    forever begin
        $display("%b, why am i stuck here", speed);
        register_map.reg_read(.reg_addr(8'h1b), .reg_data(speed));
        speed_port.write(speed);
    end
endtask

endclass


class phase_table extends uvm_component;
`uvm_component_utils(phase_table)

reg FG_lookup; // only one phase needed for FG output

uvm_analysis_imp #(reg [7:0], phase_table) speed_imp;
uvm_analysis_port #(realtime) val_port;
uvm_analysis_port #(string) FG_port;
realtime offset, amplitude;
realtime period;
int fd,counter;
string line;
realtime values[600];
reg [7:0] speed;

function new(string name="phase_table", uvm_component parent = null);
    super.new(name,parent);
endfunction: new

virtual function void build_phase (uvm_phase phase);
	super.build_phase (phase);
    speed_imp = new ("speed_imp", this);
    val_port = new ("val_port", this);
    FG_port = new ("FG_port", this);
    amplitude = 0.0;
    offset = 0.0;
    counter = 0;
    period = 100;
    //$display("Reached!");
    fd = $fopen("./phase/wave.txt", "r");
    if (fd) begin
        while (!$feof(fd)) begin
            $fgets(line, fd);
            values[counter] = line.atoreal();
            counter += 1;
        end
        counter = offset;
        $fclose(fd);
    end
    
    else
        `uvm_fatal("FILE", "File could not be opened");
    //$display(values);
endfunction

virtual task run_phase(uvm_phase phase);
    //$display ("reached run_phase");
    forever begin
        $display("table", speed);
        val_port.write(values[counter] * amplitude);
        counter += 1;
        if (counter == 600)
            counter = 0;

        // FG
        
        if (counter == 200 || counter == 400 || counter == 600)
            if (amplitude > 0 && FG_lookup)
                FG_port.write("placeholder");
        
        #period;
    end
endtask : run_phase


function void write(reg [7:0] val);
    amplitude = val / 32'hFF;
endfunction

endclass


class phase_FETs extends uvm_component;
`uvm_component_utils(phase_FETs)

virtual phase_if phase_vif;
reg [1:0] which_phase;
realtime value, time_high, time_low, period;
uvm_analysis_imp #(realtime, phase_FETs) message_imp;

function new(string name="phase_FETs", uvm_component parent);
    super.new(name,parent);
endfunction: new

virtual function void build_phase (uvm_phase phase);
	super.build_phase (phase);
    if(!(uvm_config_db #(virtual phase_if)::get(this, "*", "phase_vif", phase_vif)))
    begin
      `uvm_fatal(get_type_name, "Cant fetch drv_if from config_db")
    end
    message_imp = new ("message_imp", this);
    period = 1000;
    value = 0.0;
    which_phase = 2'b11;
endfunction

task run_phase(uvm_phase phase);
forever begin
	time_high = value * period;
    time_low = period - time_high;
    case (which_phase)
    2'b00: 
        phase_vif.U = 1;
    2'b01:
        phase_vif.V = 1;
    2'b10:
        phase_vif.W = 1;   
    endcase
    #time_high;
    // output low
    case (which_phase)
    2'b00: 
        phase_vif.U = 0;
    2'b01:
        phase_vif.V = 0;
    2'b10:
        phase_vif.W = 0;   
    endcase
    #time_low;
    //$display("High: %f, Low: %f, Duty Cycle: %f", time_high, time_low, time_high/period);
end
endtask : run_phase

function void write(realtime val);
    value = val;
endfunction
endclass 




class FG_output extends uvm_component;
`uvm_component_utils(FG_output)
uvm_analysis_imp #(string, FG_output) message_imp;

drv10975_register_map register_map;

reg [2:0] counter;
reg [2:0] target;

reg FG_output;
reg closed_loop;
reg first_open;
reg [1:0] FGOLsel, prev_sel;
reg [1:0] FGcycle;
reg [7:0] data;

function new(string name="FG_output", uvm_component parent = null);
    super.new(name,parent);
endfunction: new

virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(drv10975_register_map)::get(this, "*", "register_map", register_map)) begin
      `uvm_fatal(get_type_name(), "Cant Fetch register_map from config_db")
    end

    message_imp = new("message_imp", this);
    register_map.reg_read(.reg_addr(8'h2b), .reg_data(data));
    FGOLsel = data[7:6];
    prev_sel = data[7:6];
    FGcycle = data[5:4];
    first_open = 1;
    closed_loop = 0; // idk how to check
    FG_output = 1;
    counter = 0;
endfunction

virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
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
    if (FGOLsel == 2'b00 || (FGOLsel == 2'b01 && closed_loop == 1) || (FGOLsel == 2'b10 && (closed_loop || (!closed_loop && first_open))))
    counter += 1;
    if (counter >= target) begin
        FG_output = ~FG_output;
        counter = 0;
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