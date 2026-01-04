class host_monitor extends uvm_monitor;

  virtual host_if vif;
  uvm_analysis_port #(instr_xtn) ap;

  `uvm_component_utils(host_monitor)

  function new(string name, uvm_component parent);
    super.new(name, parent);
    ap = new("ap", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual host_if)::get(this, "", "vif", vif))
      `uvm_fatal("HOST_MON", "host_if not found")
  endfunction

  task run_phase(uvm_phase phase);
    instr_xtn tx;

    forever begin
      @(posedge vif.clk);
      if (vif.valid && vif.ready) begin
        tx = instr_xtn::type_id::create("tx");
        tx.instr = vif.instr;
        tx.opcode = vif.instr[31:29];
        ap.write(tx);
      end
    end
  endtask

endclass
