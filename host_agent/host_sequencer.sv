class host_sequencer extends uvm_sequencer #(instr_xtn);

  `uvm_component_utils(host_sequencer)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

endclass
