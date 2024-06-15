`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   23:44:53 06/13/2024
// Design Name:   LCounter
// Module Name:   D:/Projects/MachineV/LCounter_tb.v
// Project Name:  MachineV
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: LCounter
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module LCounter_tb;

	// Inputs
	reg CLK;
	reg Lin;
	reg Lout;
	reg inc;

	// Bidirs
	wire [4:0] Abus;

	// Instantiate the Unit Under Test (UUT)
	LCounter uut (
		.CLK(CLK), 
		.Lin(Lin), 
		.Lout(Lout), 
		.inc(inc), 
		.Abus(Abus)
	);

	initial begin
		// Initialize Inputs
		CLK = 0;
		Lin = 0;
		Lout = 1;
		inc = 0;

		// Wait 100 ns for global reset to finish
		#30;
        
		// Add stimulus here
		inc = 1;
		
		#10
		inc = 0;
		
		#10
		inc = 1;
		
		#200
		inc = 0;
		
		#20
		$finish;

	end
	
	always #10 CLK = ~CLK;
      
endmodule

