`timescale 1ns / 1ps
//****************************************************************// 
  //  File name: <Pixel_Generator>                                //       
  //  Created by       <Cristian Lopez> on <december 12, 2018>.    // 
  //  Copyright © 2018 <Cristian lopez>. All rights reserved.       //
  //                                                                // 
  //  In submitting this file for class work at CSULB               // 
  //  I am confirming that this is my work and the work             // 
  //  of no one else. In submitting this code I acknowledge that    // 
  //  plagiarism in student project work is subject to dismissal.   // 
  //  from the class                                                //
  //****************************************************************//
module Pixel_Gen(clk, rst, video_on, btn_down, btn_up, tick60HZ, pixel_x, pixel_y, rgb_out);
input clk, rst, video_on, btn_down, btn_up, tick60HZ;
input [9:0] pixel_x, pixel_y;
output reg [11:0] rgb_out;
reg [9:0] paddle_y_reg, paddle_y_next;
wire wall_on, ball_on, paddle_on;
wire [9:0] paddle_bottom, paddle_top;
reg game_over;
////////ball variables /////////////
reg [9:0] x_delta_reg, x_delta_next, y_delta_reg, y_delta_next,
          ball_x_reg, ball_y_reg; //
			 
wire [9:0] ball_y_t, ball_y_b, ball_x_l, ball_x_r,  ball_x_next, ball_y_next;
//////////////////////////////////////ball operations///////////////////////////////////
assign ball_y_t = ball_y_reg;
assign ball_y_b = ball_y_reg + 10'd7;
assign ball_x_r = ball_x_reg;
assign ball_x_l = ball_x_reg + 10'd7;
assign ball_x_next = (game_over) ? 10'b0 :((tick60HZ) ? ball_x_reg + x_delta_reg : ball_x_reg);
assign ball_y_next = (game_over) ? 10'b0 : ((tick60HZ) ? ball_y_reg + y_delta_reg : ball_y_reg);


always @(*) begin                  //////ball speeds
	x_delta_next = x_delta_reg;
	y_delta_next = y_delta_reg;
	if (ball_y_t < 1) begin
		y_delta_next = 2;
		game_over = 1'b0; end
	else if(ball_y_b > 479) begin
		y_delta_next = -2;
		game_over = 1'b0; end
	else if(ball_x_r <= 35) begin
		x_delta_next = 2;
		game_over = 1'b0; end
	  else if(ball_x_r >= 679) begin  // game over restart ball position and speed
		x_delta_next = 10'h4;
		y_delta_next = 10'h4;
		game_over = 1'b1;	end
	else if((ball_x_r >= 580) && ( ball_x_r <= 588) &&
			  (paddle_top <= ball_y_b ) && (paddle_bottom >= ball_y_t)) begin
			x_delta_next = -2;
			game_over = 1'b0; end

end
assign ball_on = ((pixel_x >= ball_x_r) && ( pixel_x <= ball_x_l) &&
						(pixel_y >= ball_y_t) && (pixel_y <= ball_y_b));
////////////////////////////////////////// static   Wall //////////////////////////////////////////
assign wall_on = ((pixel_x >= 32) && (pixel_x <= 35));

//////////////////////////////////////////// paddle ///////////////////////////////////////////////
assign paddle_top = paddle_y_reg;
assign paddle_bottom = paddle_top + 10'd71; // move top of paddle acording to top register
always @(*) begin 
	paddle_y_next = paddle_y_reg; //stay the same if tick has not accured
	if (tick60HZ) begin
		if (btn_down & (paddle_bottom < 10'd475))/// move down until the boundarie (480)
		paddle_y_next = paddle_y_reg + 10'd4;
		if (btn_up & (paddle_top > 10'd5))////move up until top boundarie
		paddle_y_next = paddle_y_reg - 10'd4;	end
end
assign paddle_on = ((pixel_x >= 580) && (pixel_x <= 588) &&
                    (pixel_y <= paddle_bottom) && (pixel_y >= paddle_top));//paddle is on in this boundaries

						  
/////////////////////////////////////// register logic //////////////////////////////////////////////
always @(posedge clk, posedge rst) begin
           if (rst) begin
                      paddle_y_reg <= 10'b0;
                      x_delta_reg <= 10'h4;
							 y_delta_reg <= 10'h4;
							 ball_x_reg <= 10'b0;
							 ball_y_reg <= 10'b0;
							 
           end
           else begin
                      paddle_y_reg <= paddle_y_next;
							 x_delta_reg <= x_delta_next;
							 y_delta_reg <= y_delta_next;
							 ball_x_reg <= ball_x_next;
							 ball_y_reg <= ball_y_next;
           end
end


//////////////////////////////set RGB signals//////////////////////////
always @(*) begin
           if (~video_on)
                   rgb_out = 12'h0;
           else begin
                      if (wall_on)        // wall dimensions
                                 rgb_out = 12'hfff;
                      else if (paddle_on)
                                 rgb_out = 12'hfff;
                      else if (ball_on)
                                 rgb_out = 12'hfff; 
                      else 
                                 rgb_out = 12'b0; //white background
                      end    
end
endmodule

