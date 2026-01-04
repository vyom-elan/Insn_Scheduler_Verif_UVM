class host_random_seq extends host_base_seq;

  `uvm_object_utils(host_random_seq)

  task body();
    instr_xtn tx;

    repeat (200) begin
      tx = instr_xtn::type_id::create("tx");
      assert(tx.randomize());
      start_item(tx);
      finish_item(tx);
    end
  endtask

endclass
