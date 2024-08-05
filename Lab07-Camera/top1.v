module top1(

	// SINAIS BASICOS
	input CLOCK_50,
	input reset,
	
	// SINAIS DA CAMERA
	// Entradas
	input cam_pclk, 				//GPIO_1[21] // PCLK
	input cam_href, 				//GPIO_1[22] // HREF
	input cam_vs,   				//GPIO_1[23] // VSYNC
	input [7:0] cam_byte, 		//GPIO_1[19:12] // Byte da camera
	// Saidas
	output cam_xclk, 				//GPIO_1[20] // XCLK 
	output cam_reset, 			//GPIO_1[11] // RESET
	output cam_pwnn, 				//GPIO_1[10]
	
	// SINAIS DA VGA
  output wire VGA_CLK,
  output [7:0] VGA_R,
  output [7:0] VGA_G,
  output [7:0] VGA_B,
  output VGA_BLANK_N,
  output VGA_SYNC_N,

  output VGA_HS,
  output VGA_VS
);

	wire CLOCK_24;
	pll_ip pll_ip_inst (
		.refclk(CLOCK_50),   //  refclk.clk
		.rst(~reset),      //   reset.reset
		.outclk_0(CLOCK_24), // outclk0.clk
		.locked()    //  locked.export
	);
	
	
	assign cam_xclk = CLOCK_24;
	assign cam_reset = reset;
	assign cam_pwnn = ~reset;
	wire [10:0] x_coord;
	wire [10:0] y_coord;
	reg [10:0] cam_x;
	reg [10:0] cam_y;
	reg counter;
	wire [7:0] data_out;
	reg enable;
	
	vga vga_inst(
		.CLOCK_50(CLOCK_50),
		.reset(reset),
		.top_R(data_out),
		.top_G(data_out),
		.top_B(data_out),
		.VGA_CLK(VGA_CLK),
		.VGA_R(VGA_R),
		.VGA_G(VGA_G),
		.VGA_B(VGA_B),
		.VGA_BLANK_N(VGA_BLANK_N),
		.VGA_SYNC_N(VGA_SYNC_N),
		.VGA_HS(VGA_HS),
		.VGA_VS(VGA_VS),
		.x_coord(x_coord),
		.y_coord(y_coord)
	);

	buffer buffer_inst(
		.CLOCK_50(CLOCK_50),
		.write_enable(enable),
		.data_in(cam_byte),
		.data_in_x(cam_x),
		.data_in_y(cam_y),
		.data_out(data_out),
		.data_out_x(x_coord),
		.data_out_y(y_coord)
	);
	
	always @(posedge cam_pclk) begin 
		if (~reset) begin
			counter = 0;
			cam_x = 0;
			cam_y = 0;
			enable = 0;
		end
		else begin
			if (cam_href && ~cam_vs) begin 
					if (counter) begin
					enable = 1;
					cam_x = cam_x + 1;
					if (cam_x == 640) begin 
						cam_x = 0;
						cam_y = cam_y + 1;
					end
					if (cam_y == 480) begin 
						cam_y = 0;
					end
				end
				counter = counter + 1;
			end
			else begin 
				enable = 0;
			end
		end
	end
	
endmodule