`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:38:19 06/13/2024 
// Design Name: 
// Module Name:    LCounter 
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
module LCounter
	#(
		WIDTH = 5
	)
	(
		input CLK,
		
		input Lin, Lout,
		input inc,
		
		inout [WIDTH-1:0] Abus,

		output reg [WIDTH-1:0] L = {WIDTH{1'b0}}
	);

assign Abus = Lout ? L : {WIDTH{1'bZ}};
	
always @(posedge CLK)
begin
	if(inc) begin
		L <= L + 1;
	end
	
	if(Lin) begin
		L <= Abus;
	end
end


endmodule
