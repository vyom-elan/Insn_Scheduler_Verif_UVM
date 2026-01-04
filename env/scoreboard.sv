class instr_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(instr_scoreboard)

  // Analysis exports
  uvm_analysis_imp #(instr_xtn, instr_scoreboard) host_imp;
  uvm_analysis_imp #(instr_xtn, instr_scoreboard) a_imp;
  uvm_analysis_imp #(instr_xtn, instr_scoreboard) b_imp;
  uvm_analysis_imp #(instr_xtn, instr_scoreboard) c_imp;
  uvm_analysis_imp #(instr_xtn, instr_scoreboard) d_imp;

  // Expected queues per opcode
  instr_xtn exp_q_a[$];
  instr_xtn exp_q_b[$];
  instr_xtn exp_q_c[$];
  instr_xtn exp_q_d[$];

  function new(string name, uvm_component parent);
    super.new(name, parent);

    host_imp = new("host_imp", this);
    a_imp    = new("a_imp",    this);
    b_imp    = new("b_imp",    this);
    c_imp    = new("c_imp",    this);
    d_imp    = new("d_imp",    this);
  endfunction

  // --------------------------------------------------
  // Host write: build expected queues
  // --------------------------------------------------
  function void write(instr_xtn tx);
    case (tx.opcode)
      3'd0: exp_q_a.push_back(tx);
      3'd1: exp_q_b.push_back(tx);
      3'd2: exp_q_c.push_back(tx);
      3'd3: exp_q_d.push_back(tx);
      default: begin
        // dropped opcode
        `uvm_info("SB",
          $sformatf("Dropping opcode %0d instruction 0x%08h",
                    tx.opcode, tx.instr),
          UVM_LOW)
      end
    endcase
  endfunction

  // --------------------------------------------------
  // Receiver write methods
  // --------------------------------------------------
  function void write_a(instr_xtn tx);
    check_and_pop(tx, exp_q_a, "A");
  endfunction

  function void write_b(instr_xtn tx);
    check_and_pop(tx, exp_q_b, "B");
  endfunction

  function void write_c(instr_xtn tx);
    check_and_pop(tx, exp_q_c, "C");
  endfunction

  function void write_d(instr_xtn tx);
    check_and_pop(tx, exp_q_d, "D");
  endfunction

  // --------------------------------------------------
  // Compare helper
  // --------------------------------------------------
  function void check_and_pop(
      instr_xtn actual,
      ref instr_xtn exp_q[$],
      string stream_name
  );
    instr_xtn exp;

    if (exp_q.size() == 0) begin
      `uvm_error("SB",
        $sformatf("Unexpected instruction on stream %s: 0x%08h",
                  stream_name, actual.instr))
      return;
    end

    exp = exp_q.pop_front();

    if (exp.instr !== actual.instr) begin
      `uvm_error("SB",
        $sformatf(
          "Mismatch on stream %s\nEXP: 0x%08h\nACT: 0x%08h",
          stream_name, exp.instr, actual.instr))
    end
    else begin
      `uvm_info("SB",
        $sformatf(
          "Match on stream %s: 0x%08h",
          stream_name, actual.instr),
        UVM_MEDIUM)
    end
  endfunction

  // --------------------------------------------------
  // End-of-test checks
  // --------------------------------------------------
  function void check_phase(uvm_phase phase);
    super.check_phase(phase);

    if (exp_q_a.size() != 0)
      `uvm_error("SB", $sformatf("Unconsumed A queue: %0d", exp_q_a.size()))

    if (exp_q_b.size() != 0)
      `uvm_error("SB", $sformatf("Unconsumed B queue: %0d", exp_q_b.size()))

    if (exp_q_c.size() != 0)
      `uvm_error("SB", $sformatf("Unconsumed C queue: %0d", exp_q_c.size()))

    if (exp_q_d.size() != 0)
      `uvm_error("SB", $sformatf("Unconsumed D queue: %0d", exp_q_d.size()))
  endfunction

endclass
