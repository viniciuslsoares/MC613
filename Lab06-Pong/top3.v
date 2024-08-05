module top3(
  input CLOCK_50,
  input reset,

  // Botões para controle
  input right_but,
  input left_but,
  input start_button,

  // Display
  output [6:0] HEX0, // digito da direita
  output [6:0] HEX1,
  output [6:0] HEX2,
  output [6:0] HEX3,
  output [6:0] HEX4,
  output [6:0] HEX5, // digito da esquerda

  // Conexões módulo VGA
  output wire VGA_CLK,
  output [7:0] VGA_R,
  output [7:0] VGA_G,
  output [7:0] VGA_B,
  output VGA_BLANK_N,
  output VGA_SYNC_N,

  output VGA_HS,
  output VGA_VS
);
  // Dados da bolinha - posição e size
  reg [10:0] x_ball_pos;
  reg [10:0] y_ball_pos;
  parameter [6:0] SIZE = 16;
  parameter [20:0] INC = 10000;

  // Posição do pixel atual
  wire [10:0] x_coord;
  wire [10:0] y_coord;

  // Game status
  reg [1:0] game_status;

  // Cor da bolinha
  wire [7:0] top_ball_R;
  wire [7:0] top_ball_G;
  wire [7:0] top_ball_B;

  // Cor da barra
  wire [7:0] top_bar_R;
  wire [7:0] top_bar_G;
  wire [7:0] top_bar_B;

  // Cor final
  wire [7:0] top_R;
  wire [7:0] top_G;
  wire [7:0] top_B;

  // Temporizadores da bolinha
  reg [25:0] h_timer;
  reg [25:0] v_timer;
  reg [25:0] speed_h = 130000;
  reg [25:0] speed_v = 130000;

  // Indicador de direção horizontal: 0 = esquerda, 1 = direita
  reg h_dir;
  // Indicador de direção vertical: 0 = cima, 1 = baixo
  reg v_dir;

  // TOP1
  // Dados da barra
  reg [10:0] x_bar_pos;
  reg [10:0] y_bar_pos;

  // Parâmetros da barra
  parameter [10:0] STEP = 2;
  parameter [10:0] Y_SIZE = 16;
  parameter [10:0] X_SIZE = 154;
  parameter [10:0] H_BARRA = 10;
  parameter [10:0] W_RES = 640;
  parameter [10:0] H_RES = 480; 
  parameter [25:0] DIVISOR = 300000;

  // Botão pressionado para mover a barra
  reg [2:0] last_button;

  reg [25:0] cont_right = 0;

