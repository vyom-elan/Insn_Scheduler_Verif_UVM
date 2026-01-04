`timescale 1ns/1ps
import uvm_pkg::*;
`include "uvm_macros.svh"
`include "../rtl/insn_sched.sv"

module top;

  logic clk;
  logic rst_n;

  always #5 clk = ~clk;

  initial begin
    clk = 0;
    rst_n = 0;
    #50;
    rst_n = 1;
  end

  host_if host_if_inst(clk);
  recv_if out_a_if(clk);
  recv_if out_b_if(clk);
  recv_if out_c_if(clk);
  recv_if out_d_if(clk);

  instr_scheduler dut (
    .clk         (clk),
    .rst_n       (rst_n),

    .in_valid    (host_if_inst.valid),
    .in_ready    (host_if_inst.ready),
    .in_instr    (host_if_inst.instr),

    .out_valid_a (out_a_if.valid),
    .out_ready_a (out_a_if.ready),
    .out_instr_a (out_a_if.instr),

    .out_valid_b (out_b_if.valid),
    .out_ready_b (out_b_if.ready),
    .out_instr_b (out_b_if.instr),

    .out_valid_c (out_c_if.valid),
    .out_ready_c (out_c_if.ready),
    .out_instr_c (out_c_if.instr),

    .out_valid_d (out_d_if.valid),
    .out_ready_d (out_d_if.ready),
    .out_instr_d (out_d_if.instr)
  );

  initial begin
    out_a_if.ready = 1;
    out_b_if.ready = 1;
    out_c_if.ready = 1;
    out_d_if.ready = 1;
  end

  initial begin
    uvm_config_db#(virtual host_if)::set(null, "*", "vif", host_if_inst);

    uvm_config_db#(virtual recv_if)::set(null, "*.a*", "vif", out_a_if);
    uvm_config_db#(virtual recv_if)::set(null, "*.b*", "vif", out_b_if);
    uvm_config_db#(virtual recv_if)::set(null, "*.c*", "vif", out_c_if);
    uvm_config_db#(virtual recv_if)::set(null, "*.d*", "vif", out_d_if);

    run_test();
  end

endmodule
