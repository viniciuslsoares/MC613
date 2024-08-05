module injetor(
  input [14:0] entrada,
  input [3:0] n,
  input erro,
  output reg [14:0] saida
);

// Rodolfo: Deslocamento variável pode não ser sintetizável por algumas ferramentas. Se precisar, faça um case
  always @(*) begin
    
    if (erro)
      saida = entrada ^ (1 << n);

    else
      saida = entrada;

  end

endmodule
