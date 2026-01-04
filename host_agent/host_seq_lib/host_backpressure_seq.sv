class host_backpressure_seq extends host_base_seq;

  `uvm_object_utils(host_backpressure_seq)

  task body();
    instr_xtn tx;

    repeat (300) begin
      tx = instr_xtn::type_id::create("tx");
      assert(tx.randomize() with {
        instr[31:29] inside {[0:3]};
      });
      start_item(tx);
      finish_item(tx);
    end
  endtask

endclass
