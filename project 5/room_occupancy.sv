module room_occupancy #(
    parameter integer MAX_CAPACITY = 10
)(
    input  logic clk,
    input  logic reset,
    input  logic entry,
    input  logic exit,

    output logic [$clog2(MAX_CAPACITY + 1)-1:0] occupancy,
    output logic full,
    output logic empty
);

    // Occupancy counter
    always_ff @(posedge clk) begin
        if (reset) begin
            occupancy <= '0;
        end
        else begin

            // Person enters
            if (entry && !exit) begin
                if (occupancy < MAX_CAPACITY)
                    occupancy <= occupancy + 1'b1;
            end

            // Person exits
            else if (exit && !entry) begin
                if (occupancy > 0)
                    occupancy <= occupancy - 1'b1;
            end

            // If entry and exit happen together,
            // occupancy remains unchanged.
            else begin
                occupancy <= occupancy;
            end
        end
    end

    // Status signals
    always_comb begin
        if (occupancy == 0)
            empty = 1'b1;
        else
            empty = 1'b0;

        if (occupancy == MAX_CAPACITY)
            full = 1'b1;
        else
            full = 1'b0;
    end

endmodule
