`timescale 1ns/1ps

module morphatn (
    input wire clk,
    input wire reset,
    input wire start,
    input wire signed [3:0] query,
    input wire signed [3:0] key,
    output reg signed [9:0] accumulator,
    output reg busy,
    output reg done
);
wire signed [7:0] prod;
assign prod = query*key;
reg[1:0]pairIndex;
always @(posedge clk) begin
    done<=1'b0;
    if (reset) begin
        pairIndex<=2'd0;
        busy<=1'b0;
        accumulator<=10'sd0;
    end else if (!busy) begin
        if (start) begin
            pairIndex<=2'd0;
            busy<=1'b1;
            accumulator<=10'sd0;
        end
        
    end else begin
            pairIndex<=pairIndex+2'd1;
            accumulator<=accumulator+prod;
        if (pairIndex==2'd3) begin
            busy<=1'b0;
            done<=1'b1;
        end
    end
end
endmodule
