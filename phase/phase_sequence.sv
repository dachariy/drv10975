class phase_sequence extends uvm_sequence # (phase_item);
`uvm_object_utils(phase_sequence)

phase_item data_obj;

  //Constructor
function new(string name = "phase_sequence");
    super.new(name);
endfunction : new

virtual task body();
    //$display ("Reached the body of sequence");
    data_obj=phase_item::type_id::create("data_obj");
    
    // Startup with Acceleration
	start_item(data_obj);
    data_obj.dir = 1;
    data_obj.threshold = 5'b00001;
    data_obj.fo_accel = 3'b011;
    data_obj.so_accel = 3'b111;
	data_obj.speed_cmd = 8'hFF;
    data_obj.FGcycle = 2'b00;
    data_obj.FGOLsel = 2'b00;
	finish_item(data_obj);

    // Lower speed to zero (SPEED_CMD == 0x00)
    start_item(data_obj);
    data_obj.dir = 1;
    data_obj.threshold = 5'b00001;
    data_obj.fo_accel = 3'b011;
    data_obj.so_accel = 3'b111;
	data_obj.speed_cmd = 8'h00;
    data_obj.FGcycle = 2'b00;
    data_obj.FGOLsel = 2'b00;
	finish_item(data_obj);

    
    // Accelerate to small duty cycle (speed cmd 0x0F, and threshold set)
    start_item(data_obj);
    data_obj.dir = 1;
    data_obj.threshold = 5'b00001;
    data_obj.fo_accel = 3'b011;
    data_obj.so_accel = 3'b111;
	data_obj.speed_cmd = 8'h0F;
    data_obj.FGcycle = 2'b00;
    data_obj.FGOLsel = 2'b00;
	finish_item(data_obj);


    // Speedup with no acceleration, INSTANT 100% Duty cycle (threshold = 0)
    start_item(data_obj);
    data_obj.dir = 1;
    data_obj.threshold = 5'b00000;
    data_obj.fo_accel = 3'b011;
    data_obj.so_accel = 3'b111;
	data_obj.speed_cmd = 8'hFF;
    data_obj.FGcycle = 2'b00;
    data_obj.FGOLsel = 2'b00;
	finish_item(data_obj);


    // Change Directions
    start_item(data_obj);
    data_obj.dir = 0;
    data_obj.threshold = 5'b00000;
    data_obj.fo_accel = 3'b011;
    data_obj.so_accel = 3'b111;
	data_obj.speed_cmd = 8'hFF;
    data_obj.FGcycle = 2'b00;
    data_obj.FGOLsel = 2'b00;
	finish_item(data_obj);


endtask : body
endclass


