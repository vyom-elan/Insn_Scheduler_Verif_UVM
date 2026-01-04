class instr_env extends uvm_env;

  `uvm_component_utils(instr_env)
  host_agent        host;

  out_agent_a a;
  out_agent_b b;
  out_agent_c c;
  out_agent_d d;

  instr_scoreboard  sb;

  // --------------------------------------------------
  // Constructor
  // --------------------------------------------------
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  // --------------------------------------------------
  // Build Phase
  // --------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Host agent (ACTIVE)
    host = host_agent::type_id::create("host", this);
    host.is_active = UVM_ACTIVE;

    // Receiver agents (ACTIVE – drive ready)
    a = out_agent_a::type_id::create("a", this);
    b = out_agent_b::type_id::create("b", this);
    c = out_agent_c::type_id::create("c", this);
    d = out_agent_d::type_id::create("d", this);

    a.is_active = UVM_ACTIVE;
    b.is_active = UVM_ACTIVE;
    c.is_active = UVM_ACTIVE;
    d.is_active = UVM_ACTIVE;

    // Scoreboard
    sb = instr_scoreboard::type_id::create("sb", this);

  endfunction

  // --------------------------------------------------
  // Connect Phase
  // --------------------------------------------------
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // -----------------------------
    // Host -> Scoreboard
    // -----------------------------
    host.mon.ap.connect(sb.host_imp);

    // -----------------------------
    // Receivers -> Scoreboard
    // -----------------------------
    a.mon.ap.connect(sb.a_imp);
    b.mon.ap.connect(sb.b_imp);
    c.mon.ap.connect(sb.c_imp);
    d.mon.ap.connect(sb.d_imp);

  endfunction

endclass
