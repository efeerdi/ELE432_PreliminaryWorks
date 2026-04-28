module riscv(
    input  logic        clk, reset,
    input  logic [31:0] ReadData,
    output logic        MemWrite,
    output logic [31:0] Adr, WriteData
);
    logic       Zero, PCWrite, AdrSrc, IRWrite, RegWrite;
    logic [1:0] ResultSrc, ALUSrcA, ALUSrcB, ImmSrc;
    logic [2:0] ALUControl;
    logic [31:0] Instr;

    controller c(
        .clk(clk), .reset(reset), 
        .op(Instr[6:0]), .funct3(Instr[14:12]), .funct7b5(Instr[30]), .Zero(Zero),
        .ImmSrc(ImmSrc), .ALUSrcA(ALUSrcA), .ALUSrcB(ALUSrcB), 
        .ResultSrc(ResultSrc), .AdrSrc(AdrSrc), .ALUControl(ALUControl),
        .IRWrite(IRWrite), .PCWrite(PCWrite), .RegWrite(RegWrite), .MemWrite(MemWrite)
    );

    datapath dp(
        .clk(clk), .reset(reset),
        .PCWrite(PCWrite), .AdrSrc(AdrSrc), .IRWrite(IRWrite), .RegWrite(RegWrite),
        .ResultSrc(ResultSrc), .ALUSrcA(ALUSrcA), .ALUSrcB(ALUSrcB), .ImmSrc(ImmSrc), 
        .ALUControl(ALUControl), .Zero(Zero),
        .ReadData(ReadData), .Instr(Instr), .Adr(Adr), .WriteData(WriteData)
    );
endmodule