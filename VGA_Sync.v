`timescale 1ns / 1ps
//****************************************************************// 
  //  File name: <VGA_Sync>                                       //       
  //  Created by       <Cristian Lopez> on <October 18, 2018>.    // 
  //  Copyright © 2018 <Cristian lopez>. All rights reserved.       //
  //                                                                // 
  //  In submitting this file for class work at CSULB               // 
  //  I am confirming that this is my work and the work             // 
  //  of no one else. In submitting this code I acknowledge that    // 
  //  plagiarism in student project work is subject to dismissal.   // 
  //  from the class                                                //
  //****************************************************************//
module VGA_Sync(clk, rst, pixel_x, pixel_y, video_on, hsync, vsync, vvideo_on, hvideo_on);
input clk, rst;
output  hsync, vsync, video_on, vvideo_on, hvideo_on;
output  [9:0] pixel_x, pixel_y; //
reg video_on;
wire hvideo_on, vvideo_on, video_on_next;
reg [9:0] h_count_reg, h_count_next;
reg [9:0] v_count_reg , v_count_next;
reg v_sync_reg, h_sync_reg;
wire v_sync_next, h_sync_next;  

Ticker Ti(.clk(clk), .rst(rst), .tick(tick));
// register logic
always @(posedge clk, posedge rst) begin
	if (rst) begin
		v_count_reg <= 10'b0;
		h_count_reg <= 10'b0;
		v_sync_reg <= 1'b0;
		h_sync_reg <= 1'b0; end
	else begin
		v_count_reg <= v_count_next;
		h_count_reg <= h_count_next;
		v_sync_reg <= v_sync_next;
		h_sync_reg <= h_sync_next;
		video_on <= video_on_next;
		end
	end
//horizontal 
always @(*)
	if (tick) begin
		if (h_count_reg == 799) 
			h_count_next = 10'b0;
		else
			h_count_next = h_count_reg + 10'b1; end
	else 
		h_count_next = h_count_reg;
//verical 
always @(*)
	if (tick & (h_count_reg == 799)) 
		if (v_count_reg == 524) 
			v_count_next = 10'b0;
		else 
			v_count_next = v_count_reg + 10'b1;
	else
			v_count_next = v_count_reg;
			
assign h_sync_next = (h_count_next >= 10'd656 && h_count_next <= 10'd751) ? 1'b0 : 1'b1; //low active h_sync
assign v_sync_next = (v_count_next >= 10'd490 && v_count_next <= 10'd491) ? 1'b0 : 1'b1;//low active v_sync
		
assign hvideo_on = (h_count_reg >= 10'b0 && h_count_reg < 10'd640);
assign vvideo_on = (v_count_reg >= 10'b0 && v_count_reg < 10'd480);
assign video_on_next = (hvideo_on && vvideo_on);
 // output logic
	assign hsync = h_sync_reg;
	assign vsync = v_sync_reg;
	assign pixel_x = h_count_reg;
	assign pixel_y = v_count_reg;
endmodule
