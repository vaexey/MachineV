`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:42:18 06/13/2024
// Design Name:   Memory
// Module Name:   D:/Projects/MachineV/Memory_tb.v
// Project Name:  MachineV
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Memory
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Memory_tb;

	// Inputs
	reg CLK;
	reg read;
	reg write;
	reg Ain;
	reg Din;
	reg Dout;
	reg [4:0] Abus;

	// Bidirs
	wire [7:0] Dbus;
	
	reg [7:0] Dvalue;
	reg Dwrite;
	
	assign Dbus = Dwrite ? Dvalue : 8'bZZZZZZZZ;

	// Instantiate the Unit Under Test (UUT)
	Memory uut (
		.CLK(CLK), 
		.read(read), 
		.write(write), 
		.Ain(Ain), 
		.Din(Din), 
		.Dout(Dout), 
		.Abus(Abus), 
		.Dbus(Dbus)
	);

	initial begin
		// Initialize Inputs
		CLK = 0;
		read = 0;
		write = 0;
		Ain = 0;
		Din = 0;
		Dout = 0;
		Abus = 0;
		Dwrite = 0;
		
		// Wait 100 ns for global reset to finish
		#20;
        
		// Add stimulus here
		Dvalue = 8'b11111111;
		Dwrite = 1;
		Din = 1;
		
		Abus = 8'd1;
		
		Ain = 1;
		
		#20
		write = 1;
		
		#20
		write = 0;
		Ain = 0;
		Din = 0;
		Dwrite = 0;
		
		#20
		read = 1;
		
		#20
		Dout = 1;
		
		#20
		
		$finish;
	end
      
	always #10 CLK = ~CLK;
      
endmodule

