`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:13:20 06/15/2024 
// Design Name: 
// Module Name:    bcd2seg 
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
module bcd2seg(
		input [3:0] bcd,
		output [7:0] seg
	);

//assign seg = ~(
//	(bcd == 4'd0) ? 8'b00111111 :
//	(bcd == 4'd1) ? 8'b00000110 :
//	(bcd == 4'd2) ? 8'b01011011 :
//	(bcd == 4'd3) ? 8'b01001111 :
//	(bcd == 4'd4) ? 8'b01100110 :
//	(bcd == 4'd5) ? 8'b01101101 :
//	(bcd == 4'd6) ? 8'b01111101 :
//	(bcd == 4'd7) ? 8'b00000111 :
//	(bcd == 4'd8) ? 8'b01111111 :
//	(bcd == 4'd9) ? 8'b01101111 :
//						 8'b01000000
//);

assign seg = 
	(bcd == 4'd0) ? 8'b00000011 :
	(bcd == 4'd1) ? 8'b10011111 :
	(bcd == 4'd2) ? 8'b00100101 :
	(bcd == 4'd3) ? 8'b00001101 :
	(bcd == 4'd4) ? 8'b10011001 :
	(bcd == 4'd5) ? 8'b01001001 :
	(bcd == 4'd6) ? 8'b01000001 :
	(bcd == 4'd7) ? 8'b00011111 :
	(bcd == 4'd8) ? 8'b00000001 :
	(bcd == 4'd9) ? 8'b00001001 :
						 8'b11111100;

endmodule
