class phase_sequence extends uvm_sequence # (phase_item);

  `uvm_object_utils(phase_sequence)

  phase_item data_obj;

  //Constructor
  function new(string name = "phase_sequence");
    super.new(name);
  endfunction : new

  virtual task body();
    data_obj=phase_item::type_id::create("data_obj");
  endtask : body
endclass