// Placar
  reg [9:0] placar_atual = 0;
  reg [9:0] placar_maximo = 0;

  // Barra
  assign top_bar_R = ((x_coord > x_bar_pos) && (x_coord <= (x_bar_pos+X_SIZE)) && (y_coord > y_bar_pos) && (y_coord <= (y_bar_pos+Y_SIZE))) ? 8'd255 : 8'd0;
  assign top_bar_G = ((x_coord > x_bar_pos) && (x_coord <= (x_bar_pos+X_SIZE)) && (y_coord > y_bar_pos) && (y_coord <= (y_bar_pos+Y_SIZE))) ? 8'd0 : 8'd0;
  assign top_bar_B = ((x_coord > x_bar_pos) && (x_coord <= (x_bar_pos+X_SIZE)) && (y_coord > y_bar_pos) && (y_coord <= (y_bar_pos+Y_SIZE))) ? 8'd0 : 8'd0;

  // Bolinha
  assign top_ball_R = ((x_coord > x_ball_pos) && (x_coord <= (x_ball_pos+SIZE)) && (y_coord > y_ball_pos) && (y_coord <= (y_ball_pos+SIZE))) ? 0 : 30;
  assign top_ball_G = ((x_coord > x_ball_pos) && (x_coord <= (x_ball_pos+SIZE)) && (y_coord > y_ball_pos) && (y_coord <= (y_ball_pos+SIZE))) ? 255 : 30;
  assign top_ball_B = ((x_coord > x_ball_pos) && (x_coord <= (x_ball_pos+SIZE)) && (y_coord > y_ball_pos) && (y_coord <= (y_ball_pos+SIZE))) ? 0 : 30;
  
  // Cor final
  assign top_R = (top_ball_R ^ top_bar_R);
  assign top_G = (top_ball_G ^ top_bar_G);
  assign top_B = (top_ball_B ^ top_bar_B);

  // Placar
  conversor_bin_dec print_placar_atual (
    .clk(VGA_CLK),
    .data_in(placar_atual),
    .digito0(HEX0),
    .digito1(HEX1),
    .digito2(HEX2)
  );

  conversor_bin_dec print_placar_maximo (
    .clk(VGA_CLK),
    .data_in(placar_maximo),
    .digito0(HEX3),
    .digito1(HEX4),
    .digito2(HEX5)
  );

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

  always @(posedge VGA_CLK) begin
    if (reset == 0)
    begin
      // Centraliza a barra
      x_bar_pos = ((W_RES/2) - (X_SIZE/2));
      y_bar_pos = (H_RES - H_BARRA - Y_SIZE);          // Afasta a barra 30 pixels do final da tela]

      // Zerar auxiliares da bolinha
      h_timer = 0;
      v_timer = 0;
      h_dir = 1;
      v_dir = 1;
      speed_h = 130000;
      speed_v = 130000;

      // Centralizar a bolinha
      x_ball_pos = (320 - (SIZE/2));
      y_ball_pos = (240 - (SIZE/2));
      last_button = 3'b111;

      // Zerar o placar
      placar_atual = 0;
      placar_maximo = 0;

      // Game status - stand by
      game_status = 0;
    end

  else
  begin
    case (game_status)

    2'b00: begin
      // Status stand by
      if (!start_button)
        begin
          game_status = 1;
          placar_atual = 0;
        end
    end
    
    2'b01:
    begin
      // Mover a barra (TOP1)
      cont_right = cont_right + 1;
      if (cont_right == DIVISOR)
      begin
        cont_right = 0;
        if (!left_but | !right_but)
        begin
          if (!left_but)
            last_button = 3'b000;
          else if (!right_but)
            last_button = 3'b001;
        end

        if (last_button != 3'b111)
        begin
          case (last_button)

            3'b000: // LEFT
            begin
              if (x_bar_pos < STEP) x_bar_pos = 0;
              else x_bar_pos = x_bar_pos - STEP;
            end

            3'b001: // Right
            begin
              if (x_bar_pos + STEP + X_SIZE > W_RES) x_bar_pos = W_RES - X_SIZE;
              else x_bar_pos = x_bar_pos + STEP;
            end
          endcase 
          last_button = 3'b111;
        end            
      end
    
      // FINISH TOP1

      // Movimento horizontal
      if (h_timer == speed_h)
        begin

          // Direção horizontal da bolinha
          if (h_dir == 1) 
            x_ball_pos = x_ball_pos + 1;
          else
            x_ball_pos = x_ball_pos - 1;
          
          // Bolinha batendo na parede
          if (x_ball_pos+SIZE >= 639 || x_ball_pos == 0)
            h_dir = ~h_dir;

          // Zerar h_timer
          h_timer = 0;
        end

      // Movimento vertical
      if (v_timer == speed_v)
        begin 
          // Direção vertical da bolinha
          if (v_dir == 1) 
            y_ball_pos = y_ball_pos + 1;
          else
            y_ball_pos = y_ball_pos - 1;
          
          // Bolinha bate no teto
          if (y_ball_pos == 0)
            v_dir = ~v_dir;
          
          // Bolinha bate no chão - GAME OVER
          else if (y_ball_pos+SIZE >= 479)
            game_status = 2;
          
          // Zerar v_timer
          v_timer = 0;
        end

        // Se a bolinha se moveu verticalmente, vamos verificar se ela bateu na barra
        if (v_timer == 0)
        begin
          // Verificar se a bolinha bate na barra
          if (y_ball_pos+SIZE == y_bar_pos)
          begin

            // Caso 1: Bolinha bate no meio barra - simplesmente rebatemos
            if (x_ball_pos+(SIZE/2) >= (x_bar_pos + X_SIZE/3) && x_ball_pos+(SIZE/2) <= (x_bar_pos+(2*X_SIZE/3)))
            begin
              // Inverter a direção vertical
              v_dir = ~v_dir;
              // Atualizar o placar
              placar_atual = placar_atual + 1;
              if (placar_atual > placar_maximo)
                placar_maximo = placar_atual;
            end

            // Caso 2: A bolinha bate mais à esquerda da barra
            else if (x_ball_pos+SIZE >= x_bar_pos && x_ball_pos+(SIZE/2) <= (x_bar_pos + X_SIZE/3))
            begin
              // Bolinha vindo da esquerda para a direita
              if (h_dir == 1)
              begin
                // Diminuir a velocidade horizontal
                if (speed_h + INC >= 300000)
                  speed_h = 300000;
                else
                  speed_h = speed_h + INC;
                // Aumentar a velocidade vertical
                if (speed_v - INC <= 50000)
                  speed_v = 50000;
                else
                  speed_v = speed_v - INC;
              end

              // Bolinha vindo da direita para a esquerda
              else
              begin
                // Aumentar a velocidade horizontal
                if (speed_h - INC <= 50000)
                  speed_h = 50000;
                else
                  speed_h = speed_h - INC;
                // Diminuir a velocidade vertical
                if (speed_v + INC >= 300000)
                  speed_v = 300000;
                else
                  speed_v = speed_v + INC;
              end

              // Inverter a direção vertical
              v_dir = ~v_dir;

              // Atualizar o placar
              placar_atual = placar_atual + 1;
              if (placar_atual > placar_maximo)
                placar_maximo = placar_atual;
            end

            // Caso 3: A bolinha bate mais à direita da barra
            else if (x_ball_pos+(SIZE/2) >= (x_bar_pos+(2*X_SIZE/3)) && x_ball_pos <= (x_bar_pos + X_SIZE))
            begin
              // Bolinha vindo da direita para a esquerda
              if (h_dir == 0)
              begin
                // Diminuir a velocidade horizontal
                if (speed_h + INC >= 300000)
                  speed_h = 300000;
                else
                  speed_h = speed_h + INC;
                // Aumentar a velocidade vertical
                if (speed_v - INC <= 50000)
                  speed_v = 50000;
                else
                  speed_v = speed_v - INC;
              end

              // Bolinha vindo da esquerda para a direita
              else
              begin
                // Aumentar a velocidade horizontal
                if (speed_h - INC <= 50000)
                  speed_h = 50000;
                else
                  speed_h = speed_h - INC;
                // Diminuir a velocidade vertical
                if (speed_v + INC >= 300000)
                  speed_v = 300000;
                else
                  speed_v = speed_v + INC;
              end

              // Inverter a direção vertical
              v_dir = ~v_dir;

              // Atualizar o placar
              placar_atual = placar_atual + 1;
              if (placar_atual > placar_maximo)
                placar_maximo = placar_atual;
            end
          end
        end
        // Incrementar os contadores de tempo
        h_timer = h_timer + 1;
        v_timer = v_timer + 1;
      end

      2'b10:
      begin
          // GAME OVER
          // Reset nos timers e na direção da bolinha
          h_timer = 0;
          v_timer = 0;
          speed_v = 130000;
          speed_h = 130000;
          h_dir = 1;
          v_dir = 1;
          // Reset na posição da bolinha
          x_ball_pos = (320 - (SIZE/2));
          y_ball_pos = (240 - (SIZE/2));

          // Reset na posição da barra
          x_bar_pos = ((W_RES/2) - (X_SIZE/2));
          y_bar_pos = (H_RES - H_BARRA - Y_SIZE);

          // Colocar o jogo em stand by esperando pelo início
          game_status = 0;
        end
      endcase
    end
  end

endmodule