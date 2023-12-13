module cordic_top #(
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

logic [8 : 1] cnt;
logic [$clog2(N) - 1 : 0] c;


cordic_core #(
    .B(B),
    .N(N)
) core
(
    .clk(clk),
    .data_w(data_w),
    .rst(rst),
    .cnt(cnt),
    .c(c),
    .data_r(data_r)
);

cordic_cu #(
    .N(N)
) cu
(
    .clk(clk),
    .rst(rst),
    .en(en),
    .cnt(cnt),
    .c(c),
    .busy(busy)
);

endmodule