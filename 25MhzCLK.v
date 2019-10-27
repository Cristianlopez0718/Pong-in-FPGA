`timescale 1ns / 1ps
  //****************************************************************// 
  //  File name: <Ticker.v>                                       //       
  //  Created by       <Cristian Lopez> on <September 24, 2018>.    // 
  //  Copyright © 2018 <Cristian lopez>. All rights reserved.       //
  //                                                                // 
  //  In submitting this file for class work at CSULB               // 
  //  I am confirming that this is my work and the work             // 
  //  of no one else. In submitting this code I acknowledge that    // 
  //  plagiarism in student project work is subject to dismissal.   // 
  //  from the class                                                //
  //****************************************************************//
module Ticker(clk, rst, tick);
input clk, rst;
output tick;
reg [1:0] count;

assign tick = (count == 2'd3);//25MHz signal

always @(posedge clk, posedge rst)
	if (rst) count <= 2'b0;
	else begin
		if (tick) count <= 2'b0;
		else count <= count + 2'b1;
	end
endmodule
