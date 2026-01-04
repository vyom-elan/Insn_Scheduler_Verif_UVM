class host_reset_seq extends host_base_seq;

  `uvm_object_utils(host_reset_seq)

  task body();
    instr_xtn tx;

    repeat (20) begin
      tx = instr_xtn::type_id::create("tx");
      assert(tx.randomize());
      start_item(tx);
      finish_item(tx);
      #20;
    end
  endtask

endclass
