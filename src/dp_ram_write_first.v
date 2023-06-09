`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.05.2023 07:11:20
// Design Name: 
// Module Name: dp_bram
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module dp_bram_write_first
#(
    parameter DEPTH = 2000,
    parameter WIDTH = 8
)(
    input clk, we_a,
    input [10:0] addr_a, addr_b,
    input [WIDTH-1:0] din_a, 
    output [WIDTH-1:0] dout_b
);
    
reg [WIDTH-1:0] memory[DEPTH-1:0];
reg [WIDTH-1:0] dout_reg_b;

integer i;
initial begin
  for (i=0;i<DEPTH;i=i+1)
    memory[i] = 0;
end

// Read first 
always @ (posedge clk)
begin
    if (we_a)
        memory[addr_a] = din_a;
    dout_reg_b <= memory[addr_b];
end
        

assign dout_b = dout_reg_b;

endmodule
