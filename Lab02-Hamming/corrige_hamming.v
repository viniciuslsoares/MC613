module corrige_hamming (
  input [14:0] entrada, // a paridade é o bit mais significativo (dado[8])
  output reg [10:0] saida
);
  reg p1;
  reg p2;
  reg d1;
  reg p4;
  reg d2;
  reg d3;
  reg d4;
  reg p8;
  reg d5;
  reg d6;
  reg d7;
  reg d8;
  reg d9;
  reg d10;
  reg d11;
  reg [3:0] calc_p;
  reg [14:0] entrada_temp;

  always @(*) begin
    p1 = entrada[0];
    p2 = entrada[1];
    d1 = entrada[2];
    p4 = entrada[3];
    d2 = entrada[4];
    d3 = entrada[5];
    d4 = entrada[6];
    p8 = entrada[7];
    d5 = entrada[8];
    d6 = entrada[9];
    d7 = entrada[10];
    d8 = entrada[11];
    d9 = entrada[12];
    d10 = entrada[13];
    d11 = entrada[14];

   calc_p[0] = d1 ^ d2 ^ d4 ^ d5 ^ d7 ^ d9 ^ d11; // p1 
   calc_p[1] = d1 ^ d3 ^ d4 ^ d6 ^ d7 ^ d10 ^ d11; // p2
   calc_p[2] = d2 ^ d3 ^ d4 ^ d8 ^ d9 ^ d10 ^ d11; // p4
   calc_p[3] = d5 ^ d6 ^ d7 ^ d8 ^ d9 ^ d10 ^ d11; // p8

    calc_p[0] = (calc_p[0] != p1); 
    calc_p[1] = (calc_p[1] != p2);
    calc_p[2] = (calc_p[2] != p4);
    calc_p[3] = (calc_p[3] != p8);

  entrada_temp = entrada;

    case (calc_p) 
      4'b0000: entrada_temp = entrada;
      4'b0001: entrada_temp[0] = ~entrada[0];
      4'b0010: entrada_temp[1] = ~entrada[1];
      4'b0011: entrada_temp[2] = ~entrada[2];
      4'b0100: entrada_temp[3] = ~entrada[3];
      4'b0101: entrada_temp[4] = ~entrada[4];
      4'b0110: entrada_temp[5] = ~entrada[5];
      4'b0111: entrada_temp[6] = ~entrada[6];
      4'b1000: entrada_temp[7] = ~entrada[7];
      4'b1001: entrada_temp[8] = ~entrada[8];
      4'b1010: entrada_temp[9] = ~entrada[9];
      4'b1011: entrada_temp[10] = ~entrada[10];
      4'b1100: entrada_temp[11] = ~entrada[11];
      4'b1101: entrada_temp[12] = ~entrada[12];
      4'b1110: entrada_temp[13] = ~entrada[13];
      4'b1111: entrada_temp[14] = ~entrada[14];
endcase

    saida = { entrada_temp[14:8], entrada_temp[6:4], entrada_temp[2]};
    
end

endmodule