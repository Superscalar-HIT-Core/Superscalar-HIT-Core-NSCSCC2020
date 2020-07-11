`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/09 20:03:34
// Design Name: 
// Module Name: IF2_3_reg
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
`include "defs.sv"

module IF2_3_reg(
    input wire          clk,
    input wire          rst,

    Ctrl.slave          ctrl_if2_3_regs,

    ICache_Regs.regs    iCache_regs,
    Regs_IF3.regs       regs_if3
);

    always_ff @ (posedge clk) begin
        if(ctrl_if2_3_regs.flush || rst) begin
            regs_if3.inst0.valid    <= regs_if3.rescueDS;
            regs_if3.inst1.valid    <= `FALSE;
        end else if(ctrl_if2_3_regs.pause) begin
            regs_if3.inst0          <= regs_if3.inst0;
            regs_if3.inst1          <= regs_if3.inst1;
        end else begin
            regs_if3.inst0          <= iCache_regs.inst0;
            regs_if3.inst1          <= iCache_regs.inst1;
        end
    end
endmodule
