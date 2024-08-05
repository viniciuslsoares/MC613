module tb_paridade();

reg [7:0] entrada;
wire p;
reg [3:0] n;
reg injeta_erro;
wire [8:0] saida;
wire erro;
reg [12:0] dados_arquivo [0:4];

calcula_paridade cp(
  .dado(entrada),
  .paridade(p)
);

injetor inj(
  .entrada({p, entrada}),
  .n(n),
  .erro(injeta_erro),
  .saida(saida)
);

verifica_paridade vp(
  .dado(saida),
  .erro(erro)
);

integer i;

initial begin
  $readmemb("teste.txt", dados_arquivo); // le o arquivo de entrada e guarda em dados_arquivo

  $dumpfile("paridade.vcd"); // gera um arquivo .vcd para visualização no gtkwave
  $dumpvars(0, tb_paridade); // salva as variáveis do módulo tb_paridade

  $monitor("entrada = %b, p = %b, n = %b, injeta_erro = %b, saida = %b, erro = %b", entrada, p, n, injeta_erro, saida, erro);

  for (i = 0; i < 5; i = i + 1) begin
    entrada = dados_arquivo[i][12:5];
    n = dados_arquivo[i][4:1];
    injeta_erro = dados_arquivo[i][0];
    #1;
  end

end

endmodule
