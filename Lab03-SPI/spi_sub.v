module spi_sub (
    input reset,
    input [7:0] data_in,
    input load,
    output reg [7:0] data_out,
    output reg ready,
    output reg done,
    input mosi,
    output reg miso,
    input sclk,
    input cs
);

reg [7:0] shift_register;
reg [2:0] size_in;      // leitura
reg [3:0] size_out;     // envio  
reg enable;

initial begin
        size_in = 0;
        size_out = 0;
        shift_register = 0;  // zera o registrador
        data_out = 0;
        ready = 0;
        done = 0;
        miso = 0;
end

always @(negedge sclk) begin

    if (reset) begin
        // cs = 1;     // deixa o sub desativado
        size_in = 0;
        size_out = 0;
        shift_register = 0;  // zera o registrador
        data_out = 0;
        ready = 0;
        done = 0;
        miso = 0;
    end else if (load & ~cs) begin // sub está ativado
        size_out = 8;
        shift_register = data_in;
        miso = 1;               // sinal de envio de dados
    end else if (ready) begin
        enable = 0;
        // data_out = shift_register;
        ready = 0;
    end else if (enable) begin
        size_in = size_in + 1;
        shift_register = {shift_register[6:0], mosi};
        ready = (size_in == 0);
        if (ready) begin
            data_out = shift_register;
        end
    end else if (size_out != 0) begin
        miso = shift_register[7];
        shift_register = {shift_register[6:0], 1'b0};
        size_out = size_out - 1;
    end else if (mosi & ~cs) begin
        enable = 1;             // começa a receber os dados
    end else begin
        miso = 0;
    end
        done = (size_out == 0);
end

endmodule
