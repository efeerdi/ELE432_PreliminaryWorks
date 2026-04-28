module controller (
    input  logic       clk,
    input  logic       reset,
    input  logic [6:0] op,
    input  logic [2:0] funct3,
    input  logic       funct7b5,
    input  logic       Zero,
    output logic [1:0] ImmSrc,
    output logic [1:0] ALUSrcA,
    output logic [1:0] ALUSrcB,
    output logic [1:0] ResultSrc,
    output logic       AdrSrc,
    output logic [2:0] ALUControl,
    output logic       IRWrite,
    output logic       PCWrite,
    output logic       RegWrite,
    output logic       MemWrite
);

    logic [1:0] ALUOp;
    logic       Branch;
    logic       PCUpdate;

    // FSM Modülünün bağlanması
    mainfsm fsm (
        .clk(clk),
        .reset(reset),
        .op(op),
        .AdrSrc(AdrSrc),
        .IRWrite(IRWrite),
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
        .ALUOp(ALUOp),
        .ResultSrc(ResultSrc),
        .PCUpdate(PCUpdate),
        .Branch(Branch),
        .RegWrite(RegWrite),
        .MemWrite(MemWrite)
    );

   
    aludec ad (
        .opb5(op[5]),
        .funct3(funct3),
        .funct7b5(funct7b5),
        .ALUOp(ALUOp),
        .ALUControl(ALUControl)
    );


    instrdec id (
        .op(op),
        .ImmSrc(ImmSrc)
    );

    assign PCWrite = PCUpdate | (Branch & Zero);

endmodule