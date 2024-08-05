module tb_calculadora();

// Sinais gerais
reg clk, reset;
reg [9:0] entrada;
reg mostrar, somar, subtrair, zerar;
wire [6:0] digito0, digito1, digito2, digito3, digito4, digito5;

calculadora c(
  .clk(clk),
  .entrada(entrada),
  .mostrar(mostrar),
  .somar(somar),
  .subtrair(subtrair),
  .zerar(zerar),
  .digito0(digito0),
  .digito1(digito1),
  .digito2(digito2),
  .digito3(digito3),
  .digito4(digito4),
  .digito5(digito5)
);

always #1 clk = (clk===1'b0);

initial begin
  $dumpfile("tb_calculadora.vcd");
  $dumpvars(0, tb_calculadora);

  reset = 1; mostrar = 0; somar = 0; subtrair = 0; zerar = 0; entrada = 0;
  #10;
  reset = 0;
  #1;
  zerar = 1;
  #2;
  zerar = 0; entrada = 10; mostrar = 1;
  #2;
  mostrar = 0;
  #2;
  somar = 1;
  #4;
  somar = 0;
  #2;
  entrada = 5; mostrar = 1;
  #2;
  mostrar = 0;
  #2;
  subtrair = 1;
  #4;
  subtrair = 0;
  #2;
  zerar = 1;
  #2;
  $finish;
end

always @(negedge clk)
begin
  if (!reset) begin
    if ({mostrar, somar, subtrair, zerar} !== 0) begin
      $display("mostrar=%b, somar=%b, subtrair=%b, zerar=%b, entrada=%d", mostrar, somar, subtrair, zerar, entrada);
      $display("==> digito5=%b, digito4=%b, digito3=%b, digito2=%b, digito1=%b, digito0=%b", digito5, digito4, digito3, digito2, digito1, digito0);
    end
  end
end

endmodule