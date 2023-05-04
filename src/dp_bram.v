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
module dp_bram 
#(
    parameter DEPTH = 1
)(
    input clk, we_a, we_b,
    input [10:0] addr_a, addr_b,
    input [ 7:0] din_a, din_b, 
    output [7:0] dout_a, dout_b
);
    
reg [7:0] memory[DEPTH:0];
reg [7:0] dout_reg_a, dout_reg_b;
    
always @ (posedge clk)
begin
    if (we_a)
        memory[addr_a] <= din_a;
    dout_reg_a <= memory[addr_a];
end
        
        
always @ (posedge clk)
begin
    if (we_b)
        memory[addr_b] <= din_b;
    dout_reg_b <= memory[addr_b];
end
    
assign dout_a = dout_reg_a;
assign dout_b = dout_reg_b;

endmodule