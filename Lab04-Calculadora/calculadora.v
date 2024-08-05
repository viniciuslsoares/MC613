module calculadora(
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

  reg [19:0] total;
  reg [19:0] valor_display;
  reg ja_somou, ja_subtraiu, ja_zerou;

  conversor_bin_dec conv (
    .clk(clk),
    .data_in(valor_display),
    .digito0(digito0),
    .digito1(digito1),
    .digito2(digito2),
    .digito3(digito3),
    .digito4(digito4),
    .digito5(digito5)
  );

  initial begin
    total = 0;
    ja_somou = 0;
    ja_subtraiu = 0;
    ja_zerou = 0;
  end
  always @(posedge clk) begin
  
    if (~somar & ~ja_somou) begin
      total = total + entrada;
      ja_somou = 1;
    end else if (~subtrair & ~ja_subtraiu) begin
      total = total - entrada;
      ja_subtraiu = 1;
    end else if (~zerar & ~ja_zerou) begin
      total = 0;
      ja_zerou = 1;
    end

    if (somar & ja_somou)
      ja_somou = 0;
    if (subtrair & ja_subtraiu)
      ja_subtraiu = 0;
    if (zerar & ja_zerou)
      ja_zerou = 0;
    
    if (~mostrar)
      valor_display = entrada;
    else
      valor_display = total;
	end

endmodule