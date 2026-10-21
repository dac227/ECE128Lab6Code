`timescale 1ns / 1ps    

module testbench;    

    // Inputs to UUT    
    reg P1;
    reg clk;
    reg reset;

    // Output from UUT    
    wire z;

    // Instantiate Unit Under Test    
    seq_detector uut (
        .P1(P1),
        .clk(clk),
        .reset(reset),
        .z(z)
    );    

    // Clock Generation: 10 ns period    
    always #5 clk = ~clk;    

    // Reset Initialization    
    initial begin
        clk = 1'b0;    
        reset = 1'b1;    
        #15 reset = 1'b0; // Release reset    
    end

    // Stimulus Pattern
    initial begin
        P1 = 1'b0;
        #15; // Wait for reset release

        // First 1101 sequence
        #10 P1 = 1'b1; // Bit 1 -> S1
        #10 P1 = 1'b1; // Bit 1 -> S2
        #10 P1 = 1'b0; // Bit 0 -> S3
        #10 P1 = 1'b1; // Bit 1 -> z=1, transitions to S1 (Overlap)

        // Continuation using the overlapping '1' -> 101 (completes second 1101)
        #10 P1 = 1'b1; // Bit 1 -> S2
        #10 P1 = 1'b0; // Bit 0 -> S3
        #10 P1 = 1'b1; // Bit 1 -> z=1 again!

        // Reset pattern
        #10 P1 = 1'b0;
        #20 $finish;    
    end

    // Monitor Output
    initial begin
        $monitor("Time = %0t ns | clk = %b | reset = %b | P1 = %b | State = %b | z = %b", 
                 $time, clk, reset, P1, uut.PS, z);
    end

endmodule
