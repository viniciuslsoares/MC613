module top3(
  input CLOCK_50,
  input reset,

  // Conexões módulo VGA
  output wire VGA_CLK,
  output [7:0] VGA_R,
  output [7:0] VGA_G,
  output [7:0] VGA_B,
  output VGA_BLANK_N,
  output VGA_SYNC_N,

  output VGA_HS,
  output VGA_VS,

  // Botões para controle
  input right_but,
  input up_but,
  input down_but,
  input left_but

);
  reg [10:0] x_pos;
  reg [10:0] y_pos;

  parameter [6:0] STEP = 16;
  parameter [6:0] SIZE = 16;

  wire [10:0] x_coord;
  wire [10:0] y_coord;

  reg [7:0] R_value;
  reg [7:0] G_value;
  reg [7:0] B_value;

  reg [2:0] last_button;

  wire [7:0] top_R;
  wire [7:0] top_G;
  wire [7:0] top_B;

  vga vga_base(
    .CLOCK_50(CLOCK_50),
    .reset(reset),
    .top_R(top_R),
    .top_G(top_G),
    .top_B(top_B),
    .VGA_CLK(VGA_CLK),
    .VGA_R(VGA_R),
    .VGA_G(VGA_G),
    .VGA_B(VGA_B),
    .VGA_BLANK_N(VGA_BLANK_N),
    .VGA_SYNC_N(VGA_SYNC_N),
    .VGA_HS(VGA_HS),
    .VGA_VS(VGA_VS),
    .x_coord(x_coord),
    .y_coord(y_coord)
  );

  // Cor do fundo.
  assign top_R = ((x_coord > x_pos) && (x_coord <= (x_pos+SIZE)) && (y_coord > y_pos) && (y_coord <= (y_pos+SIZE))) ? 255 : 30;
  assign top_G = ((x_coord > x_pos) && (x_coord <= (x_pos+SIZE)) && (y_coord > y_pos) && (y_coord <= (y_pos+SIZE))) ? 0 : 30;
  assign top_B = ((x_coord > x_pos) && (x_coord <= (x_pos+SIZE)) && (y_coord > y_pos) && (y_coord <= (y_pos+SIZE))) ? 0 : 30;

  always @(posedge VGA_CLK) begin

    if (reset == 0) begin
      R_value = 0;
      G_value = 0;
      B_value = 0;
      x_pos = (320 - (SIZE/2));
      y_pos = (240 - (SIZE/2));
      last_button = 3'b111;
      end

    else begin
        if (!up_but | !down_but | !left_but | !right_but) begin
          if (!up_but) begin
            last_button = 3'b000;
            end
          else if (!down_but) begin
            last_button = 3'b001;
            end
          else if (!left_but) begin
            last_button = 3'b010;
            end
          else if (!right_but) begin
            last_button = 3'b011;
            end
          end

        else begin
          if (last_button != 3'b111) begin
            case (last_button)
              3'b000:  begin  // UP
                if (y_pos < STEP) y_pos = (480 - SIZE);
                else y_pos = y_pos - STEP;
                end
              3'b001: begin // DOWN
                if (y_pos + STEP > 479) y_pos = 0;
                else y_pos = y_pos + STEP;
                end
              3'b010: begin // LEFT
                if (x_pos < STEP) x_pos = (640 - SIZE);
                else x_pos = x_pos - STEP;
                end
              3'b011: begin // Right
                if (x_pos + STEP > 639) x_pos = 0;
                else x_pos = x_pos + STEP;
                end
              endcase 
            last_button = 3'b111;
            end
          end 
      end
    end


endmodule
