module tb_hamming();

reg [10:0] entrada;
wire [14:0] h15;
reg [3:0] n;
reg injeta_erro;
wire [14:0] alterado;
wire [10:0] saida;
reg [15:0] dados_arquivo [0:4];

calcula_hamming cah(
  .entrada(entrada),
  .saida(h15)
);

injetor inj(
  .entrada(h15),
  .n(n),
  .erro(injeta_erro),
  .saida(alterado)
);

corrige_hamming coh(
  .entrada(alterado),
  .saida(saida)
);

integer i;

initial begin
  $readmemb("teste.txt", dados_arquivo); // le o arquivo de entrada e guarda em dados_arquivo

  $dumpfile("hamming.vcd"); // gera um arquivo .vcd para visualização no gtkwave
  $dumpvars(0, tb_hamming); // salva as variáveis do módulo tb_hamming

  // $monitor("entrada=%b, h15=%b, n=%b, injeta_erro=%b, alterado=%b, saida=%b", entrada, h15, n, injeta_erro, alterado, saida);
  // $monitor("entrada=%b, saida=%b", entrada, saida);

  

  for (i = 0; i < 5; i = i + 1) begin
    entrada = dados_arquivo[i][15:5];
    n = dados_arquivo[i][4:1];
    injeta_erro = dados_arquivo[i][0];
    #1;
    $display("entrada=%b, saida=%b", entrada, saida);
  end

end

endmodule
