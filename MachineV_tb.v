`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   02:08:48 06/15/2024
// Design Name:   MachineV
// Module Name:   D:/Projects/MachineV/MachineV_tb.v
// Project Name:  MachineV
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: MachineV
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module MachineV_tb;

	// Inputs
	reg CLK;

	// Outputs
	wire [31:0] signals;
	wire [2:0] instr;

	// Bidirs
	wire [4:0] Abus;
	wire [7:0] Dbus;

	// Instantiate the Unit Under Test (UUT)
	MachineV uut (
		.CLK(CLK), 
		.Abus(Abus), 
		.Dbus(Dbus), 
		.signals(signals), 
		.instr(instr)
	);

	initial begin
		// Initialize Inputs
		CLK = 0;

		// Wait 100 ns for global reset to finish
		#20;
        
		// Add stimulus here
		
		//#2000;
		
		//$finish;

	end
	
	always #20 CLK = ~CLK;
      
endmodule

