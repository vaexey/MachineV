`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:48:55 06/13/2024 
// Design Name: 
// Module Name:    IRegister 
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
module IRegister
	#(
		WORD_WIDTH = 8,
		ADDRESS_WIDTH = 5
	)
	(
		input CLK,
	
		input Din, Aout,
	
		output [WORD_WIDTH - ADDRESS_WIDTH - 1:0] instr,
		output [ADDRESS_WIDTH-1:0] Abus,
		input [WORD_WIDTH-1:0] Dbus,
		
		output reg [WORD_WIDTH-1:0] I = {WORD_WIDTH{1'b0}}
   );

assign Abus = Aout ? I[ADDRESS_WIDTH-1:0] : {ADDRESS_WIDTH{1'bZ}};
assign instr = I[WORD_WIDTH - 1:ADDRESS_WIDTH];

always @(posedge CLK)
begin
	if(Din) begin
		I <= Dbus;
	end
end

endmodule
