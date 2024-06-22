`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:09:57 06/20/2024 
// Design Name: 
// Module Name:    SPRegister 
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
module SPRegister
	#(
		WORD_WIDTH = 8,
		ADDRESS_WIDTH = 5
	)
	(
		input CLK, //CLR,
	
		input Din, Aout,
		
		input inc, dec,
		
		inout [ADDRESS_WIDTH-1:0] Abus,
		
		output reg [ADDRESS_WIDTH-1:0] SP = {ADDRESS_WIDTH{1'b0}}
   );

assign Abus = Aout ? SP : {ADDRESS_WIDTH{1'bZ}};

always @(posedge CLK)
begin
//	if(CLR)
//		SP <= {ADDRESS_WIDTH{1'b0}};

	if(Din)
		SP <= Abus;
	
	if(inc)
		SP = SP + 1;
		
	if(dec)
		SP = SP - 1;
end

endmodule
