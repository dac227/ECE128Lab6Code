module debouncer(input  wire clk, input  wire btn_in, output reg btn_out);

    reg [2:0] counter;
    wire TC;

    always @(posedge clk) begin
        if(~btn_in)
            counter <= 3'b000;
        else 
            counter <= counter + 3'b001;
    end
    
    assign TC = (counter == 3'b111);
    
    always @(posedge clk) begin
        if(~btn_in)
            btn_out <= 1'b0;
        else if(TC)
            btn_out <= 1'b1;
    end
    
endmodule 
