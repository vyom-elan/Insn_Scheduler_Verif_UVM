class host_directed_opcode_seq extends host_base_seq;

  rand logic [2:0] opcode;

  `uvm_object_utils(host_directed_opcode_seq)

  constraint c_opcode { opcode inside {[0:3]}; }

  task body();
    instr_xtn tx;

    repeat (20) begin
      tx = instr_xtn::type_id::create("tx");
      assert(tx.randomize() with {
        instr[31:29] == opcode;
      });
      start_item(tx);
      finish_item(tx);
    end
  endtask

endclass
