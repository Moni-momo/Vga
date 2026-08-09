module baud_generator(
    input clk,
    input rst,
    output reg tick
);

parameter CLK_FREQ = 50000000;
parameter BAUD_RATE = 9600;
localparam COUNT_MAX = CLK_FREQ / BAUD_RATE;

reg [15:0] count;

always @(posedge clk or negedge rst) begin
    if(!rst) begin
        count <= 16'd0;
        tick <= 1'b0;
    end
    else begin
        if(count == COUNT_MAX-1) begin
            count <= 16'd0;
            tick <= 1'b1;
        end
        else begin
            count <= count + 1'b1;
            tick <= 1'b0;
        end
    end
end

endmodule