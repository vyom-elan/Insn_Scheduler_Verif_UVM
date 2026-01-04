 module instr_scheduler (
    input  logic         clk,
    input  logic         rst_n,

    // Host input interface
    input  logic         in_valid,
    output logic         in_ready,
    input  logic [31:0]  in_instr,

    // 4 output streams
    output logic         out_valid_a,
    input  logic         out_ready_a,
    output logic [31:0]  out_instr_a,

    output logic         out_valid_b,
    input  logic         out_ready_b,
    output logic [31:0]  out_instr_b,

    output logic         out_valid_c,
    input  logic         out_ready_c,
    output logic [31:0]  out_instr_c,

    output logic         out_valid_d,
    input  logic         out_ready_d,
    output logic [31:0]  out_instr_d
);

    logic [2:0] opcode;
    assign opcode = in_instr[31:29];

    // COMBINATIONAL READY LOGIC
    always_comb begin
        case (opcode)
            3'd0: in_ready = out_ready_a;
            3'd1: in_ready = out_ready_b;
            3'd2: in_ready = out_ready_c;
            3'd3: in_ready = out_ready_d;
            default: in_ready = 1'b1; // unsupported opcode
        endcase
    end

    // SEQUENTIAL VALID / DATA
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            out_valid_a <= 1'b0;
            out_valid_b <= 1'b0;
            out_valid_c <= 1'b0;
            out_valid_d <= 1'b0;

            out_instr_a <= '0;
            out_instr_b <= '0;
            out_instr_c <= '0;
            out_instr_d <= '0;
        end
        else begin
            // default: clear valids
            out_valid_a <= 1'b0;
            out_valid_b <= 1'b0;
            out_valid_c <= 1'b0;
            out_valid_d <= 1'b0;

            if (in_valid && in_ready) begin
                case (opcode)
                    3'd0: begin
                        out_valid_a <= 1'b1;
                        out_instr_a <= in_instr;
                    end
                    3'd1: begin
                        out_valid_b <= 1'b1;
                        out_instr_b <= in_instr;
                    end
                    3'd2: begin
                        out_valid_c <= 1'b1;
                        out_instr_c <= in_instr;
                    end
                    3'd3: begin
                        out_valid_d <= 1'b1;
                        out_instr_d <= in_instr;
                    end
                    default: begin
                        // drop instruction
                    end
                endcase
            end
        end
    end

endmodule
