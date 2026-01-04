class host_agent extends uvm_agent;

  host_sequencer seqr;
  host_driver    drv;
  host_monitor   mon;

  `uvm_component_utils(host_agent)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (is_active == UVM_ACTIVE) begin
      seqr = host_sequencer::type_id::create("seqr", this);
      drv  = host_driver   ::type_id::create("drv",  this);
    end

    mon = host_monitor::type_id::create("mon", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (is_active == UVM_ACTIVE) begin
      drv.seq_item_port.connect(seqr.seq_item_export);
    end
  endfunction

endclass
