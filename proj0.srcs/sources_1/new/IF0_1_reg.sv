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

    Ctrl.slave          ctrl_if0_1_reg,
    
    IF0_Regs.regs       if0_regs,

    Regs_IF1.regs       regs_if1,
    Regs_NLP.regs       regs_nlp,
    Regs_BPD.regs       regs_bpd,
    Regs_ICache.regs    regs_ICache
);

    assign if0_regs.PC = regs_if1.PC;
    assign ctrl_if0_1_reg.pauseReq = `FALSE;

    always_ff @ (posedge clk) begin
        if(rst || ctrl_if0_1_reg.flush) begin
            regs_if1.PC             <=  32'h0;
            if0_regs.thisHeadIsDS   <=  `FALSE;
        end else if(ctrl_if0_1_reg.pause) begin
            regs_if1.PC             <=  regs_if1.PC;
            if0_regs.thisHeadIsDS   <=  if0_regs.thisHeadIsDS;
            if0_regs.dsTarget       <=  if0_regs.dsTarget;
        end else begin
            regs_if1.PC             <=  if0_regs.nPC;
            if0_regs.thisHeadIsDS   <=  if0_regs.nextHeadIdDS;
            if0_regs.dsTarget       <=  if0_regs.nextDSTarget;
        end
    end

endmodule
