# Pong-in-FPGA
Implemented a VGA controller to get a connection between a FPGA and a monitor. Begun the project by establishing static objects for the ball, paddle and the wall. Then took input from a switch to move the paddle up or down and changed the ball movement depending on the boundaries reached. 

Top_module - structutal verilog that connects all the modules to interface with the FPGA

25MhzCLK - divideds the clock into a 25Mhz clock to sync the VGA signal.

VGA_Sync - updates horizontal and vertical pixels displayed on the screen

Pixel_Animation - takes care of the pong animations, and movement of the objects.

SelfCheckingTB - This test bench was used to verify if the synchronazation is executed correctly.
