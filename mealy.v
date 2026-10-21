`timescale 1ns / 1ps

module seq_detector (
    input wire P1,       // Serial input bit stream
    input wire clk,      // Clock signal
    input wire reset,    // Asynchronous reset
    output reg z         // Output signal (1 when "1101" detected)
);

    // State Encoding (2 bits for 4 states)
    parameter S0 = 2'b00,
              S1 = 2'b01,
              S2 = 2'b10,
              S3 = 2'b11;

    reg [1:0] PS, NS;

    // 1. Sequential Logic: State Register Update 
    always @(posedge clk or posedge reset) begin 
        if (reset) 
            PS <= S0; 
        else
            PS <= NS; 
    end

    // 2. Combinational Logic: Next State and Mealy Output Logic 
    always @(PS or P1) begin 
        z = 1'b0; // Default output 

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
                if (P1)
                    NS = S2; // Self-loop if continuous 1s arrive  
                else
                    NS = S3;   
            end

            S3: begin 
                if (P1) begin
                    z = 1'b1;  // "1101" detected!   
                    NS = S1;   // Overlapping: transition to S1  
                end else begin
                    NS = S0;  
                end
            end

            default: begin
                z = 1'b0;
                NS = S0;
            end
        endcase
    end

endmodule








