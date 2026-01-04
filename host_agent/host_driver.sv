class host_driver extends uvm_driver #(instr_xtn);

  virtual host_if vif;

  `uvm_component_utils(host_driver)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual host_if)::get(this, "", "vif", vif))
      `uvm_fatal("HOST_DRV", "host_if not found")
  endfunction

  task run_phase(uvm_phase phase);
    instr_xtn req;

    // Drive defaults
    vif.valid <= 1'b0;
    vif.instr <= '0;

    forever begin
      seq_item_port.get_next_item(req);

      // Drive instruction
      vif.instr <= req.instr;
      vif.valid <= 1'b1;

      // Wait until DUT accepts it
      do @(posedge vif.clk);
      while (!vif.ready);

      // Deassert valid after handshake
      vif.valid <= 1'b0;

      seq_item_port.item_done();
    end
  endtask

endclass
