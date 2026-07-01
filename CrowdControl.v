module CrowdControl (
    // Outputs
    people_count,
    is_crowded,
    zone_crowded_A,
    zone_crowded_B,
    zone_crowded_C,
    zone_crowded_D,
    total,
    // Inputs
    entry_sensor,
    exit_sensor,
    Clock,
    space,
    zone_A_count,
    zone_B_count,
    zone_C_count,
    zone_D_count
);

// Outputs
output reg [6:0] people_count;
output reg [6:0] total;
output reg is_crowded;
output reg zone_crowded_A;
output reg zone_crowded_B;
output reg zone_crowded_C;
output reg zone_crowded_D;

// Inputs
input entry_sensor;
input exit_sensor;
input Clock;
input [6:0] space;
input [4:0] zone_A_count;
input [4:0] zone_B_count;
input [4:0] zone_C_count;
input [4:0] zone_D_count;

// Parameters
parameter PEOPLE_PER_UNIT = 2;
parameter MAX_CROWD_TIME  = 3;

// Internal registers
reg [6:0] people_limit;
reg [4:0] zone_limit;
reg [1:0] zone_A_timer;
reg [1:0] zone_B_timer;
reg [1:0] zone_C_timer;
reg [1:0] zone_D_timer;

initial begin
    people_count  = 0;
    total         = 0;
    is_crowded    = 0;
    zone_crowded_A = 0;
    zone_crowded_B = 0;
    zone_crowded_C = 0;
    zone_crowded_D = 0;
    zone_A_timer  = 0;
    zone_B_timer  = 0;
    zone_C_timer  = 0;
    zone_D_timer  = 0;
end

always @(posedge Clock) begin

    // Calculate limits
    people_limit = space / PEOPLE_PER_UNIT;
    zone_limit   = people_limit / 4;

    // Entry and exit logic
    if (entry_sensor && people_count < 7'd127)
        people_count = people_count + 1;
    if (exit_sensor && people_count > 0)
        people_count = people_count - 1;

    // General crowding check
    is_crowded = (people_count >= people_limit) ? 1 : 0;

    // Zone A
    if (zone_A_count >= zone_limit) begin
        if (zone_A_timer < MAX_CROWD_TIME)
            zone_A_timer = zone_A_timer + 1;
        if (zone_A_timer == MAX_CROWD_TIME)
            zone_crowded_A = 1;
    end else begin
        zone_A_timer   = 0;
        zone_crowded_A = 0;
    end

    // Zone B
    if (zone_B_count >= zone_limit) begin
        if (zone_B_timer < MAX_CROWD_TIME)
            zone_B_timer = zone_B_timer + 1;
        if (zone_B_timer == MAX_CROWD_TIME)
            zone_crowded_B = 1;
    end else begin
        zone_B_timer   = 0;
        zone_crowded_B = 0;
    end

    // Zone C
    if (zone_C_count >= zone_limit) begin
        if (zone_C_timer < MAX_CROWD_TIME)
            zone_C_timer = zone_C_timer + 1;
        if (zone_C_timer == MAX_CROWD_TIME)
            zone_crowded_C = 1;
    end else begin
        zone_C_timer   = 0;
        zone_crowded_C = 0;
    end

    // Zone D
    if (zone_D_count >= zone_limit) begin
        if (zone_D_timer < MAX_CROWD_TIME)
            zone_D_timer = zone_D_timer + 1;
        if (zone_D_timer == MAX_CROWD_TIME)
            zone_crowded_D = 1;
    end else begin
        zone_D_timer   = 0;
        zone_crowded_D = 0;
    end

    // Total count
    total = people_count + zone_A_count + zone_B_count + zone_C_count + zone_D_count;

end

endmodule
