`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:18:57 06/15/2024 
// Design Name: 
// Module Name:    ControlUnit 
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
module ControlUnit
	#(
		WORD_WIDTH = 8,
		ADDRESS_WIDTH = 5,
		SIGNAL_COUNT = 32,
		FLAG_COUNT = 4,
		MAX_CYCLES = 4
	)
	(
		input CLK,
		
		input [INSTR_WIDTH - 1:0] instr,
		input [FLAG_COUNT-1:0] flags,
		
		output reg fetch = 1,
		output execute,
		
		output reg [CYCLE_WIDTH-1:0] phase = 0,
		output reg [SIGNAL_COUNT-1:0] signals = 0
	);


assign execute = ~fetch;

parameter INSTR_WIDTH = WORD_WIDTH - ADDRESS_WIDTH; //$clog2(INSTR_COUNT);
parameter INSTR_COUNT = 2**INSTR_WIDTH;
parameter CYCLE_WIDTH = $clog2(MAX_CYCLES);

//parameter TOTAL_MAP_COUNT = INSTR_COUNT * (2**FLAG_COUNT);
//parameter TOTAL_MAP_WIDTH = INSTR_WIDTH + FLAG_COUNT;

parameter LENGTH_MAP_COUNT = INSTR_COUNT * (2**FLAG_COUNT);
parameter LENGTH_MAP_WIDTH = INSTR_WIDTH + FLAG_COUNT;

parameter TOTAL_MAP_COUNT = LENGTH_MAP_COUNT * MAX_CYCLES;
parameter TOTAL_MAP_WIDTH = LENGTH_MAP_WIDTH + CYCLE_WIDTH;

//reg [SIGNAL_COUNT-1:0] signalMap [TOTAL_MAP_COUNT-1:0] [MAX_CYCLES-1:0];
reg [SIGNAL_COUNT-1:0] signalMap [TOTAL_MAP_COUNT-1:0];
reg [CYCLE_WIDTH-1:0] instrLengthMap [LENGTH_MAP_COUNT-1:0];

wire [CYCLE_WIDTH-1:0] phaseKey = fetch ? 0 : phase;

wire [TOTAL_MAP_WIDTH-1:0] signalMapKey;
//assign signalMapKey = { instr, flags };
assign signalMapKey = { instr, flags, phaseKey };

integer f_sig, i, j, r;
initial
begin
	//$readmemb("signals.mem", signalMap);
	
	// Read signal map (2D)
//	f_sig = $fopen("signals.mem", "r");
//
//	for(i = 0; i < INSTR_COUNT; i = i + 1) begin
//		for(j = 0; j < MAX_CYCLES; j = j + 1) begin
//			r = $fscanf(f_sig, "%b", signalMap[i][j]);
//		end
//	end
//	$fclose(f_sig);
	`define SIGNALS_MAP signalMap
	`include "meminit_signals.v"
	
	`define LENGTHS_MAP instrLengthMap
	`include "meminit_lengths.v"
	
//	$readmemh("lengths.mem", instrLengthMap);
end

//reg [SIGNAL_COUNT-1:0] readSignals;
reg [CYCLE_WIDTH-1:0] instrLength;

always @(negedge CLK)
begin
	if(fetch)
	begin
		// FETCH CYCLE
		phase = 1;
		
		//signals <= 0;
		
		//instrLength = instrLengthMap[instr];
		//readSignals = signalMap[instr][0];
		
		//signals = signalMap[signalMapKey][0];
		signals = signalMap[signalMapKey];
		
		fetch = 0;
	end else begin
		// EXECUTE CYCLE
		
		//signals <= readSignals;
		//readSignals = signalMap[instr][phase];
		
		//signals = signalMap[signalMapKey][phase];
		signals = signalMap[signalMapKey];
		instrLength = instrLengthMap[signalMapKey[TOTAL_MAP_WIDTH-1:CYCLE_WIDTH]];
		
		if(phase == instrLength)
		begin
			fetch = 1;
		end
		
		phase = phase + 1'b1;
	end
end

endmodule
