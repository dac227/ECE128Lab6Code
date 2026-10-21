`timescale 1ns / 1ps

module tb_debouncer;

    reg  clk;
    reg  btn_in;
    wire btn_out;

    // Instantiate the Unit Under Test (UUT)
    debouncer uut (
        .clk(clk),
        .btn_in(btn_in),
        .btn_out(btn_out)
    );

    always #5 clk = ~clk;

    initial begin
        // Initialize signals
        clk = 0;
        btn_in = 0;

        // Wait 20 ns for setup
        #20;

        btn_in = 1;
        #30; // High for 3 clock cycles
        btn_in = 0;
        #30; // Low for 3 clock cycles

        btn_in = 1;
        #40; // High for 4 clock cycles
        btn_in = 0;
        #30;

        btn_in = 1;
        #160; // High for 16 clock cycles

        btn_in = 0;
        #40;


        $finish;
    end


endmodule




