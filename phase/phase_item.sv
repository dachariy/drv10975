class phase_item extends uvm_sequence_item;
`uvm_object_utils(phase_item)
// Desired Speed (SpeedCmd), 0xFF is 100%
rand bit [7:0] desired_speed;

// 00 = 2 poles, 01 = 4 poles, 10 = 6 poles, 11 = 8 poles
rand bit [1:0] FGcycle;
// 00 = output open & close loop, 01 = only closed loop, 10 = closed loop, first open loop
rand bit [1:0] FGOLsel;

//Constructor
function new(string name = "phase_item");
    super.new(name);
endfunction : new

constraint c_FGOL
{
    FGOLsel inside {2'b00, 2'b01, 2'b11};
}

endclass


