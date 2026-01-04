class out_agent_a extends uvm_agent;

  `uvm_component_utils(out_agent_a)

  out_monitor_a mon_a;
  out_driver_a drv_a;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    mon_a = out_monitor_a::type_id::create("mon_a", this);

    if (is_active == UVM_ACTIVE)
      drv_a = out_driver_a::type_id::create("drv_a", this);
  endfunction

endclass
