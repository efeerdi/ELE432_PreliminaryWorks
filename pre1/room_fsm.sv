module room_fsm (
    input  logic clk,
    input  logic reset,
    input  logic n, s, e, w,     // Directional inputs
    input  logic has_sword,      // Signal from Sword FSM
    output logic [2:0] room,     // Current room output to Sword FSM
    output logic win,            // Game won output
    output logic die             // Game lost output
);

    // Define states using an enumerated type for readability
    typedef enum logic [2:0] {
        CC  = 3'b000, // Cave of Cacophony
        TT  = 3'b001, // Twisty Tunnel
        RR  = 3'b010, // Rapid River
        SSS = 3'b011, // Secret Sword Stash
        DD  = 3'b100, // Dragon's Den
        VV  = 3'b101, // Victory Vault
        GG  = 3'b110  // Grievous Graveyard
    } state_t;

    state_t state, next_state;

    // Assign current state to the output port
    assign room = state;

    // Sequential logic: Update state on clock edge or reset
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            state <= CC; // Game begins in Cave of Cacophony
        else
            state <= next_state;
    end

    // Combinational logic: Determine next state and outputs
    always_comb begin
        // Default assignments to prevent unintended latches [cite: 36]
        next_state = state; 
        win = 1'b0;
        die = 1'b0;

        case (state)
            CC:  if (e) next_state = TT;
            
            TT:  if (w) next_state = CC;
                 else if (s) next_state = RR;
                 
            RR:  if (n) next_state = TT;
                 else if (w) next_state = SSS;
                 else if (e) next_state = DD;
                 
            SSS: if (e) next_state = RR;
            
            DD:  if (has_sword) next_state = VV; // Safe passage with sword
                 else next_state = GG;           // Devoured by dragon without sword
                 
            VV:  begin
                 next_state = VV; // Remain in Vault until reset
                 win = 1'b1;
                 end
                 
            GG:  begin
                 next_state = GG; // Remain in Graveyard until reset
                 die = 1'b1;
                 end
                 
            default: next_state = CC;
        endcase
    end

endmodule