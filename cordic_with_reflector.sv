module cordic_with_reflector #(
    parameter B = 14,
    parameter N = 7
)
(
    input logic [2 * B - 1 : 0] data_w,
    input logic clk,
    input logic rst,
    input logic en,

    output logic busy,
    output logic [2 * B - 1 : 0] data_r
);

logic [2 * B - 1 : 0] reflector_out;
logic [2 * B - 1 : 0] cordic_out;

cordic_top #(
    .B(B),
    .N(N)
) cordic_without_reflector
(
    .data_w(reflector_out),
    .clk(clk),
    .rst(rst),
    .en(en),

    .busy(busy),
    .data_r(cordic_out)
);

reflector #(
    .B(B),
    .N(N)
) in_reflector
(
    .data_in(data_w),
    .reflect(data_w[2 * B - 1]),
    .has_angle(1),

    .data_out(reflector_out)
);

reflector #(
    .B(B),
    .N(N)
) out_reflector
(
    .data_in(cordic_out),
    .reflect(data_w[2 * B - 1]),
    .has_angle(0),

    .data_out(data_r)
);

endmodule