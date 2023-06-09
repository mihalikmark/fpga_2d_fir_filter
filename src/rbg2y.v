module rgb2y(
    input                clk,
    
    // Multiplication values
    input  signed [17:0] kr_i,
    input  signed [17:0] kb_i,
    
    input                dv_i,
    input                hs_i,
    input                vs_i,
    input          [7:0] r_i,
    input          [7:0] g_i,
    input          [7:0] b_i,
    
    output               dv_o,
    output               hs_o,
    output               vs_o,
    output         [7:0] y_o
);
integer i;

wire signed [31:0] p[1:0];

// R and B component is only one FF delay
reg [7:0] r[0:0];
reg [7:0] b[0:0];
// G need to be delayed so this need to be 
// 2 FF
reg [7:0] g[1:0];

always @(posedge clk)
begin
    r[0] <= r_i;
    g[0] <= g_i;
    b[0] <= b_i;
    // G need to be shifted
    g[1] <= g[0];
end

//////////////////////////////////////////////////////////
// Calculating Y = Kr * (R - G) + Kb * (B-G) + G
//////////////////////////////////////////////////////////

// First DSP block for Kr * (R - G) + G calculation
dsp #(
    .USE_PCI (0)
)
dsp0(
    .clk     (clk),
    .a       (r_i),
    .d       (g_i),
    .b       (kr_i),
    .c       ({7'b0, g[1], 17'b0}),
    .pci     (0),
    .p       (p[0])
);

// First DSP block for  Kb * (B-G) calculation with the first DSP output
dsp #(
    .USE_PCI (1)
)
dsp1(
    .clk     (clk),
    .a       (b[0]),
    .d       (g[0]),
    .b       (kb_i),
    .c       (0),
    .pci     (p[0]),
    .p       (p[1])
);

reg [7:0] y_reg;
always @(posedge clk)
// Saturation logic if the value is negative so the MSb is 1
// set the output 0
if (p[1][31])
    y_reg <= 8'b0;
else
    y_reg <= p[1][24:17];

// Y value output for the module
assign y_o = y_reg;


reg [2:0] cntrl_dl[5:0];
// Assign controls 
always @ (posedge clk)
for (i=0; i<6; i=i+1)
    cntrl_dl[i] <= (i==0) ? {dv_i, hs_i, vs_i} : cntrl_dl[i-1];

// Output enable if ff stage is 6 (dsp finished with calc.)
assign dv_o = cntrl_dl[5][2];
assign hs_o = cntrl_dl[5][1];
assign vs_o = cntrl_dl[5][0];

endmodule
