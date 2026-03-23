`timescale 1ns / 1ps

module tb_adventure_game();

    // Testbench signals
    logic clk;
    logic reset;
    logic n, s, e, w;
    logic win, die;

    // Instantiate the Top-Level Module (Device Under Test)
    adventure_game dut (
        .clk(clk),
        .reset(reset),
        .n(n),
        .s(s),
        .e(e),
        .w(w),
        .win(win),
        .die(die)
    );

    // Clock generation: 10ns period
    always begin
        clk = 1'b0; #5;
        clk = 1'b1; #5;
    end

    // Task to apply a directional input for one clock cycle
    task move(input logic n_in, input logic s_in, input logic e_in, input logic w_in);
        begin
            n = n_in; s = s_in; e = e_in; w = w_in;
            @(posedge clk);
            #1; // Small delay to check after the clock edge
            n = 0; s = 0; e = 0; w = 0; // Clear inputs
        end
    endtask

    // Main Test Sequence
    initial begin
        // Initialize all inputs
        n = 0; s = 0; e = 0; w = 0;
        
        // --------------------------------------------------------
        // TEST CASE 1: The Winning Scenario
        // --------------------------------------------------------
        $display("Starting TEST CASE 1: The Winning Path...");
        reset = 1; @(posedge clk); #1;
        reset = 0;
        
        move(0, 0, 1, 0); // E: Cave to Twisty Tunnel
        move(0, 1, 0, 0); // S: Twisty Tunnel to Rapid River
        move(0, 0, 0, 1); // W: Rapid River to Secret Sword Stash (Gets Sword)
        move(0, 0, 1, 0); // E: Secret Sword Stash back to Rapid River
        move(0, 0, 1, 0); // E: Rapid River to Dragon's Den
        @(posedge clk); #1; // Wait one cycle for Dragon's Den evaluation to Vault
        
        // Self-Checking for Win
        if (win === 1'b1 && die === 1'b0)
            $display("SUCCESS: Game Won correctly!");
        else
            $display("ERROR: Game should be won but isn't.");

        #20; // Wait a bit before starting the next game

        // --------------------------------------------------------
        // TEST CASE 2: The Dying Scenario
        // --------------------------------------------------------
        $display("Starting TEST CASE 2: The Dying Path...");
        reset = 1; @(posedge clk); #1; // Reset game 
        reset = 0;
        
        move(0, 0, 1, 0); // E: Cave to Twisty Tunnel
        move(0, 1, 0, 0); // S: Twisty Tunnel to Rapid River
        move(0, 0, 1, 0); // E: Rapid River to Dragon's Den (No Sword!)
        @(posedge clk); #1; // Wait one cycle for Dragon's Den evaluation to Graveyard
        
        // Self-Checking for Die
        if (die === 1'b1 && win === 1'b0)
            $display("SUCCESS: Player died correctly!");
        else
            $display("ERROR: Player should have died but didn't.");

        #20;
        $display("All tests completed.");
        $stop; // Stop simulation
    end

endmodule