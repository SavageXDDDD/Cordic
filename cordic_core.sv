module cordic_core #(
    parameter B = 14,
    parameter N = 7
)
(
    input logic [2 * B - 1 : 0] data_w,
    input logic [8 : 1]  c,
    input logic [$clog2(N) - 1 : 0] cnt,
    input logic clk,
    input logic rst,

    output logic [2 * B - 1 : 0] data_r
);

parameter angle_len = N % 2 ? N + 1 : N;
parameter ext_bits  = angle_len / 2;
parameter coord_len = B - angle_len/2;
parameter msb_l     = 2 * B - 1;
parameter msb_r     = 2 * B - coord_len - 1;

logic [B - 1 : 0] scaler_out;
logic [B - 1 : 0] mux_r_out;
logic [B - 1 : 0] mux_l_out;
logic [B - 1 : 0] reg_r_out;
logic [B - 1 : 0] reg_l_out;
logic [B - 1 : 0] shift_r_out;
logic [B - 1 : 0] shift_l_out;
logic [B - 1 : 0] addsub_r_out;
logic [B - 1 : 0] addsub_l_out;
logic [B - 1 : 0] mux_mid;
logic [angle_len - 1 : 0] angle;

assign mux_l_out = c[1] ? {{ext_bits{data_w[msb_l]}},{data_w[msb_l : msb_r + 1]}} : addsub_l_out;
assign mux_r_out = c[1] ? {{ext_bits{data_w[msb_r]}},{data_w[msb_r : angle_len]}} : addsub_r_out;
assign shift_l_out = $signed (reg_l_out) >>> cnt;
assign shift_r_out = $signed (reg_r_out) >>> cnt;
assign addsub_l_out = angle[cnt]? $signed(reg_l_out - shift_l_out) : $signed(reg_l_out + shift_l_out);        
assign addsub_r_out = angle[cnt]? $signed(reg_r_out - shift_r_out) : $signed(reg_r_out + shift_r_out);
assign mux_mid = c[5] ? addsub_r_out : addsub_l_out;

register #(
    .DATA_WIDTH(B)
) reg_l
(
    .clk(clk),
    .rst(rst),
    .en(c[2]),
    .x(mux_l_out),
    .y(reg_l_out)
);

register #(
    .DATA_WIDTH(B)
) reg_r
(
    .clk(clk),
    .rst(rst),
    .en(c[2]),
    .x(mux_r_out),
    .y(reg_r_out)
);

register #(
    .DATA_WIDTH(B)
) reg_x
(
    .clk(clk),
    .rst(rst),
    .en(c[6]),
    .x(scaler_out),
    .y(data_r[2 * B - 1 : B])
);

register #(
    .DATA_WIDTH(B)
) reg_y
(
    .clk(clk),
    .rst(rst),
    .en(c[7]),
    .x(scaler_out),
    .y(data_r[B - 1 : 0])
);

register #(
    .DATA_WIDTH(angle_len)
) reg_angle
(
    .clk(clk),
    .rst(rst),
    .en(c[8]),
    .x(data_w[angle_len - 1 : 0]),
    .y(angle)
);

scaler scaler(
    .data_in(mux_mid),
    .data_out(scaler_out)
);


endmodule