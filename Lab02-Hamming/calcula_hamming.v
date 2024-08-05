module calcula_hamming (
  input [10:0] entrada,
  output [14:0] saida
);

  assign saida[0] = entrada[0] ^ entrada[1] ^ entrada[3] ^ entrada[4] ^ entrada[6] ^ entrada[8] ^ entrada[10]; // p1 
  assign saida[1] = entrada[0] ^ entrada[2] ^ entrada[3] ^ entrada[5] ^ entrada[6] ^ entrada[9] ^ entrada[10]; // p2
  assign saida[2] = entrada[0];
  assign saida[3] = entrada[1] ^ entrada[2] ^ entrada[3] ^ entrada[7] ^ entrada[8] ^ entrada[9] ^ entrada[10]; // p4
  assign saida[6:4] = entrada[3:1];
  assign saida[7] = entrada[4] ^ entrada[5] ^ entrada[6] ^ entrada[7] ^ entrada[8] ^ entrada[9] ^ entrada[10]; // p8
  assign saida[14:8] = entrada[10:4];

endmodule
