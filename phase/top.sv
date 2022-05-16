`timescale 1ns/100ps

package fet_drive;
import uvm_pkg::*;
`include "placeholder.sv"
`include "driver_env.sv"
`include "driver_test.sv"
endpackage


module top();  
import uvm_pkg::*;
initial begin
    run_test("driver_test");
end

endmodule : top