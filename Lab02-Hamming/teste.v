module corretor_hamming (
  input [14:0] entrada,
  output reg [10:0] saida_corrigida,
  output reg erro_detectado
);

  reg [10:0] entrada_corrigida;
  reg [3:0] erro;

  // Cálculo dos bits de paridade
  assign erro[0] = entrada[3] ^ entrada[5] ^ entrada[7] ^ entrada[9] ^ entrada[11] ^ entrada[13] ^ entrada[14]; // p1 
  assign erro[1] = entrada[3] ^ entrada[6] ^ entrada[7] ^ entrada[10] ^ entrada[11] ^ entrada[14]; // p2
  assign erro[2] = entrada[5] ^ entrada[6] ^ entrada[7] ^ entrada[12] ^ entrada[13] ^ entrada[14]; // p4
  assign erro[3] = entrada[9] ^ entrada[10] ^ entrada[11] ^ entrada[12] ^ entrada[13] ^ entrada[14]; // p8

  // Verifica se há erro
  always @* begin
    erro_detectado = (erro[0] ^ erro[1] ^ erro[2] ^ erro[3]) ? 1 : 0;
  end

  // Corrige o erro
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      // Resetando o circuito
      entrada_corrigida <= 11'b00000000000;
    end else if (erro_detectado) begin
      // Correção do erro
      entrada_corrigida[0] = entrada[3] ^ erro[0];
      entrada_corrigida[1] = entrada[5] ^ erro[1];
      entrada_corrigida[2] = entrada[6];
      entrada_corrigida[3] = entrada[7] ^ erro[0];
      entrada_corrigida[4] = entrada[9] ^ erro[2];
      entrada_corrigida[5] = entrada[10] ^ erro[1];
      entrada_corrigida[6] = entrada[11] ^ erro[3];
      entrada_corrigida[7] = entrada[12];
      entrada_corrigida[8] = entrada[13];
      entrada_corrigida[9] = entrada[14];
      entrada_corrigida[10] = 0; // O bit de paridade p16 é removido
    end else begin
      // Sem erro, cópia direta
      entrada_corrigida <= entrada[14:4];
    end
  end

  // Saída corrigida
  always @* begin
    saida_corrigida = entrada_corrigida;
  end

endmodule