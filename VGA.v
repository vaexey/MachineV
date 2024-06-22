`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:13:47 06/16/2024 
// Design Name: 
// Module Name:    VGA 
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
module VGA
	#(
		COLOR_WIDTH = 2,
		BASE_CLK_FREQ = 100_000_000
	)
	(
		input CLK,
		
		output [COLOR_WIDTH-1:0] R,
		output [COLOR_WIDTH-1:0] G,
		output [COLOR_WIDTH-1:0] B,
		
		output HSync,
		output VSync,
		
		input enter,
		input [7:0] data,
		input [9:0] dataX,
		input [9:0] dataY
	);

parameter VGA_CLOCK = 25_000_000;
parameter CLK_DIVIDER = BASE_CLK_FREQ / VGA_CLOCK / 2;

wire pxCLK;

wire active;
wire [9:0] x;
wire [9:0] y;

Divider #(
	.MODULO(CLK_DIVIDER)
) div (
	.CLK(CLK),
	
	.CE(1),
	
	.CO(pxCLK)
);

VGAClock vclk(
	.CLK(pxCLK),
	
	.active(active),
	
	.HSync(HSync),
	.VSync(VSync),
	
	.x(x),
	.y(y)
);

wire [5:0] C;

assign R = active ? C[1:0] : 2'b00;
assign G = active ? C[3:2] : 2'b00;
assign B = active ? C[5:4] : 2'b00;

parameter CHAR_WIDTH = 8;
parameter CHAR_HEIGHT = 16;

parameter CHARS_H = 640 / CHAR_WIDTH;
parameter CHARS_V = 480 / CHAR_HEIGHT;

reg [7:0] text [CHARS_H-1:0][CHARS_V-1:0];
reg [127:0] chars [255:0];

initial begin
	`define FONT_MAP chars
	`include "meminit_font.v"
end

integer i, j;

initial begin
	for(i = 0; i < CHARS_H; i = i + 1) begin
		for (j = 0; j < CHARS_V; j = j + 1) begin
			if(i < 9 && j == 0) begin
			
			end else if(i == 0 || j == 0 || i == CHARS_H-1 || j == CHARS_V-1)
				text[i][j] = 8'd176;
			else
				text[i][j] = 8'd32;
		end
	end
	
	text[0][0] = "H";
	text[1][0] = "e";
	text[2][0] = "l";
	text[3][0] = "l";
	text[4][0] = "o";
	text[5][0] = ",";
	text[6][0] = " ";
	text[7][0] = "W";
	text[8][0] = "!";
end

wire [9:0] xSafe = (x == 639) ? x : (x+1);
wire [9:0] ySafe = (y == 479) ? y : (y+1);

wire [7:0] charId;
assign charId = text[xSafe >> 3][ySafe >> 4];

wire [6:0] pixelId;
assign pixelId = (x[2:0] + (y[3:0] << 3));

wire [7:0] colorFG = 6'b111111;
wire [7:0] colorFSEL = 6'b110011;
wire [7:0] colorBG = 6'b000000;

//assign C = (curChar[pixelId] != 1'b1) ? colorBG :
//				(x == terminalX && y == terminalY) ? colorFSEL : colorFG;
assign C = (curChar[pixelId] != 1'b1) ? colorBG : colorFG;

reg [127:0] curChar = 128'b0;

always @(posedge pxCLK)
begin

	curChar = chars[charId];
	
	//C = {6{chars[text[x >> 3][y >> 4]][ x[2:0] + y[3:0] << 3]}};
//	C[0] = chars[64][pixelId];
//	C[1] = chars[64][pixelId];
//	C[0] = letAt[pixelId];
//	C[1] = letAt[pixelId];
//	
//	C[5:2] = 4'b0000;
//	curChar = 128'b00000000000000000000000000000000001111100000001100111011011110110111101101111011011000110110001100111110000000000000000000000000;
//	curChar = chars[65];


end

always @(posedge CLK)
begin

	if(enter)
	begin
		text[dataX][dataY] = data;
	end

end

endmodule
