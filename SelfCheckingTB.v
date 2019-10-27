`timescale 1ns / 1ps
 //****************************************************************// 
  //  File name: <Tob_Module_tb>                                       //       
  //  Created by       <Cristian Lopez> on <November 15, 2018>.      // 
  //  Copyright © 2018 <Cristian lopez>. All rights reserved.       //
  //                                                                // 
  //  In submitting this file for class work at CSULB               // 
  //  I am confirming that this is my work and the work             // 
  //  of no one else. In submitting this code I acknowledge that    // 
  //  plagiarism in student project work is subject to dismissal.   // 
  //  from the class                                                //
  //****************************************************************//
module Top_module_tb;
	// Inputs
	reg clk;
	reg reset;
	// Outputs
	wire hsync;
	wire vsync;
	wire [11:0] rgb;
	wire video_on;
	wire [9:0] pixel_x;
	wire [9:0] pixel_y;
	wire tick;
	wire vvideo_on;
	wire hvideo_on;
	integer count;
	integer c;
	integer c2;
	// Instantiate the Unit Under Test (UUT)
	Top_module uut (
		.clk(clk), 
		.reset(reset), 
		.hsync(hsync), 
		.vsync(vsync), 
		.rgb(rgb), 
		.video_on(video_on), 
		.pixel_x(pixel_x), 
		.pixel_y(pixel_y),
		.vvideo_on(vvideo_on), 
		.hvideo_on(hvideo_on),
		.tick(tick)
	);

always #5 clk = ~clk;

initial begin
	$timeformat(-9, 2, "ns", 5);
		// Initialize Inputs
		$display("Starting the Simulation %d", $time);
		reset = 1;
		clk = 0;
		// Wait 10 ns for global reset to finish
		#5;
		reset = 0;
		c =0;
		c2 =0;
		#5 count =0;
end
	always@(posedge clk, posedge tick) begin
		if (count == 4)
			count =0;
		else begin
			
				count = count + 1;
		end
	if (count == 0)
		if (tick != 1)
			$display("tick error %d", $time); // 25mhz signal for tick
	end //end of tick checking
	
	always @(negedge tick) begin            
	c = c +1;                              //checking horizontal scan count gets uptaded at tick
	if (c == 800)begin
		c2 = c2 +1; c =0;		//checking vertical scan count gets uptaded completion of pixel_x
	end
	if (c2 == 525)                          //checking pixel_y range
			c2 =0;
	if (pixel_x != c)                       // checking pixel x is 0 to 799
		$display( "Error when pixel_x is incrementing, time %d", $time);
	if (pixel_y != c2)                       // checking pixel x is 0 to 799
		$display( "Error when pixel_y is incrementing, time %d", $time);
	end
	
	always @(posedge pixel_x, posedge pixel_y ) begin
	
	if((pixel_x >= 10'd656) && (pixel_x <= 10'd751))  // 9) h_sync low active from 656 to 751
		if (hsync != 0)
			$display("Error on Horizontal sync %d, time %d", pixel_x, $time);
	if(pixel_y >= 10'd490 && pixel_y <= 10'd491)        // 5) vsync low active from 490 to 491
		if (vsync != 0 )
			$display("Error on Vertical sync %d, time %d", pixel_y, $time);
	if(pixel_y >= 10'd0 && pixel_y <= 10'd479)          //6) vvideo_on from 0 to 479
		if(vvideo_on != 1)
				$display("Error on Vertical video_on  %d, time %d", pixel_y, $time);
	if((pixel_x >= 10'd0) && (pixel_x <= 10'd639))       // 10) hvideo_on from 0 to 639
		if(hvideo_on != 1)
					$display("Error on horizontal video_on  %d, time %d", pixel_x, $time);

	if ((pixel_x >= 10'd580) && (pixel_x <= 10'd588)&& // paddle dimensions
		 (pixel_y >= 10'd238) && (pixel_y <= 10'd246)) 
		if ( rgb != 12'hfff) 
			$display("Error on paddle dimensions,  time %d", $time);
		
	else if ((pixel_x >= 32) && (pixel_x <= 35))  // check wall dimensions
			if ( rgb != 12'hfff) 
				$display("Error on wall dimensions,  time %d", $time);
	else if ((pixel_x >= 10'd600) && (pixel_x <= 10'd603) && // ball dimensions
		(pixel_y >= 10'd204) && (pixel_y <= 10'd276))
			if( rgb != 12'hfff)
				$display("Error on ball dimensions, time %d", $time);
	end//always
endmodule
