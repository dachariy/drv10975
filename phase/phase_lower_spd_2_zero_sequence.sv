class phase_lower_spd_2_zero_sequence extends phase_sequence;
  `uvm_object_utils(phase_lower_spd_2_zero_sequence)

  //Constructor
  function new(string name = "phase_lower_spd_2_zero_sequence");
    super.new(name);
  endfunction : new

  virtual task body();
    super.body();

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
  endtask

endclass
