module uart_rx(
    input clk,
    input rst,
    input rx,
    output reg [7:0] rx_data,
    output reg rx_done
);

parameter CLK_FREQ = 50000000;
parameter BAUD_RATE = 9600;
localparam BAUD_COUNT = CLK_FREQ / BAUD_RATE;

reg [15:0] baud_cnt;
reg baud_tick;

reg [3:0] bit_cnt;
reg [9:0] shift_reg;
reg receiving;

always @(posedge clk or negedge rst) begin
    if(!rst) begin
        baud_cnt <= 16'd0;
        baud_tick <= 1'b0;
    end
    else begin
        if(baud_cnt == BAUD_COUNT-1) begin
            baud_cnt <= 16'd0;
            baud_tick <= 1'b1;
        end
        else begin
            baud_cnt <= baud_cnt + 1'b1;
            baud_tick <= 1'b0;
        end
    end
end
always @(posedge clk or negedge rst) begin
    if(!rst) begin
        receiving <= 1'b0;
        bit_cnt   <= 4'd0;
        shift_reg <= 10'd0;
        rx_data   <= 8'd0;
        rx_done   <= 1'b0;
    end
    else begin
        rx_done <= 1'b0;

        if(!receiving) begin
            if(rx == 1'b0) begin
                receiving <= 1'b1;
                bit_cnt   <= 4'd0;
            end
        end
        else if(baud_tick) begin
            shift_reg[bit_cnt] <= rx;

            if(bit_cnt == 4'd9) begin
                receiving <= 1'b0;
                rx_data <= shift_reg[8:1];
                rx_done <= 1'b1;
            end
            else begin
                bit_cnt <= bit_cnt + 1'b1;
            end
        end
    end
end
endmodule