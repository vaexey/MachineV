`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:45:29 06/14/2024 
// Design Name: 
// Module Name:    MachineV 
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
module MachineV
	#(
		WORD_WIDTH = 8,
		ADDRESS_WIDTH = 5
	)
	(
		input CLK,
		
		inout [ADDRESS_WIDTH-1:0] Abus, 
		inout [WORD_WIDTH-1:0] Dbus,
		
		output [SIGNAL_COUNT-1:0] signals,
		output [WORD_WIDTH - ADDRESS_WIDTH - 1:0] instr,
		
		output [ADDRESS_WIDTH-1:0] L,
		output [WORD_WIDTH-1:0] Acc
	);

parameter SIGNAL_COUNT = 32;

wire ALU_add, ALU_sub, ALU_write, ALU_read;
assign {ALU_add, ALU_sub, ALU_write, ALU_read} = signals[3:0]; //4

wire I_in, I_out;
assign {I_in, I_out} = signals[5:4]; //2

wire L_in, L_out, L_inc;
assign {L_in, L_out, L_inc} = signals[8:6]; //3

wire Mem_write, Mem_read, Mem_in, Mem_out, Mem_addr;
assign {Mem_write, Mem_read, Mem_in, Mem_out, Mem_addr} = signals[13:9]; //5

ALU #(
	.WIDTH(WORD_WIDTH)
) alu (
	.CLK(CLK),
	
	.Dbus(Dbus),
	
	.add(ALU_add),
	.sub(ALU_sub),
	.write(ALU_write),
	.read(ALU_read),
	
	.Acc(Acc)
);

IRegister #(
	.WORD_WIDTH(WORD_WIDTH),
	.ADDRESS_WIDTH(ADDRESS_WIDTH)
) ireg (
	.CLK(CLK),
	
	.Abus(Abus),
	.Dbus(Dbus),
	
	.instr(instr),
	
	.Din(I_in),
	.Aout(I_out)
);

LCounter #(
	.WIDTH(ADDRESS_WIDTH)
) lcnt (
	.CLK(CLK),
	
	.Abus(Abus),
	
	.Lin(L_in),
	.Lout(L_out),
	.inc(L_inc),
	
	.L(L)
);

Memory #(
	.WORD_WIDTH(WORD_WIDTH),
	.ADDRESS_WIDTH(ADDRESS_WIDTH)
) mem (
	.CLK(CLK),
	
	.Abus(Abus),
	.Dbus(Dbus),
	
	.read(Mem_read),
	.write(Mem_write),
	
	.Ain(Mem_addr),
	.Din(Mem_in),
	.Dout(Mem_out)
);

ControlUnit cu (
	.CLK(CLK),
	
	.instr(instr),
	
	.signals(signals)
);

endmodule
