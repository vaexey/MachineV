`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:07:26 06/15/2024 
// Design Name: 
// Module Name:    Divider 
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
module Divider
	#(
		MODULO = 100000000
	)
	(
		input CLK,
		
		input CE,
		
		output reg [WIDTH-1:0] Q = {WIDTH{1'b0}},
		output reg CO = 0
	);

parameter WIDTH = $clog2(MODULO);

always @(posedge CLK)
begin

	if(CE)
	begin
		if(Q == MODULO)
		begin
			Q = {WIDTH{1'b0}};
			CO = ~CO;
		end
		else
			Q = Q + 1'b1;
	end

end

endmodule
