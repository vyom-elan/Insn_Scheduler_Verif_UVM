interface host_if(input logic clk);
    logic        in_valid;
    logic        in_ready;
    logic [31:0] in_instr;
endinterface
