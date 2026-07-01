module TB_CrowdControl ();

    // Inputs
    reg entry_sensor;
    reg exit_sensor;
    reg Clock;
    reg [6:0] space;
    reg [4:0] zone_A_count;
    reg [4:0] zone_B_count;
    reg [4:0] zone_C_count;
    reg [4:0] zone_D_count;

    // Outputs
    wire [6:0] people_count;
    wire [6:0] total;
    wire is_crowded;
    wire zone_crowded_A;
    wire zone_crowded_B;
    wire zone_crowded_C;
    wire zone_crowded_D;

    // Instantiate UUT
    CrowdControl uut (
        .people_count  (people_count),
        .total         (total),
        .is_crowded    (is_crowded),
        .zone_crowded_A(zone_crowded_A),
        .zone_crowded_B(zone_crowded_B),
        .zone_crowded_C(zone_crowded_C),
        .zone_crowded_D(zone_crowded_D),
        .entry_sensor  (entry_sensor),
        .exit_sensor   (exit_sensor),
        .Clock         (Clock),
        .space         (space),
        .zone_A_count  (zone_A_count),
        .zone_B_count  (zone_B_count),
        .zone_C_count  (zone_C_count),
        .zone_D_count  (zone_D_count)
    );

    // Clock generation
    initial begin
        Clock = 0;
        forever #5 Clock = ~Clock;
    end

    // Stimulus
    initial begin
        // Initial state
        entry_sensor  = 0;
        exit_sensor   = 0;
        space         = 100;
        zone_A_count  = 0;
        zone_B_count  = 0;
        zone_C_count  = 0;
        zone_D_count  = 0;
        #10;

        // Scenario 1: Two people enter, one exits
        entry_sensor = 1; #10; entry_sensor = 0; #10;
        entry_sensor = 1; #10; entry_sensor = 0;
        #10; exit_sensor = 1; #10; exit_sensor = 0;

        // Scenario 2: Brief spike in Zone A (should NOT trigger alert)
        zone_A_count = 15; #10;
        zone_A_count = 0;
        #20;

        // Scenario 3: Sustained crowd in Zone B (SHOULD trigger alert)
        zone_B_count = 15;
        #30;

        // Scenario 4: Multiple zones crowded
        zone_C_count = 17;
        zone_D_count = 16;
        #30;

        // Scenario 5: Zones return to safe levels
        zone_B_count = 4;
        zone_C_count = 3;
        zone_D_count = 2;
        #20;

        // Scenario 6: Reduce space to force is_crowded
        space = 20;
        #10;
        entry_sensor = 1; #10; entry_sensor = 0;
        entry_sensor = 1; #10; entry_sensor = 0;
        entry_sensor = 1; #10; entry_sensor = 0;
        entry_sensor = 1; #10; entry_sensor = 0;
        entry_sensor = 1; #10; entry_sensor = 0;

        // Scenario 7: Entry and exit simultaneously
        #10; entry_sensor = 1; exit_sensor = 1; #10;
        entry_sensor = 0; exit_sensor = 0;

        #20;
        $finish;
    end

endmodule
