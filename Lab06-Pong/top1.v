  module top1(
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
    input left_but

  );
    reg [10:0] x_bar_pos;
    reg [10:0] y_bar_pos;

    parameter [10:0] STEP = 2;
    parameter [10:0] Y_SIZE = 16;
    parameter [10:0] X_SIZE = 154;
    parameter [10:0] H_BARRA = 10;
    parameter [10:0] W_RES = 640;
    parameter [10:0] H_RES = 480; 
    parameter [25:0] DIVISOR = 200000;

    wire [10:0] x_coord;
    wire [10:0] y_coord;

    reg [2:0] last_button;

    wire [7:0] top_R;
    wire [7:0] top_G;
    wire [7:0] top_B;

    reg [25:0] cont_left = 0;
    reg [25:0] cont_right = 0;

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

    // Barra
    assign top_R = ((x_coord > x_bar_pos) && (x_coord <= (x_bar_pos+X_SIZE)) && (y_coord > y_bar_pos) && (y_coord <= (y_bar_pos+Y_SIZE))) ? 8'd255 : 8'd0;
    assign top_G = ((x_coord > x_bar_pos) && (x_coord <= (x_bar_pos+X_SIZE)) && (y_coord > y_bar_pos) && (y_coord <= (y_bar_pos+Y_SIZE))) ? 8'd0 : 8'd0;
    assign top_B = ((x_coord > x_bar_pos) && (x_coord <= (x_bar_pos+X_SIZE)) && (y_coord > y_bar_pos) && (y_coord <= (y_bar_pos+Y_SIZE))) ? 8'd0 : 8'd0;

    always @(posedge VGA_CLK) begin

      if (reset == 0) begin
        x_bar_pos = ((W_RES/2) - (X_SIZE/2));       // Centraliza a barra
        y_bar_pos = (H_RES - H_BARRA - Y_SIZE);          // Afasta a barra 30 pixels do final da tela
        last_button = 3'b111;
        end

      else begin
        cont_right = cont_right + 1;
        if (cont_right == DIVISOR) begin
            cont_right = 0;
            if (!left_but | !right_but) begin
              if (!left_but) begin
                last_button = 3'b000;
                end
              else if (!right_but) begin
                last_button = 3'b001;
                end
              end

            if (last_button != 3'b111) begin
              case (last_button)

                3'b000: begin // LEFT
                  if (x_bar_pos < STEP) x_bar_pos = 0;
                  else x_bar_pos = x_bar_pos - STEP;
                  end

                3'b001: begin // Right
                  if (x_bar_pos + STEP + X_SIZE > W_RES) x_bar_pos = W_RES - X_SIZE;
                  else x_bar_pos = x_bar_pos + STEP;
                  end
                endcase 

              last_button = 3'b111;
              end            
          end
        end
      end
      
    endmodule