class phase_item extends uvm_sequence_item;
`uvm_object_utils(phase_item)
// Desired Speed (SpeedCmd), 0xFF is 100%
rand bit [7:0] speed_cmd;

// Closed loop threshold:
/*
    if (in[4] == 0) begin
        number = 0.8;
        threshold = number * in[3:0];
    end
    else begin
        number = 12.8;
        threshold = number + (number * (in[3:0]));
    end
*/
rand bit [4:0] threshold;

/*
        3'b000: first_order = 76/1000000000;
        3'b001: first_order = 29/1000000000;
        3'b010: first_order = 19/1000000000;
        3'b011: first_order = 9.2/1000000000;
        3'b100: first_order = 4.5/1000000000;
        3'b101: first_order = 2.1/1000000000;
        3'b110: first_order = 0.9/1000000000;
        3'b111: first_order = 0.3/1000000000;

        3'b000: second_order = 57/1e+18;
        3'b001: second_order = 29/1e+18;
        3'b010: second_order = 14/1e+18;
        3'b011: second_order = 6.9/1e+18;
        3'b100: second_order = 3.3/1e+18;
        3'b101: second_order = 1.6/1e+18;
        3'b110: second_order = 0.66/1e+18;
        3'b111: second_order = 0.22/1e+18;
*/
rand bit [2:0] fo_accel;
rand bit [2:0] so_accel;

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


