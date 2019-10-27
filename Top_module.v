`timescale 1ns / 1ps
  //****************************************************************// 
  //  File name: <Tob_Module>                                       //       
  //  Created by       <Cristian Lopez> on <december 12, 2018>.      // 
  //  Copyright © 2018 <Cristian lopez>. All rights reserved.       //
  //                                                                // 
  //  In submitting this file for class work at CSULB               // 
  //  I am confirming that this is my work and the work             // 
  //  of no one else. In submitting this code I acknowledge that    // 
  //  plagiarism in student project work is subject to dismissal.   // 
  //  from the class                                                //
  //****************************************************************//
module Top_module(clk, reset, hsync, vsync, rgb, btn_d, btn_up);
input clk, reset, btn_d, btn_up;
output hsync, vsync;
output [11:0] rgb;
wire [9:0] pixel_x, pixel_y;

wire video_on;

AISO reset_mod(.clk(clk), .rst(reset), .d(1'b1), .rst_sync(rst)); // reset module
VGA_Sync Vsynv(.clk(clk), .rst(rst), .pixel_x(pixel_x), .pixel_y(pixel_y), .video_on(video_on), .hsync(hsync), .vsync(vsync), 
                .vvideo_on(), .hvideo_on());
Pixel_Gen animation(.clk(clk), .rst(rst), .video_on(video_on), .btn_down(btn_d), .btn_up(btn_up), .tick60HZ(t60), .pixel_x(pixel_x), .pixel_y(pixel_y), .rgb_out(rgb));
tick_60hz tick60HZ(.clk(clk), .rst(rst), .tick(t60));

endmodule
