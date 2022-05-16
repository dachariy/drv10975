class phase_seqr extends uvm_sequencer #(phase_item);
`uvm_component_utils(phase_seqr)

function new(string name, uvm_component par);
	super.new(name,par);
endfunction : new

endclass
