module calcula_paridade (
  input [7:0] dado,
  output paridade
);

  assign paridade = ^dado;

endmodule
