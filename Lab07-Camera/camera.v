module camera(
  input reset,
  input cam_vs,
  input cam_hs,
  input cam_pclk,
  output cam_xclk,
  input cam_d0,
  input cam_d1,
  input cam_d2,
  input cam_d3,
  input cam_d4,
  input cam_d5,
  input cam_d6,
  input cam_d7,
  output [7:0] cam_byte,
  output reg [10:0] cam_x, 
  output reg [10:0] cam_y,
  output cam_reset,
  output pwdn
);
  reg [1:0] counter;
  assign cam_byte = {cam_d7, cam_d6, cam_d5, cam_d4, cam_d3, cam_d2, cam_d1, cam_d0};
  assign cam_reset = reset;
  assign pwdn = 0;

  always @(posedge cam_pclk) begin
    if (~reset) begin 
      counter = 0;
      cam_x = 0;
      cam_y = 0;
    end

    else begin 
      if (cam_vs == 0 && cam_hs == 1)
      begin
        counter = counter + 1;
      
        if (counter == 2) begin
          counter = 0;
          
          cam_x = cam_x + 1;

          if (cam_y == 479)
          begin
            cam_y = 0;
            cam_x = 0;
          end
          if (cam_x == 639)
          begin
            cam_y = cam_y + 1;
            cam_x = 0;
          end
        end
      end
    end
  end

endmodule