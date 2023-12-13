module scaler #(
    parameter DATA_WIDTH = 14
)
(
    input logic [DATA_WIDTH - 1 : 0] data_in,

    output logic [DATA_WIDTH - 1 : 0] data_out
);
    logic [DATA_WIDTH - 1 : 0] r1;
    logic [DATA_WIDTH - 1 : 0] r3;
    logic [DATA_WIDTH - 1 : 0] r6;
    logic [DATA_WIDTH - 1 : 0] r9;
    logic [DATA_WIDTH - 1 : 0] r13;

    assign r1 = $signed(data_in) >> 1;
    assign r3 = $signed(data_in) >> 3;
    assign r6 = $signed(data_in) >> 6;
    assign r9 = $signed(data_in) >> 9;
    assign r13 = $signed(data_in) >> 13;

    assign data_out = $signed(r1 + r3 - r6 - r9 - r13);

endmodule