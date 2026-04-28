module controller (
    input  logic       clk, reset,
    input  logic [6:0] op,
    input  logic [2:0] funct3,
    input  logic       funct7b5,
    input  logic       Zero,
    output logic [1:0] ImmSrc, ALUSrcA, ALUSrcB, ResultSrc,
    output logic       AdrSrc,
    output logic [2:0] ALUControl,
    output logic       IRWrite, PCWrite, RegWrite, MemWrite
);
    logic [1:0] ALUOp;
    logic       Branch, PCUpdate;

    // FSM (Çok çevrimli mimarinin kalbi)
    mainfsm fsm(
        .clk(clk), .reset(reset), .op(op),
        .AdrSrc(AdrSrc), .IRWrite(IRWrite), .ALUSrcA(ALUSrcA), .ALUSrcB(ALUSrcB),
        .ALUOp(ALUOp), .ResultSrc(ResultSrc), .PCUpdate(PCUpdate), .Branch(Branch),
        .RegWrite(RegWrite), .MemWrite(MemWrite)
    );

    // Lab 2'den gelen ALU Decoder
    aludec ad(
        .opb5(op[5]), .funct3(funct3), .funct7b5(funct7b5),
        .ALUOp(ALUOp), .ALUControl(ALUControl)
    );

    // Lab 2'den gelen Komut Decoder
    instrdec id(
        .op(op), .ImmSrc(ImmSrc)
    );

    // PC Yazma Mantığı
    assign PCWrite = PCUpdate | (Branch & Zero);
endmodule

module mainfsm(
    input  logic       clk, reset,
    input  logic [6:0] op,
    output logic       AdrSrc, IRWrite,
    output logic [1:0] ALUSrcA, ALUSrcB, ALUOp, ResultSrc,
    output logic       PCUpdate, Branch, RegWrite, MemWrite
);
    typedef enum logic [3:0] {
        FETCH=4'd0, DECODE=4'd1, MEMADR=4'd2, MEMREAD=4'd3, MEMWB=4'd4, 
        MEMWRITE=4'd5, EXECUTER=4'd6, ALUWB=4'd7, EXECUTEI=4'd8, J_JAL=4'd9, B_BEQ=4'd10
    } statetype;
    
    statetype state, nextstate;

    always_ff @(posedge clk, posedge reset)
        if (reset) state <= FETCH;
        else       state <= nextstate;

    always_comb begin
        PCUpdate=0; Branch=0; RegWrite=0; MemWrite=0; IRWrite=0;
        AdrSrc=0; ResultSrc=2'b00; ALUSrcA=2'b00; ALUSrcB=2'b00; ALUOp=2'b00;

        case (state)
            FETCH: begin
                AdrSrc = 0; IRWrite = 1; ALUSrcA = 2'b00; ALUSrcB = 2'b10;
                ResultSrc = 2'b10; PCUpdate = 1; nextstate = DECODE;
            end
            DECODE: begin
                ALUSrcA = 2'b01; ALUSrcB = 2'b01; ALUOp = 2'b00;
                case(op)
                    7'b0000011: nextstate = MEMADR;   // lw
                    7'b0100011: nextstate = MEMADR;   // sw
                    7'b0110011: nextstate = EXECUTER; // R-type
                    7'b0010011: nextstate = EXECUTEI; // I-type
                    7'b1100011: nextstate = B_BEQ;    // beq
                    7'b1101111: nextstate = J_JAL;    // jal
                    default:    nextstate = FETCH;
                endcase
            end
            MEMADR: begin
                ALUSrcA = 2'b10; ALUSrcB = 2'b01; ALUOp = 2'b00;
                if (op == 7'b0000011) nextstate = MEMREAD; else nextstate = MEMWRITE;
            end
            MEMREAD: begin ResultSrc = 2'b00; AdrSrc = 1; nextstate = MEMWB; end
            MEMWB:   begin ResultSrc = 2'b01; RegWrite = 1; nextstate = FETCH; end
            MEMWRITE:begin ResultSrc = 2'b00; AdrSrc = 1; MemWrite = 1; nextstate = FETCH; end
            EXECUTER:begin ALUSrcA = 2'b10; ALUSrcB = 2'b00; ALUOp = 2'b10; nextstate = ALUWB; end
            EXECUTEI:begin ALUSrcA = 2'b10; ALUSrcB = 2'b01; ALUOp = 2'b10; nextstate = ALUWB; end
            ALUWB:   begin ResultSrc = 2'b00; RegWrite = 1; nextstate = FETCH; end
            B_BEQ:   begin ALUSrcA = 2'b10; ALUSrcB = 2'b00; ALUOp = 2'b01; ResultSrc = 2'b00; Branch = 1; nextstate = FETCH; end
            J_JAL:   begin ALUSrcA = 2'b01; ALUSrcB = 2'b10; ALUOp = 2'b00; ResultSrc = 2'b00; PCUpdate = 1; nextstate = ALUWB; end
            default: nextstate = FETCH;
        endcase
    end
endmodule

module aludec(
    input  logic       opb5,
    input  logic [2:0] funct3,
    input  logic       funct7b5,
    input  logic [1:0] ALUOp,
    output logic [2:0] ALUControl
);
    logic RtypeSub;
    assign RtypeSub = funct7b5 & opb5;

    always_comb begin
        case(ALUOp)
            2'b00: ALUControl = 3'b010; // add
            2'b01: ALUControl = 3'b110; // sub
            2'b10: case(funct3)
                       3'b000: if (RtypeSub) ALUControl = 3'b110; else ALUControl = 3'b010;
                       3'b010: ALUControl = 3'b111; // slt
							  3'b100: ALUControl = 3'b100; //xor
                       3'b110: ALUControl = 3'b001; // or
                       3'b111: ALUControl = 3'b000; // and
							  
                       default: ALUControl = 3'b010;
                   endcase
            default: ALUControl = 3'b010;
        endcase
    end
endmodule

module instrdec(input logic [6:0] op, output logic [1:0] ImmSrc);
    always_comb begin
        case(op)
            7'b0100011: ImmSrc = 2'b01; // S-type
            7'b1100011: ImmSrc = 2'b10; // B-type
            7'b1101111: ImmSrc = 2'b11; // J-type
            default:    ImmSrc = 2'b00; // I-type / R-type
        endcase
    end
endmodule