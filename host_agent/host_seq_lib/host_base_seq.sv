class host_base_seq extends uvm_sequence #(instr_xtn);

  `uvm_object_utils(host_base_seq)

  function new(string name = "host_base_seq");
    super.new(name);
  endfunction

endclass
