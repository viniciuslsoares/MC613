module conversor_bin_dec(
    input clk,
    input [9:0] data_in,
    output reg [6:0] digito0, // digito da direita
    output reg [6:0] digito1,
    output reg [6:0] digito2
    );
    reg [12:0] bcd = 0;
    integer i,j;

    always @(negedge clk)
    begin
        // Converter binário para decimal
        for(i = 0; i <= 12; i = i+1)
            bcd[i] = 0;                                              // initialize with zeros
        bcd[9:0] = data_in;                                         // initialize with input vector
        for(i = 0; i <= 6; i = i+1)                                 // iterate on structure depth
            for(j = 0; j <= i/3; j = j+1)                            // iterate on structure width
                if (bcd[10-i + 4*j -: 4] > 4)                        // if > 4
                    bcd[10-i+4*j -: 4] = bcd[10-i+4*j -: 4] + 4'd3;  // add 3

        // Mostrar os dígitos no display
        case (bcd[3:0])
            4'b0000: digito0 = 7'b1000000; // 0
            4'b0001: digito0 = 7'b1111001; // 1
            4'b0010: digito0 = 7'b0100100; // 2
            4'b0011: digito0 = 7'b0110000; // 3
            4'b0100: digito0 = 7'b0011001; // 4
            4'b0101: digito0 = 7'b0010010; // 5
            4'b0110: digito0 = 7'b0000010; // 6
            4'b0111: digito0 = 7'b1111000; // 7
            4'b1000: digito0 = 7'b0000000; // 8
            4'b1001: digito0 = 7'b0010000; // 9
            default: digito0 = 7'b1111111; // data_in inválida
        endcase

        case (bcd[7:4])
            4'b0000:
            begin
                if (digito2 != 7'b1111111)
                    digito1 = 7'b1000000; // 0
                else
                    digito1 = 7'b1111111; // Apagado
            end
            4'b0001: digito1 = 7'b1111001; // 1
            4'b0010: digito1 = 7'b0100100; // 2
            4'b0011: digito1 = 7'b0110000; // 3
            4'b0100: digito1 = 7'b0011001; // 4
            4'b0101: digito1 = 7'b0010010; // 5
            4'b0110: digito1 = 7'b0000010; // 6
            4'b0111: digito1 = 7'b1111000; // 7
            4'b1000: digito1 = 7'b0000000; // 8
            4'b1001: digito1 = 7'b0010000; // 9
            default: digito1 = 7'b1111111; // data_in inválida
        endcase

        case (bcd[11:8])
            // 4'b0000: digito2 = 7'b1000000; // 0
            4'b0001: digito2 = 7'b1111001; // 1
            4'b0010: digito2 = 7'b0100100; // 2
            4'b0011: digito2 = 7'b0110000; // 3
            4'b0100: digito2 = 7'b0011001; // 4
            4'b0101: digito2 = 7'b0010010; // 5
            4'b0110: digito2 = 7'b0000010; // 6
            4'b0111: digito2 = 7'b1111000; // 7
            4'b1000: digito2 = 7'b0000000; // 8
            4'b1001: digito2 = 7'b0010000; // 9
            default: digito2 = 7'b1111111; // data_in inválida
        endcase

    end

endmodule