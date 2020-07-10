`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/09 20:03:34
// Design Name: 
// Module Name: IF0_1_reg
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

module IF0_1_reg(
    input wire clk,
    input wire rst,

    Ctrl.slave          ctrl_if0_1_regs,
    
    IF0_Regs.regs       if0_regs,

    Regs_IF1.regs       regs_if1,
    Regs_NLP.regs       regs_nlp,
    Regs_BPD.regs       regs_bpd,
    Regs_ICache.regs    regs_iCache
);

    assign if0_regs.PC      = regs_if1.PC;
    assign regs_nlp.PC      = regs_if1.PC;
    assign regs_bpd.PC      = regs_if1.PC;
    assign regs_iCache.PC   = regs_if1.PC;
    assign if0_regs.paused  = ctrl_if0_1_regs.pause;

    assign ctrl_if0_1_regs.pauseReq = `FALSE;

    always_ff @ (posedge clk) begin
        if(rst || ctrl_if0_1_regs.flush) begin
            regs_if1.PC             <=  32'h0;
            if0_regs.thisHeadIsDS   <=  `FALSE;
        end else if(ctrl_if0_1_regs.pause) begin
            regs_if1.PC             <=  regs_if1.PC;
            if0_regs.thisHeadIsDS   <=  if0_regs.thisHeadIsDS;
            if0_regs.dsTarget       <=  if0_regs.dsTarget;
        end else begin
            regs_if1.PC             <=  if0_regs.nPC;
            if0_regs.thisHeadIsDS   <=  if0_regs.nextHeadIsDS;
            if0_regs.dsTarget       <=  if0_regs.nextDSTarget;
        end
    end

endmodule
