class out_monitor_d extends uvm_monitor;

  `uvm_component_utils(out_monitor_d)

  virtual out_d_if vif;
  uvm_analysis_port #(instr_xtn) ap;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    ap = new("ap", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual out_a_if)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", "out_monitor: virtual interface not set")
  endfunction

  task run_phase(uvm_phase phase);
    instr_xtn tx;
    forever begin
      @(posedge vif.clk);
      if (vif.out_valid && vif.out_ready) begin
        tx = instr_xtn::type_id::create("tx");
        tx.instr  = vif.out_instr;
        tx.opcode = vif.out_instr[31:29];
        ap.write(tx);
      end
    end
  endtask

endclass
