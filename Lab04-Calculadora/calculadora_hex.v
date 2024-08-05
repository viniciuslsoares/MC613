module calculadora_hex(
  input clk,
  input [9:0] entrada,
  input mostrar,
  input somar,
  input subtrair,
  input zerar,
  output [6:0] digito0, // digito da direita
  output [6:0] digito1,
  output [6:0] digito2,
  output [6:0] digito3,
  output [6:0] digito4,
  output [6:0] digito5 // digito da esquerda
);

  reg [23:0] total;
  reg [23:0] valor_display;
  reg [2:0] ultimo_bot_press;

  conversor_bin_hex7seg conv (
    .clk(clk),
    .entrada(valor_display),
    .digito0(digito0),
    .digito1(digito1),
    .digito2(digito2),
    .digito3(digito3),
    .digito4(digito4),
    .digito5(digito5)
  );

  always @(posedge clk) begin 
    if (mostrar) begin
      valor_display = entrada;
    end

    else begin 
      if (somar|subtrair|zerar) begin 
        if (somar)
          ultimo_bot_press = 3'b01;

        else if (subtrair)
          ultimo_bot_press = 3'b10;

        else if (zerar)
          ultimo_bot_press = 3'b11;
      end

      else begin
        if (ultimo_bot_press != 3'b00) begin
          case(ultimo_bot_press) 
            3'b01:
              total = total + entrada;

            3'b10:
              total = total - entrada;

            3'b11:
              total = 24'b0;
          endcase

        ultimo_bot_press = 3'b00;
        end

        valor_display = total;
        
      end
    end
  end


endmodule