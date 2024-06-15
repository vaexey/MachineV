`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:36:00 06/13/2024 
// Design Name: 
// Module Name:    ALU 
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
module ALU
	#(
		WIDTH = 8
	)
	(
		input CLK,
	
		input add, sub,
		input write,
		input read,
		
		inout [WIDTH-1:0] Dbus,
		
		output reg [WIDTH-1:0] Acc = {WIDTH{1'b0}}
    );

wire [WIDTH-1:0] result;

assign result = add ? (Acc + Dbus) :
                sub ? (Acc - Dbus) :
					 Dbus;

assign Dbus = read ? Acc : {WIDTH{1'bZ}};

always @(posedge CLK)
begin
	if(write)
	begin
		Acc <= result;
	end
end

endmodule
