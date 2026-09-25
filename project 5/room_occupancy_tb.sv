`timescale 1ns/1ps

module room_occupancy_tb;

    parameter integer MAX_CAPACITY = 10;

    logic clk;
    logic reset;
    logic entry;
    logic exit;

    logic [$clog2(MAX_CAPACITY + 1)-1:0] occupancy;
    logic full;
    logic empty;

    // Instantiate DUT
    room_occupancy #(
        .MAX_CAPACITY(MAX_CAPACITY)
    ) dut (
        .clk(clk),
        .reset(reset),
        .entry(entry),
        .exit(exit),
        .occupancy(occupancy),
        .full(full),
        .empty(empty)
    );

    // Clock generation
    initial begin
        clk = 1'b0;

        forever #5 clk = ~clk;
    end

    // Task to check occupancy
    task check_occupancy(input integer expected);
        begin
            if (occupancy !== expected) begin
                $display(
                    "ERROR: Time=%0t | Expected occupancy=%0d | Actual occupancy=%0d",
                    $time, expected, occupancy
                );
            end
            else begin
                $display(
                    "PASS : Time=%0t | Occupancy=%0d",
                    $time, occupancy
                );
            end
        end
    endtask

    initial begin

        // Create waveform file
        $dumpfile("occupancy.vcd");
        $dumpvars(0, room_occupancy_tb);

        // Initial values
        reset = 1'b1;
        entry = 1'b0;
        exit  = 1'b0;

        // Reset
        #10;
        check_occupancy(0);

        reset = 1'b0;

        // ------------------------------------------------
        // TEST 1: One person enters
        // ------------------------------------------------

        @(negedge clk);
        entry = 1'b1;
        exit  = 1'b0;

        @(posedge clk);
        #1;
        check_occupancy(1);

        // ------------------------------------------------
        // TEST 2: Second person enters
        // ------------------------------------------------

        @(negedge clk);
        entry = 1'b1;

        @(posedge clk);
        #1;
        check_occupancy(2);

        // ------------------------------------------------
        // TEST 3: Third person enters
        // ------------------------------------------------

        @(negedge clk);
        entry = 1'b1;

        @(posedge clk);
        #1;
        check_occupancy(3);

        // Stop entry
        @(negedge clk);
        entry = 1'b0;

        // ------------------------------------------------
        // TEST 4: One person exits
        // ------------------------------------------------

        @(negedge clk);
        exit = 1'b1;

        @(posedge clk);
        #1;
        check_occupancy(2);

        // ------------------------------------------------
        // TEST 5: Another person exits
        // ------------------------------------------------

        @(negedge clk);

        @(posedge clk);
        #1;
        check_occupancy(1);

        // ------------------------------------------------
        // TEST 6: Last person exits
        // ------------------------------------------------

        @(negedge clk);

        @(posedge clk);
        #1;
        check_occupancy(0);

        // Stop exit
        @(negedge clk);
        exit = 1'b0;

        // ------------------------------------------------
        // TEST 7: Exit when room is empty
        // ------------------------------------------------

        @(negedge clk);
        exit = 1'b1;

        @(posedge clk);
        #1;
        check_occupancy(0);

        @(negedge clk);
        exit = 1'b0;

        // ------------------------------------------------
        // TEST 8: Multiple people enter
        // ------------------------------------------------

        repeat (5) begin
            @(negedge clk);
            entry = 1'b1;

            @(posedge clk);
            #1;
        end

        @(negedge clk);
        entry = 1'b0;

        #1;
        check_occupancy(5);

        // ------------------------------------------------
        // TEST 9: Simultaneous entry and exit
        // ------------------------------------------------

        @(negedge clk);
        entry = 1'b1;
        exit  = 1'b1;

        @(posedge clk);
        #1;
        check_occupancy(5);

        @(negedge clk);
        entry = 1'b0;
        exit  = 1'b0;

        // ------------------------------------------------
        // TEST 10: Reach maximum capacity
        // ------------------------------------------------

        repeat (5) begin
            @(negedge clk);
            entry = 1'b1;

            @(posedge clk);
            #1;
        end

        @(negedge clk);
        entry = 1'b0;

        #1;
        check_occupancy(MAX_CAPACITY);

        // Check FULL flag
        if (full !== 1'b1)
            $display("ERROR: FULL flag should be 1");
        else
            $display("PASS : FULL flag is 1");

        // ------------------------------------------------
        // TEST 11: Entry when room is full
        // ------------------------------------------------

        @(negedge clk);
        entry = 1'b1;

        @(posedge clk);
        #1;
        check_occupancy(MAX_CAPACITY);

        @(negedge clk);
        entry = 1'b0;

        // ------------------------------------------------
        // TEST 12: Leave from full room
        // ------------------------------------------------

        @(negedge clk);
        exit = 1'b1;

        @(posedge clk);
        #1;
        check_occupancy(MAX_CAPACITY - 1);

        @(negedge clk);
        exit = 1'b0;

        // ------------------------------------------------
        // Final status check
        // ------------------------------------------------

        $display("----------------------------------------");
        $display("Simulation completed successfully.");
        $display("Final occupancy = %0d", occupancy);
        $display("Full            = %b", full);
        $display("Empty           = %b", empty);
        $display("----------------------------------------");

        #10;

        $finish;
    end

endmodule
