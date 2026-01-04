class instr_xtn extends uvm_sequence_item;

  rand logic [31:0] instr;
  logic [2:0] opcode;

  `uvm_object_utils(instr_xtn)

  function new(string name = "instr_xtn");
    super.new(name);
  endfunction

  function void post_randomize();
    opcode = instr[31:29];
  endfunction

endclass
