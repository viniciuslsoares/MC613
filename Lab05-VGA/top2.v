module top2(
    // Inputs da placa
  input CLOCK_50,
  input reset,

  // Botões
  input incr_R,
  input incr_G,
  input incr_B,

  // Sinais para o Conversor Digital-Analógico
  output wire VGA_CLK,
  output [7:0] VGA_R,
  output [7:0] VGA_G,
  output [7:0] VGA_B,
  output VGA_SYNC_N,
  output VGA_BLANK_N,

  // Direto para o conector VGA
  output VGA_HS,
  output VGA_VS,

  // Para visores HEX
  output [6:0] HEX0, // digito da direita
  output [6:0] HEX1,
  output [6:0] HEX2,
  output [6:0] HEX3,
  output [6:0] HEX4,
  output [6:0] HEX5 // digito da esquerda

);

  wire [10:0] x_coord;
  wire [10:0] y_coord;

  reg [7:0] R_value;
  reg [7:0] G_value;
  reg [7:0] B_value;

  reg [1:0] last_button;

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

    conversor_bin_hex7seg conv_R (
    .clk(VGA_CLK),
    .entrada(R_value),
    .digito0(HEX4),
    .digito1(HEX5)
  );

    conversor_bin_hex7seg conv_G (
    .clk(VGA_CLK),
    .entrada(G_value),
    .digito0(HEX2),
    .digito1(HEX3)
  );

    conversor_bin_hex7seg conv_B (
    .clk(VGA_CLK),
    .entrada(B_value),
    .digito0(HEX0),
    .digito1(HEX1)
  );

  assign top_R = R_value;
  assign top_G = G_value;
  assign top_B = B_value;

  always @(posedge VGA_CLK) begin 
    if (!reset) begin 
      R_value = 0;
      G_value = 0;
      B_value = 0;
      last_button = 2'b00;
    end

    else begin
      if (!incr_R|!incr_G|!incr_B) begin
        if (!incr_R)
          last_button = 2'b01;

        else if (!incr_G)
          last_button = 2'b10;

        else if (!incr_B)
          last_button = 2'b11;
      end

      else begin 
        if (last_button != 2'b00) begin 
          case(last_button) 
            2'b01:
              R_value = R_value + 8;
            2'b10:
              G_value = G_value + 8;
            2'b11:
              B_value = B_value + 8;
          endcase

        last_button = 2'b00;

        end
      end

  end

  end

endmodule