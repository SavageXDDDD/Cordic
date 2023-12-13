module register #(
    parameter DATA_WIDTH = 14
) 
(
    input logic clk,
    input logic rst,
    input logic en,
    input logic [DATA_WIDTH - 1 : 0] x,

    output logic [DATA_WIDTH - 1 : 0] y
);

always_ff @( posedge clk ) begin 
    if(rst)
        y = {DATA_WIDTH{1'b0}};
    else if(en)
        y = x;
end

endmodule
