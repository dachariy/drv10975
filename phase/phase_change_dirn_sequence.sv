class phase_change_dirn_sequence extends phase_sequence;
`uvm_object_utils(phase_change_dirn_sequence)

  //Constructor
  function new(string name = "phase_change_dirn_sequence");
    super.new(name);
  endfunction : new

  virtual task body();
    super.body();

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
    
