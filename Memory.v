`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:28:38 06/13/2024 
// Design Name: 
// Module Name:    Memory 
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
module Memory
	#(
		WORD_WIDTH = 8,
		ADDRESS_WIDTH = 5
	)
	(
		input CLK,
	
		input read, write,
		input Ain, Din, Dout,
	
		input [ADDRESS_WIDTH-1:0] Abus,
		
		inout [WORD_WIDTH-1:0] Dbus,

		output reg [ADDRESS_WIDTH-1:0] A = {ADDRESS_WIDTH {1'b0}},
		output reg [WORD_WIDTH-1:0] S = {WORD_WIDTH {1'b0}}
   );

reg [WORD_WIDTH-1:0] mem [(2**ADDRESS_WIDTH)-1:0];

//initial mem = {(WORD_WIDTH * (2**ADDRESS_WIDTH)) {1'b0}};
integer i;
initial begin
//	for(i = 0; i < (2**ADDRESS_WIDTH); i = i+1) begin
//		mem[i] = {WORD_WIDTH {1'b0}};
//	end

	`define RAM_MEMORY mem
	`include "meminit_ram.v"
	//$readmemb("ram.mem", mem);
end

wire [WORD_WIDTH-1:0] S_safe;

assign S_safe = read ? mem[A] : S;

assign Dbus = Dout ? S_safe : {WORD_WIDTH {1'bZ}};

always @(posedge CLK)
begin
	if(Ain) A <= Abus;
	
	if(Din) S <= Dbus;
	
	if(read) S <= mem[A];
	if(write) mem[A] <= S;
	
//	if(CLK)
//	begin
//		if(Ain) A <= Abus;
//		if(Din) S <= Dbus;
//
//		if(write) mem[A] <= S;
//	end
//	else
//		S <= mem[A];
//	
end

//always @(read) S <= mem[A];

endmodule
