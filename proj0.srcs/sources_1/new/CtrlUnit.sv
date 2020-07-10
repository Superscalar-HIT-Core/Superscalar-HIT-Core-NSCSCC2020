`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/11 01:06:04
// Design Name: 
// Module Name: CtrlUnit
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

module CtrlUnit(
    Ctrl.master     ctrl_if0_1_regs,
    Ctrl.master     ctrl_iCache
);

    always_comb begin
        if(ctrl_iCache.pauseReq) begin
            ctrl_if0_1_regs.pause = `TRUE;
        end else begin
            ctrl_if0_1_regs.pause = `FALSE;
        end
    end

endmodule
