module adventure_game (
    input  logic clk,
    input  logic reset,
    input  logic n, s, e, w,
    output logic win,
    output logic die
);

    // Internal wires to connect the two FSMs 
    logic [2:0] current_room;
    logic sword_status;

    // Instantiate the Room FSM
    room_fsm U_ROOM (
        .clk(clk),
        .reset(reset),
        .n(n),
        .s(s),
        .e(e),
        .w(w),
        .has_sword(sword_status),
        .room(current_room),
        .win(win),
        .die(die)
    );

    // Instantiate the Sword FSM
    sword_fsm U_SWORD (
        .clk(clk),
        .reset(reset),
        .room(current_room),
        .has_sword(sword_status)
    );

endmodule