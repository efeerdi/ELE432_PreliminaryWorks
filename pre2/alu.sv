module alu(input  logic [31:0] a, b,
           input  logic [2:0]  alucontrol,
           output logic [31:0] result,
           output logic        zero);

    always_comb begin
        case(alucontrol)
            3'b000: result = a + b;       // ADD
            3'b001: result = a - b;       // SUB
            3'b010: result = a & b;       // Bitwise AND
            3'b011: result = a | b;       // Bitwise OR
				3'b100: result = a ^ b;       // XOR
            3'b101: result = (signed'(a) < signed'(b)) ? 32'd1 : 32'd0; // SLT (Set Less Than)
            default: result = 32'bx;      // Undefined
        endcase
    end

    // Set zero flag to 1 if the result is 0. (Crucial for Branch instructions!)
    assign zero = (result == 32'b0);

endmodule
