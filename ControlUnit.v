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
		INSTR_COUNT = 8,
		SIGNAL_COUNT = 32,
		MAX_CYCLES = 8
	)
	(
		input CLK,
		
		input [INSTR_WIDTH - 1:0] instr,
		
		output reg fetch = 1,
		output execute,
		
		output reg [CYCLE_WIDTH-1:0] phase = 0,
		output reg [SIGNAL_COUNT-1:0] signals = 0
	);


assign execute = ~fetch;

parameter INSTR_WIDTH = $clog2(INSTR_COUNT);
parameter CYCLE_WIDTH = $clog2(MAX_CYCLES);

reg [SIGNAL_COUNT-1:0] signalMap [INSTR_COUNT-1:0] [MAX_CYCLES-1:0];
reg [CYCLE_WIDTH-1:0] instrLengthMap [INSTR_COUNT-1:0];

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
signalMap[0][0] = 32'b00000000000000000001010001100000;
signalMap[0][1] = 32'b00000000000000000000001010000000;
signalMap[0][2] = 32'b00000000000000000000000000000000;
signalMap[0][3] = 32'b00000000000000000000000000000000;
signalMap[0][4] = 32'b00000000000000000000000000000000;
signalMap[0][5] = 32'b00000000000000000000000000000000;
signalMap[0][6] = 32'b00000000000000000000000000000000;
signalMap[0][7] = 32'b00000000000000000000000000000000;
signalMap[1][0] = 32'b00000000000000000001010001100000;
signalMap[1][1] = 32'b00000000000000000000001000010000;
signalMap[1][2] = 32'b00000000000000000001011010001010;
signalMap[1][3] = 32'b00000000000000000000000000000000;
signalMap[1][4] = 32'b00000000000000000000000000000000;
signalMap[1][5] = 32'b00000000000000000000000000000000;
signalMap[1][6] = 32'b00000000000000000000000000000000;
signalMap[1][7] = 32'b00000000000000000000000000000000;
signalMap[2][0] = 32'b00000000000000000001010001100000;
signalMap[2][1] = 32'b00000000000000000000001000010000;
signalMap[2][2] = 32'b00000000000000000001011010000110;
signalMap[2][3] = 32'b00000000000000000000000000000000;
signalMap[2][4] = 32'b00000000000000000000000000000000;
signalMap[2][5] = 32'b00000000000000000000000000000000;
signalMap[2][6] = 32'b00000000000000000000000000000000;
signalMap[2][7] = 32'b00000000000000000000000000000000;
signalMap[3][0] = 32'b00000000000000000001010001100000;
signalMap[3][1] = 32'b00000000000000000000001000010000;
signalMap[3][2] = 32'b00000000000000000001011010000010;
signalMap[3][3] = 32'b00000000000000000000000000000000;
signalMap[3][4] = 32'b00000000000000000000000000000000;
signalMap[3][5] = 32'b00000000000000000000000000000000;
signalMap[3][6] = 32'b00000000000000000000000000000000;
signalMap[3][7] = 32'b00000000000000000000000000000000;
signalMap[4][0] = 32'b00000000000000000001010001100000;
signalMap[4][1] = 32'b00000000000000000000101000010001;
signalMap[4][2] = 32'b00000000000000000010001010000000;
signalMap[4][3] = 32'b00000000000000000000000000000000;
signalMap[4][4] = 32'b00000000000000000000000000000000;
signalMap[4][5] = 32'b00000000000000000000000000000000;
signalMap[4][6] = 32'b00000000000000000000000000000000;
signalMap[4][7] = 32'b00000000000000000000000000000000;
signalMap[5][0] = 32'b00000000000000000001010001100000;
signalMap[5][1] = 32'b00000000000000000000001100010000;
signalMap[5][2] = 32'b00000000000000000000000000000000;
signalMap[5][3] = 32'b00000000000000000000000000000000;
signalMap[5][4] = 32'b00000000000000000000000000000000;
signalMap[5][5] = 32'b00000000000000000000000000000000;
signalMap[5][6] = 32'b00000000000000000000000000000000;
signalMap[5][7] = 32'b00000000000000000000000000000000;
signalMap[6][0] = 32'b00000000000000000000000000000000;
signalMap[6][1] = 32'b00000000000000000000000000000000;
signalMap[6][2] = 32'b00000000000000000000000000000000;
signalMap[6][3] = 32'b00000000000000000000000000000000;
signalMap[6][4] = 32'b00000000000000000000000000000000;
signalMap[6][5] = 32'b00000000000000000000000000000000;
signalMap[6][6] = 32'b00000000000000000000000000000000;
signalMap[6][7] = 32'b00000000000000000000000000000000;
signalMap[7][0] = 32'b00000000000000000000000000000000;
signalMap[7][1] = 32'b00000000000000000000000000000000;
signalMap[7][2] = 32'b00000000000000000000000000000000;
signalMap[7][3] = 32'b00000000000000000000000000000000;
signalMap[7][4] = 32'b00000000000000000000000000000000;
signalMap[7][5] = 32'b00000000000000000000000000000000;
signalMap[7][6] = 32'b00000000000000000000000000000000;
signalMap[7][7] = 32'b00000000000000000000000000000000;
	
	
	$readmemh("lengths.mem", instrLengthMap);
end

reg [SIGNAL_COUNT-1:0] readSignals;
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
		signals = signalMap[instr][0];
		
		fetch = 0;
	end else begin
		// EXECUTE CYCLE
		
		//signals <= readSignals;
		//readSignals = signalMap[instr][phase];
		signals = signalMap[instr][phase];
		instrLength = instrLengthMap[instr];
		
		if(phase == instrLength)
		begin
			fetch = 1;
		end
		
		phase = phase + 1'b1;
	end
end

endmodule
