`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/07 23:19:31
// Design Name: 
// Module Name: interface
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

interface AXIReadAddr;
    logic        valid;
    logic        ready;

    logic [ 3:0] id;
    logic [31:0] address;
    logic [ 3:0] length;
    logic [ 2:0] size;
    logic [ 1:0] burst;
    logic [ 1:0] lock;
    logic [ 3:0] cache;
    logic [ 2:0] protect;

    modport master(output valid, id, address, length, size, burst, lock, cache, protect, input ready);
    modport slave(input valid, id, address, length, size, burst, lock, cache, protect, output ready);
endinterface : AXIReadAddr //AXIReadAddr

interface AXIReadData;
    logic        valid;
    logic        ready;

    logic [ 3:0] id;
    logic [31:0] data;
    logic [ 1:0] respond;
    logic        last;
    modport master(output ready, input valid, id, data, respond, last);
    modport slave(input ready, output valid, id, data, respond, last);
endinterface //AXIReadData

interface AXIWriteAddr;
    logic        valid;
    logic        ready;

    logic [ 3:0] id;
    logic [31:0] address;
    logic [ 3:0] length;
    logic [ 2:0] size;
    logic [ 1:0] burst;
    logic [ 1:0] lock;
    logic [ 3:0] cache;
    logic [ 2:0] protect;

    modport master(output valid, id, address, length, size, burst, lock, cache, protect, input ready);
    modport slave(input valid, id, address, length, size, burst, lock, cache, protect, output ready);
endinterface //AXIWriteAddr

interface AXIWriteData;
    logic        valid;
    logic        ready;

    logic [ 3:0] id;
    logic [31:0] data;
    logic [ 3:0] strobe;
    logic        last;

    modport master(output valid, id, data, strobe, last, input ready);
    modport slave(input valid, id, data, strobe, last, output ready);
endinterface //AXIWriteData

interface AXIWriteResp;
    logic        valid;
    logic        ready;

    logic [ 3:0] id;
    logic [ 1:0] respond;

    modport master(output ready, input valid, id, respond);
    modport slave(input ready, output valid, id, respond);
endinterface //AXIWriteResp

interface InstReq;
    logic        valid;
    logic        ready;

    logic [31:0] pc;

    modport axi(output ready, input valid, pc);
    modport iCache(input ready, output valid, pc);

    task automatic sendReq(logic [31:0]  addr, logic clk);
        valid   = `TRUE;
        pc      = addr;
        while(!ready) ;
        @(posedge clk) valid = `FALSE;
    endtask //automatic

endinterface //InstReq

interface InstResp;
    logic        valid;
    logic        ready;

    logic[127:0] cacheLine;

    modport axi(output valid, cacheLine, input ready);
    modport iCache(input valid, cacheLine, output ready);

    task automatic recvResp(logic clk);
        ready   =   `TRUE;
        while (!valid) ;
        @(posedge clk) ready   =   `FALSE;
    endtask //automatic

endinterface //InstResp

interface DataReq;
    logic        valid;
    logic        ready;

    logic [31:0] addr;
    logic        write_en;
    logic [31:0] data;
    logic [ 3:0] strobe;

    modport axi(output ready, input valid, addr, write_en, data, strobe);
    modport lsu(input ready, output valid, addr, write_en, data, strobe);

    task automatic sendWReq(logic [31:0] ad, logic [31:0] dat, logic clk);
        valid       =   `TRUE;
        addr        =   ad;
        write_en    =   `TRUE;
        strobe      =   4'b1111;
        while (!ready) ;
        @(posedge clk) valid   =   `FALSE;
    endtask //automatic

endinterface //DataReq

interface DataResp;
    logic        valid;
    logic        ready;

    logic[31:0]  data;

    modport axi(output valid, data, input ready);
    modport lsu(input valid, data, output ready);
endinterface //DataResp

interface IF0_Regs;
    logic           nPC;
    logic           PC;
    
    logic           nextHeadIsDS;
    logic   [31:0]  nextDSTarget;
    logic           thisHeadIsDS;
    logic   [31:0]  dsTarget;

    modport if0(input PC, thisHeadIsDS, dsTarget, output nPC, nextDSTarget, nextHeadIsDS);
    modport regs(output PC, input nPC);
endinterface //IF0_1

interface Regs_IF1;
    logic       PC;

    modport regs(output PC);
    modport if1(input PC);
endinterface //Reg_IF1

interface Regs_NLP;
    logic       PC;

    modport regs(output PC);
    modport nlp(input PC);
endinterface //Regs_NLP

interface Regs_BPD;
    logic       PC;

    modport regs(output PC);
    modport bpd(input PC);
endinterface //Regs_BPD

interface Regs_ICache;
    logic       PC;

    modport regs(output PC);
    modport iCache(input PC);
endinterface //Regs_ICache

interface ICache_TLB;
    logic       PC;

    modport regs(output PC);
    modport bpd(input PC);
endinterface //Regs_BPD

interface IF1_Regs;
    InstBundle  inst0;
    InstBundle  inst1;
endinterface //IF1_Regs

interface NLP_IF0;
    NLPPredInfo nlpInfo0;
    NLPPredInfo nlpInfo1;

    modport if0(input nlpInfo0, nlpInfo1);
    modport nlp(output nlpInfo0, nlpInfo1);
endinterface //IF0_NLP

interface IF3Redirect;
    logic           redirect;
    logic   [31:0]  redirectPC;

    modport if0(input redirect, redirectPC);
    modport if3(output redirect, redirectPC);
endinterface //IF3_0

interface BackendRedirect;
    logic           redirect;
    logic   [31:0]  redirectPC;

    modport if0(input redirect, redirectPC);
    modport backend(output redirect, redirectPC);
endinterface //BackendRedirect

interface Ctrl;
    logic           pauseReq;
    logic           pause;
    logic           flush;

    modport master(input pauseReq, output pause, flush);
    modport slave (output pauseReq, input pause, flush);
endinterface //Ctrl

typedef struct packed {
    logic   [31:0]  target;
    logic   [1:0]   bimState;
    logic           taken;
    logic           valid;
} NLPPredInfo;

typedef struct packed {
    logic   [31:0]  target;
    logic           taken;
    logic           valid;
} BPDPredInfo;

typedef struct packed {
    logic   [31:0]  inst;
    logic   [31:0]  pc;
    logic           isBr;
    logic           isDs;
    logic           isJ;
    logic   [31:0]  targetAddr;
    logic           valid;
    NLPPredInfo     nlpInfo;
    BPDPredInfo     bpdInfo;
} InstBundle;

// package defs;
//     typedef enum logic {False, True} bool;
// endpackage
