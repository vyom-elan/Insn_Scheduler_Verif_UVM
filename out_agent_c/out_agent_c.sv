class out_agent_c extends uvm_agent;

  `uvm_component_utils(out_agent_c)

  out_monitor_c mon_c;
  out_driver_c drv_c;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    mon = out_monitor_c::type_id::create("mon_c", this);

    if (is_active == UVM_ACTIVE)
      drv = out_driver_c::type_id::create("drv_c", this);
  endfunction

endclass
