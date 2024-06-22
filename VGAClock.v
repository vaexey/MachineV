`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:14:56 06/16/2024 
// Design Name: 
// Module Name:    VGAClock 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module VGAClock
	#(
		//CLK_BASE_FRQ = 100_000_000
	)
	(
		input CLK,
		
		output VSync,
		output HSync,
		
		output active,
		
		output [X_SIZE-1:0] x,
		output [Y_SIZE-1:0] y,
		
		output reg [X_SIZE-1:0] rawX,
		output reg [Y_SIZE-1:0] rawY
	);

parameter X_SIZE = $clog2(WIDTH_TOTAL);
parameter Y_SIZE = $clog2(HEIGHT_TOTAL);

parameter WIDTH_TOTAL = 800;
parameter HEIGHT_TOTAL = 525;
parameter WIDTH = 640;
parameter HEIGHT = 480;

parameter PORCH_TOP = 50;
parameter PORCH_LEFT = 33;

parameter PORCH_RIGHT = WIDTH + PORCH_LEFT;
parameter PORCH_BOTTOM = HEIGHT + PORCH_TOP;

parameter H_SYNC_X = 704;
parameter V_SYNC_Y = 523;

always @(posedge CLK)
begin
	
	// Pixel position counters
	if (rawX < WIDTH_TOTAL) begin
		rawX = rawX + 1'b_1;
	end else begin
		rawX = {X_SIZE{1'b_0}};
		
		if (rawY < HEIGHT_TOTAL) begin
			rawY = rawY + 1'b_1;
		end else begin
			rawY = {Y_SIZE{1'b_0}};
		end
	end
	
end

assign HSync = (rawX < H_SYNC_X) ? 1'b_1 : 1'b_0;
assign VSync = (rawY < V_SYNC_Y) ? 1'b_1 : 1'b_0;

assign active = (
	rawX >= PORCH_LEFT && rawX < PORCH_RIGHT && 
	rawY >= PORCH_TOP && rawY < PORCH_BOTTOM
) ? 1'b_1 : 1'b_0;

assign x = active ? (rawX - PORCH_LEFT) : {X_SIZE{1'b0}};
assign y = active ? (rawY - PORCH_TOP) : {Y_SIZE{1'b0}};

endmodule
