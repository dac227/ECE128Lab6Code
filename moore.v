`timescale 1ns / 1ps

module seq_detector(
    input wire P1,       // Serial input bit stream
    input wire clk,      // Clock signal
    input wire reset,    // Asynchronous reset
    output reg z         // Output signal (1 when "1100" detected)
);

    // State Encoding (3 bits needed for 5 states)
    parameter S0 = 3'b000,
              S1 = 3'b001,
              S2 = 3'b010,
              S3 = 3'b011,
              S4 = 3'b100;

    reg [2:0] PS, NS; // Present State, Next State

    // 1. Sequential Logic: State Register Update
    always @(posedge clk or posedge reset) begin
        if (reset)
            PS <= S0;
        else
            PS <= NS;
    end

    // 2. Combinational Logic: Output Logic (Depends ONLY on Present State)
    always @(PS) begin
        case (PS)
            S0: z = 1'b0;
            S1: z = 1'b0;
            S2: z = 1'b0;
            S3: z = 1'b0;
            S4: z = 1'b1; // Sequence 1100 detected
            default: z = 1'b0;
        endcase
    end

    // 3. Combinational Logic: Next State Logic
    always @(PS or P1) begin
        case (PS)
            S0: begin
                if (P1)
                    NS = S1;
                else
                    NS = S0;
            end

            S1: begin
                if (P1)
                    NS = S2;
                else
                    NS = S0;
            end

            S2: begin
                if (!P1)
                    NS = S3;
                else
                    NS = S2; // Stays in S2 if continuous 1s received
            end

            S3: begin
                if (!P1)
                    NS = S4; // Completes "1100"
                else
                    NS = S1; // "1101" -> '1' can start next sequence
            end

            S4: begin
                if (P1)
                    NS = S1; // '1' can start new sequence
                else
                    NS = S0;
            end

            default: NS = S0;
        endcase
    end

endmodule

