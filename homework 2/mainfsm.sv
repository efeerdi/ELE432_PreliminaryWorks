module mainfsm (
    input  logic       clk,
    input  logic       reset,
    input  logic [6:0] op,
    output logic       AdrSrc,
    output logic       IRWrite,
    output logic [1:0] ALUSrcA,
    output logic [1:0] ALUSrcB,
    output logic [1:0] ALUOp,
    output logic [1:0] ResultSrc,
    output logic       PCUpdate,
    output logic       Branch,
    output logic       RegWrite,
    output logic       MemWrite
);

    typedef enum logic [3:0] {
        FETCH    = 4'd0,
        DECODE   = 4'd1,
        MEMADR   = 4'd2,
        MEMREAD  = 4'd3,
        MEMWB    = 4'd4,
        MEMWRITE = 4'd5,
        EXECUTER = 4'd6,
        ALUWB    = 4'd7,
        EXECUTEI = 4'd8,
        JAL      = 4'd9,
        BEQ      = 4'd10
    } statetype;

    statetype state, nextstate;

    // State Register
    always_ff @(posedge clk or posedge reset) begin
        if (reset) state <= FETCH;
        else       state <= nextstate;
    end

    // Next State Logic
    always_comb begin
        case (state)
            FETCH:    nextstate = DECODE;
            DECODE: begin
                case (op)
                    7'b0000011: nextstate = MEMADR;   // lw
                    7'b0100011: nextstate = MEMADR;   // sw
                    7'b0110011: nextstate = EXECUTER; // R-type
                    7'b0010011: nextstate = EXECUTEI; // I-type ALU
                    7'b1101111: nextstate = JAL;      // jal
                    7'b1100011: nextstate = BEQ;      // beq
                    default:    nextstate = FETCH;
                endcase
            end
            MEMADR: begin
                if (op == 7'b0000011)      nextstate = MEMREAD; // lw
                else if (op == 7'b0100011) nextstate = MEMWRITE;// sw
                else                       nextstate = FETCH;
            end
            MEMREAD:  nextstate = MEMWB;
            MEMWB:    nextstate = FETCH;
            MEMWRITE: nextstate = FETCH;
            EXECUTER: nextstate = ALUWB;
            ALUWB:    nextstate = FETCH;
            EXECUTEI: nextstate = ALUWB;
            JAL:      nextstate = ALUWB;
            BEQ:      nextstate = FETCH;
            default:  nextstate = FETCH;
        endcase
    end

    // Output Logic 
    always_comb begin
        AdrSrc    = 1'b0;
        IRWrite   = 1'b0;
        ALUSrcA   = 2'b00;
        ALUSrcB   = 2'b00;
        ALUOp     = 2'b00;
        ResultSrc = 2'b00;
        PCUpdate  = 1'b0;
        Branch    = 1'b0;
        RegWrite  = 1'b0;
        MemWrite  = 1'b0;

        case (state)
            FETCH: begin
                AdrSrc    = 1'b0;
                IRWrite   = 1'b1;
                ALUSrcA   = 2'b00;
                ALUSrcB   = 2'b10;
                ALUOp     = 2'b00;
                ResultSrc = 2'b10;
                PCUpdate  = 1'b1;
            end
            DECODE: begin
                ALUSrcA   = 2'b01;
                ALUSrcB   = 2'b01;
                ALUOp     = 2'b00;
            end
            MEMADR: begin
                ALUSrcA   = 2'b10;
                ALUSrcB   = 2'b01;
                ALUOp     = 2'b00;
            end
            MEMREAD: begin
                ResultSrc = 2'b00;
                AdrSrc    = 1'b1;
            end
            MEMWB: begin
                ResultSrc = 2'b01;
                RegWrite  = 1'b1;
            end
            MEMWRITE: begin
                ResultSrc = 2'b00;
                AdrSrc    = 1'b1;
                MemWrite  = 1'b1;
            end
            EXECUTER: begin
                ALUSrcA   = 2'b10;
                ALUSrcB   = 2'b00;
                ALUOp     = 2'b10;
            end
            ALUWB: begin
                ResultSrc = 2'b00;
                RegWrite  = 1'b1;
            end
            EXECUTEI: begin
                ALUSrcA   = 2'b10;
                ALUSrcB   = 2'b01;
                ALUOp     = 2'b10;
            end
            JAL: begin
                ALUSrcA   = 2'b01;
                ALUSrcB   = 2'b10;
                ALUOp     = 2'b00;
                ResultSrc = 2'b00;
                PCUpdate  = 1'b1;
            end
            BEQ: begin
                ALUSrcA   = 2'b10;
                ALUSrcB   = 2'b00;
                ALUOp     = 2'b01;
                ResultSrc = 2'b00;
                Branch    = 1'b1;
            end
        endcase
    end
endmodule