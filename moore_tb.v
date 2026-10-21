`timescale 1ns / 1ps

module testbench;

    // Inputs to UUT
    reg P1;
    reg clk;
    reg reset;

    // Output from UUT
    wire z;

    // Instantiate the Unit Under Test (UUT)
    seq_detector uut (
        .P1(P1),
        .clk(clk),
        .reset(reset),
        .z(z)
    );

    // Clock Generation: 10 ns period (50 MHz)
    always #5 clk = ~clk;

    // Reset Initialization
    initial begin
        clk = 1'b0;
        reset = 1'b1;
        #15 reset = 1'b0; // Release reset after 15 ns
    end

    // Stimulus Pattern
    initial begin
        P1 = 1'b0;
        
        // Wait until reset is released
        #15;

        // Apply input bit sequence: 1 -> 1 -> 0 -> 0 (Valid 1100)
        #10 P1 = 1'b1;
        #10 P1 = 1'b1;
        #10 P1 = 1'b0;
        #10 P1 = 1'b0; // Output 'z' goes HIGH on the next clock edge (State S4)

        // Apply reset / break sequence: 1 -> 1 -> 1 -> 0 -> 0 (Valid 1100 after delay)
        #10 P1 = 1'b1;
        #10 P1 = 1'b1;
        #10 P1 = 1'b1; // Remains in S2
        #10 P1 = 1'b0;
        #10 P1 = 1'b0; // 'z' goes HIGH again

        // Idle state
        #10 P1 = 1'b0;
        #20 $finish;
    end

    // Monitor Output in Console
    initial begin
        $monitor("Time = %0t ns | clk = %b | reset = %b | P1 = %b | PS = %b | z = %b", 
                 $time, clk, reset, P1, uut.PS, z);
    end

endmodule
