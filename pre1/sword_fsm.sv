module sword_fsm (
    input  logic clk,
    input  logic reset,
    input  logic [2:0] room,     // Current room from Room FSM
    output logic has_sword       // Output indicating if player has the sword
);

    // Sequential logic to remember if the sword has been picked up
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            has_sword <= 1'b0;   // No sword at the beginning
        end 
        // 3'b011 corresponds to Secret Sword Stash (SSS)
        else if (room == 3'b011) begin 
            has_sword <= 1'b1;   // Sword acquired
        end
        // If already 1, it stays 1 (inferred by omission of else statement)
    end

endmodule