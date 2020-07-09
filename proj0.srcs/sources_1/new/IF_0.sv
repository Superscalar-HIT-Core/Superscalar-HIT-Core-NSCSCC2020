`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/09 18:41:29
// Design Name: 
// Module Name: IF_0
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

module IF_0(
    IF0_Regs.if0            if0_regs,
    NLP_IF0.if0             nlp_if0,
    IF3Redirect.if0         if3_0,
    BackendRedirect.if0     backend_if0
);

    assign if0_regs.inst0.pc = if0_regs.PC;
    assign if0_regs.inst1.pc = if0_regs.PC | 32'h0000_0004;

    assign if0_regs.inst0.valid = ~if0_regs.PC[2];
    assign if0_regs.inst1.valid = `TRUE;

    assign if0_regs.inst0.nlpInfo0 = nlp_if0.nlpInfo0;
    assign if0_regs.inst0.nlpInfo1 = nlp_if0.nlpInfo1;

    always_comb begin
        if(backend_if0.redirect) begin
            if0_regs.nPC           =   backend_if0.redirectPC;
            if0_regs.nextHeadIsDS  =   `FALSE;
        end else if(if3_0.redirect) begin
            if0_regs.nPC           =   if3_0.redirectPC;
            if0_regs.nextHeadIsDS  =   `FALSE;
        end else if(if0_regs.thisHeadIsDS) begin
            if0_regs.nPC           =   if0_regs.dsTarget;
            if0_regs.nextHeadIsDS  =   `FALSE;
        end else if(nlp_if0.nlpInfo0.valid && nlp_if0.nlpInfo0.taken) begin
            if0_regs.nPC           =   nlp.if0.nlpInfo0.target;
            if0_regs.nextHeadIsDS  =   `FALSE;
        end else if(nlp_if0.nlpInfo1.valid && nlp_if0.nlpInfo1.taken) begin
            if0_regs.nPC           =   nlp.if0.nlpInfo1.target;
            if0_regs.nextHeadIsDS  =   `TRUE;
        end else begin
            if0_regs.nPC           =   (if0_regs.PC & 32'hFFFF_FFF8) + 32'h0000_0008;
            if0_regs.nextHeadIsDS  =   `FALSE;
        end
    end

endmodule
