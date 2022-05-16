class phase_accl_to_duty_cycle_sequence extends phase_sequence;

  `uvm_object_utils(phase_accl_to_duty_cycle_sequence)

  //Constructor
  function new(string name = "phase_accl_to_duty_cycle_sequence");
    super.new(name);
  endfunction : new

  virtual task body();
    super.body();

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
  endtask : body

endclass
