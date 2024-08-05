module top1(
  // Inputs da placa
  input CLOCK_50,
  input reset,

  // Sinais para o Conversor Digital-Analógico
  output wire VGA_CLK,
  output [7:0] VGA_R,
  output [7:0] VGA_G,
  output [7:0] VGA_B,
  output VGA_SYNC_N,
  output VGA_BLANK_N,

  // Direto para o conector VGA
  output VGA_HS,
  output VGA_VS

  // Para top-module
);

  wire [10:0] x_coord;
  wire [10:0] y_coord;

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
  
  assign top_R = ((x_coord >= 0) && (x_coord < 213)) ? 200 : 0;
  assign top_G = ((x_coord >= 213) && (x_coord < 426)) ? 200 : 0;
  assign top_B = ((x_coord >= 426) && (x_coord < 639)) ? 200 : 0;
  

endmodule