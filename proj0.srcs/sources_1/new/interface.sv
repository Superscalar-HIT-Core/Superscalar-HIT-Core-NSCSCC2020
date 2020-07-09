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
endinterface //InstReq

interface InstResp;
    logic        valid;
    logic        ready;

    logic[127:0] cacheLine;

    modport axi(output valid, cacheLine, input ready);
    modport iCache(input valid, cacheLine, output ready);
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
endinterface //DataReq

interface DataResp;
    logic        valid;
    logic        ready;

    logic[31:0] data;

    modport axi(output valid, data, input ready);
    modport lsu(input valid, data, output ready);
endinterface //DataResp

// package defs;
//     typedef enum logic {False, True} bool;
// endpackage
