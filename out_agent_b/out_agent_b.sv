class out_agent_b extends uvm_agent;

  `uvm_component_utils(out_agent_b)

  out_monitor_b mon_b;
  out_driver_b drv_b;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    mon_b = out_monitor_b::type_id::create("mon_b", this);

    if (is_active == UVM_ACTIVE)
      drv_b = out_driver_b::type_id::create("drv_b", this);
  endfunction

endclass
