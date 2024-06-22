`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:25:33 06/15/2024
// Design Name:   Divider
// Module Name:   D:/Projects/MachineV/Divider_tb.v
// Project Name:  MachineV
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Divider
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Divider_tb;

	// Inputs
	reg CLK;
	reg CE;

	// Outputs
	wire [2:0] Q;
	wire CO;

	// Instantiate the Unit Under Test (UUT)
	Divider #(
		.MODULO(1)
	) uut (
		.CLK(CLK), 
		.CE(CE), 
		.Q(Q), 
		.CO(CO)
	);

	initial begin
		// Initialize Inputs
		CLK = 0;
		CE = 0;

		// Wait 100 ns for global reset to finish
		#100;
		
		CE = 1;
        
		// Add stimulus here

	end
	
	always #20 CLK = ~CLK;
      
endmodule

