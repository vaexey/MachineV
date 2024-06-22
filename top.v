`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:49:20 06/13/2024 
// Design Name: 
// Module Name:    top 
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
module top(
		input CLK,
		
		input [5:0] Switch,
		
		output reg [7:0] LED = 8'b11110000,
		output [7:0] SevenSegment,
		output reg [2:0] SevenSegmentEnable = 3'b011,
		
		output HSync, VSync,
		output [2:0] Red,
		output [2:0] Green,
		output [1:0] Blue
	);

wire dCLK, sCLK;

wire [7:0] Acc;
wire [4:0] L;
reg CE = 1'b1;

Divider #(
	.MODULO(25_000_000) // 1MHz -> 4Hz
) dclk (
	.CLK(CLK),
	.CE(CE),
	
	.CO(dCLK)
);

MachineV v(
	.CLK(dCLK),
	
	.Acc(Acc),
	.L(L)
);

reg [3:0] bcd = 0;
bcd2seg bcd_decoder(
	.bcd(bcd),
	.seg(SevenSegment)
);

Divider #(
	.MODULO(100_000) // 1MHz -> 1KHz
) segDiv (
	.CLK(CLK),
	.CE(1),
	
	.CO(sCLK)
);

always @(posedge CLK)
begin
	LED[0] = dCLK;
	LED[6:1] = ~Switch[5:0];
	
	bcd = sCLK ? L[3:0] : Acc[3:0];
	SevenSegmentEnable = sCLK ? 3'b101 : 3'b110;

//	LED[6:1] = Switch[5:0];
//
//	LED[0] = dCLK;
//	
//	if(dCLK)
//		bcd = L[3:0];
//	else
//		bcd = Acc[3:0];
end

assign Red = {r[1], r[0], r[0]};
assign Green = {g[1], g[0], g[0]};
assign Blue = b;

wire [1:0] r;
wire [1:0] g;
wire [1:0] b;

reg enter = 0;
reg [7:0] data = 65;
reg [9:0] dataX = 1;
reg [9:0] dataY = 1;

VGA vga(
	.CLK(CLK),
	
	.HSync(HSync),
	.VSync(VSync),
	
	.R(r),
	.G(g),
	.B(b),
	
	.data(data),
	.dataX(dataX),
	.dataY(dataY),
	.enter(enter)
);

always @(posedge dCLK)
begin
	if (dataX < 10)
		dataX = dataX + 1;
	else begin
		dataX = 1;
		
		if (dataY < 10)
			dataY = dataY + 1;
		else
			dataY = 1;
	end
	
	if (data < 122)
		data = data + 1;
	else
		data = 65;
end

always @(dCLK) enter = dCLK;

endmodule
