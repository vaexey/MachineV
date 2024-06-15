`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:57:46 06/13/2024
// Design Name:   ALU
// Module Name:   D:/Projects/MachineV/ALU_tb.v
// Project Name:  MachineV
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ALU
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module ALU_tb;

	// Inputs
	reg CLK;
	reg add;
	reg sub;
	reg write;
	reg read;

	// Outputs
	wire [7:0] Acc;

	// Bidirs
	wire [7:0] Dbus;
	
	assign Dbus = (Dwrite) ? Dvalue : 8'bZZZZZZZZ;
	
	reg Dwrite;
	reg [7:0] Dvalue;

	// Instantiate the Unit Under Test (UUT)
	ALU uut (
		.CLK(CLK), 
		.add(add), 
		.sub(sub), 
		.write(write), 
		.read(read), 
		.Dbus(Dbus), 
		.Acc(Acc)
	);

	initial begin
		// Initialize Inputs
		CLK = 0;
		add = 0;
		sub = 0;
		write = 0;
		read = 0;
		Dvalue = 8'd5;
		Dwrite = 1;

		// Wait 100 ns for global reset to finish
		#20;
        
		// Add stimulus here
		//add = 1;
		
		#20
		write = 1;
		
		#20
		write = 0;
		add = 0;
		Dwrite = 0;
		
		#20
		read = 1;
		
		#20
		read = 0;
		
		Dvalue = 8'd10;
		Dwrite = 1;
		add = 1;
		
		#20
		write = 1;
		
		#20
		write = 0;
		
		add = 0;
		sub = 1;
		
		#20
		write = 1;
		
		#20
		
		$finish;
	end
      
	always #10 CLK = ~CLK;
		
endmodule

