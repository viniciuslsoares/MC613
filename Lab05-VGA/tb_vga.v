module tb_vga();
    // Feito para avaliação da temporização no gtkwave.
    reg clock_50;
    reg reset;
    wire [7:0] vga_r;
    wire [7:0] vga_b;
    wire [7:0] vga_g;
    wire vga_blank_n;
    wire vga_sync_n;
    wire vga_hs;
    wire vga_vs;
    wire [7:0] top_r;
    wire [7:0] top_g;
    wire [7:0] top_b;
    wire [9:0] x;
    wire [9:0] y;

    top1 v(
        clock_50,
        reset,
        vga_clk,
        vga_r,
        vga_g,
        vga_b,
        vga_sync_n,
        vga_blank_n,
        vga_hs,
        vga_vs
        // top_r,
        // top_g,
        // top_b,
        // x,
        // y
    );
    
    // clk
    always #1 clock_50 = (clock_50===1'b0);

    initial begin
        $dumpfile("tb_vga.vcd");
        $dumpvars(0, tb_vga);
        reset=0;
        #10;
        reset=1;
        #100000;
        $finish;
    end
endmodule