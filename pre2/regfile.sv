module regfile(input  logic        clk, 
               input  logic        we3, 
               input  logic [4:0]  a1, a2, a3, 
               input  logic [31:0] wd3, 
               output logic [31:0] rd1, rd2);

    // Define thirty-two 32-bit registers
    logic [31:0] rf[31:0];

    // Write operation: Occurs on the rising edge of the clock if Write Enable (we3) is high
    always_ff @(posedge clk) begin
        if (we3) rf[a3] <= wd3;
    end

    // Read operation: Combinational, happens immediately.
    // In RISC-V architecture, register 0 (x0) is always hardwired to 0.
    assign rd1 = (a1 != 0) ? rf[a1] : '0;
    assign rd2 = (a2 != 0) ? rf[a2] : '0;

endmodule