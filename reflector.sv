module reflector #(
    parameter B = 14,
    parameter N
)
(
    input logic [2 * B - 1 : 0] data_in,
    input logic reflect,
    input logic has_angle,

    output logic [2 * B - 1 : 0] data_out
);

parameter angle_len = N % 2 ? N + 1 : N;
parameter ext_bits  = angle_len / 2;
parameter coord_len = B - angle_len/2;
parameter msb_l     = 2 * B - 1;
parameter msb_r     = 2 * B - coord_len - 1;

always_comb begin
    if(~reflect) begin
        data_out <= data_in;
    end
    else begin
        if(has_angle) begin
            data_out[angle_len - 1 : 0] <= data_in[angle_len - 1 : 0];
            data_out[msb_l : msb_r - 1] <= $signed(- data_in[msb_l : msb_r - 1]);
            data_out[msb_r : angle_len] <= $signed(- data_in[msb_r : angle_len]);
        end
        else begin
            data_out[2 * B - 1 : B] <= $signed(- data_in[2 * B - 1 : B]);
            data_out[B - 1     : 0] <= $signed(- data_in[B - 1     : 0]);
        end
    end
    

end


endmodule