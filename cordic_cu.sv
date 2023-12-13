module cordic_cu #(
    parameter N = 7
)
(
    input logic clk,
    input logic rst,
    input logic en,

    output logic [$clog2(N) - 1 : 0] cnt,
    output logic [8 : 1]  c,
    output logic busy
);

logic [$clog2(N) - 1 : 0] counter;

enum logic [2 : 0]
{
   IDLE = 'b0, //all disabled, not busy
   START = 'b1, //record reg_r, reg_l, reg_angle, busy
   STABLE_RUNNING = 'b10, //record reg_r, reg_l, busy
   INCREMENT = 'b11, // increment counter, busy
   SCALE_X = 'b100, //record reg_r, reg_l, reg_x, busy
   SCALE_Y = 'b101 //record reg_y, busy
}
state, next_state;

always_ff @( posedge clk ) begin

    if (rst)
        state <= IDLE;
    else 
        state <= next_state;
end

always_comb begin 
  next_state = state;
  case (state)
    IDLE : begin 
        c <= 0;
      if (en) begin 
        next_state = START;
      end else begin
        next_state = IDLE; 
      end
    end 
    START : begin   
      if (~en) begin 
        next_state <= IDLE;
        c <= 0;
      end else begin 
        next_state <= STABLE_RUNNING; 
        c <= 'b10000011;
      end
    end
    STABLE_RUNNING : begin
        if (~en) begin 
            next_state <= IDLE;
            c <= 0;
        end else begin 
            next_state <= INCREMENT; 
            c <= 'b00000010;
      end
    end
    INCREMENT : begin
        if (~en) begin 
            next_state <= IDLE;
            c <= 0;
        end else begin 
            next_state <= SCALE_X; 
            c <= 'b00000000;
      end
    end
    SCALE_X : begin
        if (~en) begin 
            next_state <= IDLE;
            c <= 0;
        end else begin 
            if(counter == N)
                next_state <= SCALE_Y; 
            else
                next_state <= STABLE_RUNNING;
            c <= 'b00100000;
      end
    end
    SCALE_Y : begin
            next_state <= IDLE;
        if (~en) begin 
            c <= 0;
        end else begin 
            c <= 'b01010000;
      end
    end
  endcase
end

always_ff @(posedge clk) begin 
  if (rst | (counter == N))
    counter <= 'h0;
  else if (state == INCREMENT) 
    counter <= counter + 1;
end

assign cnt = counter; 
assign busy = state != IDLE;

endmodule