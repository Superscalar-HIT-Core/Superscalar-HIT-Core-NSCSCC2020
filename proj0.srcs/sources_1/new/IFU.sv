`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/09 18:41:29
// Design Name: 
// Module Name: IFU
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

module IFU(
    input wire clk,
    input wire rst,

    InstReq     instReq,
    InstResp    instResp,

    ICache_TLB  iCache_tlb,

    Ctrl        ctrl_if0_1_regs,
    Ctrl        ctrl_if1_2_regs,
    Ctrl        ctrl_if2_3_regs,
    Ctrl        ctrl_iCache,

    BackendRedirect     backend_if0
);
    
    NLP_IF0             nlp_if0;
    IF3Redirect         if3_0;
    IF0_Regs            if0_regs;

    Regs_IF1            regs_if1;
    Regs_NLP            regs_nlp;
    Regs_BPD            regs_bpd;
    Regs_ICache         regs_iCache;
    
    IF_0        if0(.*);
    IF0_1_reg   if01reg(.*);
    ICache      iCache(.*);
    
endmodule