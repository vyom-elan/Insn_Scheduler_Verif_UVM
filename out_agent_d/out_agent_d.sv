class out_agent_d extends uvm_agent;

  `uvm_component_utils(out_agent_d)

  out_monitor_d      mon_d;
  out_driver_d       drv_d;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    mon_d = out_monitor_d::type_id::create("mon_d", this);

    if (is_active == UVM_ACTIVE)
      drv_d = out_driver_d::type_id::create("drv_d", this);
  endfunction

endclass
