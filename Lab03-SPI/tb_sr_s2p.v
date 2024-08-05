module tb_sr_s2p;
    reg reset, data_in, enable, clk;
    wire [7:0] data_out;
    wire ready;

    sr_s2p s2p_test(
        .reset(reset),
        .data_in(data_in),
        .enable(enable),
        .clk(clk),
        .data_out(data_out),
        .ready(ready)
    );

    reg [7:0] entrada;

    initial begin
        entrada = 8'b10010001;
        clk = 0;

        $display("reset = %b, clk = %b, data_in = %b, enable = %b, data_out = %b, ready = %b", reset, clk, data_in, enable, data_out, ready);
        // Reset
        reset = 1;
        enable = 0;
        clk = !clk;
        #1;
        $display("reset = %b, clk = %b, data_in = %b, enable = %b, data_out = %b, ready = %b", reset, clk, data_in, enable, data_out, ready);
        clk = !clk;
        $display("reset = %b, clk = %b, data_in = %b, enable = %b, data_out = %b, ready = %b", reset, clk, data_in, enable, data_out, ready);

        // Moving "entrada" bits to "data_in"
        reset = 0;
        data_in = entrada[7];
        entrada = {entrada[6:0], 1'b0};
        enable = 1;
        clk = !clk;
        #1;
        $display("reset = %b, clk = %b, data_in = %b, enable = %b, data_out = %b, ready = %b", reset, clk, data_in, enable, data_out, ready);
        while (!ready) begin
            clk = !clk;
            if (clk) begin
                data_in = entrada[7];
                entrada = {entrada[6:0], 1'b0};
            end
            #1;
            $display("reset = %b, clk = %b, data_in = %b, enable = %b, data_out = %b, ready = %b", reset, clk, data_in, enable, data_out, ready);
        end
    end

endmodule