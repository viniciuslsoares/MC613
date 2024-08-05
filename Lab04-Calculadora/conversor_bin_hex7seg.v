module conversor_bin_hex7seg(
    input clk,
    input [23:0] entrada,
    output reg [6:0] digito0, // digito da direita
    output reg [6:0] digito1,
    output reg [6:0] digito2,
    output reg [6:0] digito3,
    output reg [6:0] digito4,
    output reg [6:0] digito5  // digito da esquerda
);

    reg [4:0] digito0bin, digito1bin, digito2bin, digito3bin, digito4bin, digito5bin;

    always @(negedge clk) begin
        digito0bin = {entrada[3:0]};
        digito1bin = {entrada[7:4]};
        digito2bin = {entrada[11:8]};
        digito3bin = {entrada[15:12]};
        digito4bin = {entrada[19:16]};
        digito5bin = {entrada[23:20]};

        
        case(digito0bin)
            4'b0000: digito0 = 7'b1111110; // 0
            4'b0001: digito0 = 7'b0110000; // 1
            4'b0010: digito0 = 7'b1101101; // 2
            4'b0011: digito0 = 7'b1111001; // 3
            4'b0100: digito0 = 7'b0110011; // 4
            4'b0101: digito0 = 7'b1011011; // 5
            4'b0110: digito0 = 7'b1011111; // 6
            4'b0111: digito0 = 7'b1110000; // 7
            4'b1000: digito0 = 7'b1111111; // 8
            4'b1001: digito0 = 7'b1111011; // 9
            4'b1010: digito0 = 7'b1110111; // a
            4'b1011: digito0 = 7'b0011111; // b
            4'b1100: digito0 = 7'b1001110; // c
            4'b1101: digito0 = 7'b0111101; // d
            4'b1110: digito0 = 7'b1001111; // e
            4'b1111: digito0 = 7'b1000111; // f
            default: digito0 = 7'b0000000; // entrada inválida
        endcase
        
        case(digito1bin)
            4'b0000: digito1 = 7'b1111110; // 0
            4'b0001: digito1 = 7'b0110000; // 1
            4'b0010: digito1 = 7'b1101101; // 2
            4'b0011: digito1 = 7'b1111001; // 3
            4'b0100: digito1 = 7'b0110011; // 4
            4'b0101: digito1 = 7'b1011011; // 5
            4'b0110: digito1 = 7'b1011111; // 6
            4'b0111: digito1 = 7'b1110000; // 7
            4'b1000: digito1 = 7'b1111111; // 8
            4'b1001: digito1 = 7'b1111011; // 9
            4'b1010: digito1 = 7'b1110111; // a
            4'b1011: digito1 = 7'b0011111; // b
            4'b1100: digito1 = 7'b1001110; // c
            4'b1101: digito1 = 7'b0111101; // d
            4'b1110: digito1 = 7'b1001111; // e
            4'b1111: digito1 = 7'b1000111; // f
            default: digito1 = 7'b0000000; // entrada inválida
        endcase

        case(digito2bin)
            4'b0000: digito2 = 7'b1111110; // 0
            4'b0001: digito2 = 7'b0110000; // 1
            4'b0010: digito2 = 7'b1101101; // 2
            4'b0011: digito2 = 7'b1111001; // 3
            4'b0100: digito2 = 7'b0110011; // 4
            4'b0101: digito2 = 7'b1011011; // 5
            4'b0110: digito2 = 7'b1011111; // 6
            4'b0111: digito2 = 7'b1110000; // 7
            4'b1000: digito2 = 7'b1111111; // 8
            4'b1001: digito2 = 7'b1111011; // 9
            4'b1010: digito2 = 7'b1110111; // a
            4'b1011: digito2 = 7'b0011111; // b
            4'b1100: digito2 = 7'b1001110; // c
            4'b1101: digito2 = 7'b0111101; // d
            4'b1110: digito2 = 7'b1001111; // e
            4'b1111: digito2 = 7'b1000111; // f
            default: digito2 = 7'b0000000; // entrada inválida
        endcase

        case(digito3bin)
            4'b0000: digito3 = 7'b1111110; // 0
            4'b0001: digito3 = 7'b0110000; // 1
            4'b0010: digito3 = 7'b1101101; // 2
            4'b0011: digito3 = 7'b1111001; // 3
            4'b0100: digito3 = 7'b0110011; // 4
            4'b0101: digito3 = 7'b1011011; // 5
            4'b0110: digito3 = 7'b1011111; // 6
            4'b0111: digito3 = 7'b1110000; // 7
            4'b1000: digito3 = 7'b1111111; // 8
            4'b1001: digito3 = 7'b1111011; // 9
            4'b1010: digito3 = 7'b1110111; // a
            4'b1011: digito3 = 7'b0011111; // b
            4'b1100: digito3 = 7'b1001110; // c
            4'b1101: digito3 = 7'b0111101; // d
            4'b1110: digito3 = 7'b1001111; // e
            4'b1111: digito3 = 7'b1000111; // f
            default: digito3 = 7'b0000000; // entrada inválida
        endcase

        case(digito4bin)
            4'b0000: digito4 = 7'b1111110; // 0
            4'b0001: digito4 = 7'b0110000; // 1
            4'b0010: digito4 = 7'b1101101; // 2
            4'b0011: digito4 = 7'b1111001; // 3
            4'b0100: digito4 = 7'b0110011; // 4
            4'b0101: digito4 = 7'b1011011; // 5
            4'b0110: digito4 = 7'b1011111; // 6
            4'b0111: digito4 = 7'b1110000; // 7
            4'b1000: digito4 = 7'b1111111; // 8
            4'b1001: digito4 = 7'b1111011; // 9
            4'b1010: digito4 = 7'b1110111; // a
            4'b1011: digito4 = 7'b0011111; // b
            4'b1100: digito4 = 7'b1001110; // c
            4'b1101: digito4 = 7'b0111101; // d
            4'b1110: digito4 = 7'b1001111; // e
            4'b1111: digito4 = 7'b1000111; // f
            default: digito4 = 7'b0000000; // entrada inválida
        endcase

        case(digito5bin)
            4'b0000: digito5 = 7'b1111110; // 0
            4'b0001: digito5 = 7'b0110000; // 1
            4'b0010: digito5 = 7'b1101101; // 2
            4'b0011: digito5 = 7'b1111001; // 3
            4'b0100: digito5 = 7'b0110011; // 4
            4'b0101: digito5 = 7'b1011011; // 5
            4'b0110: digito5 = 7'b1011111; // 6
            4'b0111: digito5 = 7'b1110000; // 7
            4'b1000: digito5 = 7'b1111111; // 8
            4'b1001: digito5 = 7'b1111011; // 9
            4'b1010: digito5 = 7'b1110111; // a
            4'b1011: digito5 = 7'b0011111; // b
            4'b1100: digito5 = 7'b1001110; // c
            4'b1101: digito5 = 7'b0111101; // d
            4'b1110: digito5 = 7'b1001111; // e
            4'b1111: digito5 = 7'b1000111; // f
            default: digito5 = 7'b0000000; // entrada inválida
        endcase
    
    end

endmodule
