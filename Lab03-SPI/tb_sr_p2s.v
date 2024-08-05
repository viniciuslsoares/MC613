module tb_sr_p2s;
    reg reset, clk;
    reg [7:0] data_in;
    reg load;
    wire data_out, ready;

    sr_p2s p2s_test(
        .reset(reset),
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .data_out(data_out),
        .ready(ready)
    );

    reg [7:0] saida;
    
    initial begin
        
        reset = 0;
        clk = 0;
        data_in = 8'b10000001;
        load = 1;
        
        // Loading to data_out_reg

        $display("reset = %b, clk = %b, data_in = %b, load = %b, data_out = %b, ready = %b, saida = %b", reset, clk, data_in, load, data_out, ready, saida);
        clk = 1;
        #1;
        saida[0] = data_out;
        saida = (saida << 1);
        $display("reset = %b, clk = %b, data_in = %b, load = %b, data_out = %b, ready = %b, saida = %b", reset, clk, data_in, load, data_out, ready, saida);

        // Testing and gathering data_out
        load = 0;
        while (!ready) begin
            clk = !clk;
            #1;
            if (clk) begin
                saida[0] = data_out;
                if (!ready)
                    saida = (saida << 1);
            end
            $display("reset = %b, clk = %b, data_in = %b, load = %b, data_out = %b, ready = %b, saida = %b", reset, clk, data_in, load, data_out, ready, saida);
        end
    end

endmodule
