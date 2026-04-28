module datapath(
    input  logic        clk, reset,
    input  logic        PCWrite, AdrSrc, IRWrite, RegWrite,
    input  logic [1:0]  ResultSrc, ALUSrcA, ALUSrcB, ImmSrc,
    input  logic [2:0]  ALUControl,
    output logic        Zero,
    input  logic [31:0] ReadData,
    output logic [31:0] Instr,
    output logic [31:0] Adr, WriteData
);
    logic [31:0] PC, OldPC, Data;
    logic [31:0] RD1, RD2, A, B;
    logic [31:0] SrcA, SrcB, ALUResult, ALUOut, Result, ImmExt;

    flopenr #(32) pcreg(clk, reset, PCWrite, Result, PC);
    mux2    #(32) adrmux(PC, Result, AdrSrc, Adr);

    flopenr #(32) instrreg(clk, reset, IRWrite, ReadData, Instr);
    flopr   #(32) oldpcreg(clk, reset, PC, OldPC);
    flopr   #(32) datareg(clk, reset, ReadData, Data);

    regfile rf(clk, RegWrite, Instr[19:15], Instr[24:20], Instr[11:7], Result, RD1, RD2);
    extend  ext(Instr[31:7], ImmSrc, ImmExt);

    flopr #(32) areg(clk, reset, RD1, A);
    flopr #(32) breg(clk, reset, RD2, B);
    assign WriteData = B;

    mux3 #(32) srcamux(PC, OldPC, A, ALUSrcA, SrcA);
    mux3 #(32) srcbmux(B, ImmExt, 32'd4, ALUSrcB, SrcB);

    alu alu_unit(SrcA, SrcB, ALUControl, ALUResult, Zero);
    flopr #(32) aluoutreg(clk, reset, ALUResult, ALUOut);

    mux3 #(32) resmux(ALUOut, Data, ALUResult, ResultSrc, Result);
endmodule

module alu(input logic [31:0] a, b, input logic [2:0] alucontrol, output logic [31:0] result, output logic zero);
    logic [31:0] condinvb, sum;
    assign condinvb = alucontrol[2] ? ~b : b;
    assign sum = a + condinvb + alucontrol[2];
    always_comb begin
        case(alucontrol)
            3'b010: result = sum;         
            3'b110: result = sum;   
				3'b100: result = a ^ b;
            3'b000: result = a & b;       
            3'b001: result = a | b;       
            3'b111: result = {31'b0, sum[31]}; 
            default: result = 32'bx;
        endcase
    end
    assign zero = (result == 32'b0);
endmodule

module regfile(input logic clk, we3, input logic [4:0] a1, a2, a3, input logic [31:0] wd3, output logic [31:0] rd1, rd2);
    logic [31:0] rf[31:0];
    always_ff @(posedge clk) if (we3) rf[a3] <= wd3;
    assign rd1 = (a1 != 0) ? rf[a1] : 0;
    assign rd2 = (a2 != 0) ? rf[a2] : 0;
endmodule

module extend(input logic [31:7] instr, input logic [1:0] immsrc, output logic [31:0] immext);
    always_comb begin
        case(immsrc)
            2'b00: immext = {{20{instr[31]}}, instr[31:20]};  
            2'b01: immext = {{20{instr[31]}}, instr[31:25], instr[11:7]}; 
            2'b10: immext = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0}; 
            2'b11: immext = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0}; 
            default: immext = 32'bx;
        endcase
    end
endmodule

module flopenr #(parameter WIDTH = 8)(input logic clk, reset, en, input logic [WIDTH-1:0] d, output logic [WIDTH-1:0] q);
    always_ff @(posedge clk, posedge reset) if (reset) q <= 0; else if (en) q <= d;
endmodule

module flopr #(parameter WIDTH = 8)(input logic clk, reset, input logic [WIDTH-1:0] d, output logic [WIDTH-1:0] q);
    always_ff @(posedge clk, posedge reset) if (reset) q <= 0; else q <= d;
endmodule

module mux2 #(parameter WIDTH = 8)(input logic [WIDTH-1:0] d0, d1, input logic s, output logic [WIDTH-1:0] y);
    assign y = s ? d1 : d0;
endmodule

module mux3 #(parameter WIDTH = 8)(input logic [WIDTH-1:0] d0, d1, d2, input logic [1:0] s, output logic [WIDTH-1:0] y);
    assign y = s[1] ? d2 : (s[0] ? d1 : d0);
endmodule