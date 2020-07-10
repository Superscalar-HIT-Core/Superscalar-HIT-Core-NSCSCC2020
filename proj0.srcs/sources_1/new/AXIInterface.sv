`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/07 19:53:33
// Design Name: 
// Module Name: AXIInterface
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

module AXIInterface(
    input clk,
    input rst,

    AXIReadAddr.master  axiReadAddr,
    AXIReadData.master  axiReadData,
    AXIWriteAddr.master axiWriteAddr,
    AXIWriteData.master axiWriteData,
    AXIWriteResp.master axiWriteResp,

    InstReq.axi         instReq,
    InstResp.axi        instResp,
    DataReq.axi         dataReq,
    DataResp.axi        dataResp
);

    typedef enum  { sRAddr, sRInst, sRData, sRRst } AXIRState;
    typedef enum  { sWAddr, sWData, sWResp, sWRst } AXIWState;

    AXIRState   rState, nextRState;
    AXIWState   wState, nextWState;
    
    logic           instReqBusy;
    logic [31:0]    instReqPC;

    logic           dataReqBusy;
    logic [31:0]    dataReqAddr;
    logic [31:0]    dataReqData;
    logic           dataReqWEn;
    logic [3:0]     dataReqStrobe;

    logic           dReadReady;
    logic [31:0]    dReadRes;

    logic           iReadReady;
    logic [127:0]   iReadRes;

    logic [1:0]     instRespCounter;

    logic           lastInstBusy;
    logic           lastDataBusy;

    assign axiReadAddr.valid  = rState == sRAddr && (instReqBusy || (dataReqBusy && !dataReqWEn));
    assign axiWriteAddr.valid = dataReqBusy && dataReqWEn && wState == sWAddr;

    assign instReq.ready = ~lastInstBusy;
    assign dataReq.ready = ~lastDataBusy;

    assign instResp.valid = iReadReady;
    assign dataResp.valid = dReadReady;

    always_comb begin
        if(rst) begin
            instReqBusy <= `FALSE;
        end else if(instReq.valid && !lastInstBusy) begin
            instReqBusy <= `TRUE;
            instReqPC   <= instReq.pc;
        end else if(rState == sRInst) begin
            instReqBusy <= `FALSE;
        end
    end

    always_comb begin
        if(rst) begin
            dataReqBusy     <= `FALSE;
            dataReqWEn      <= `FALSE;
        end else if(dataReq.valid && !lastDataBusy) begin
            dataReqBusy     <= `TRUE;
            dataReqAddr     <= dataReq.addr;
            dataReqWEn      <= dataReq.write_en;
            dataReqStrobe   <= dataReq.strobe;
            dataReqData     <= dataReq.data;
        end else if (rState == sRData || wState == sWResp) begin
            dataReqBusy     <= `FALSE;
            dataReqWEn      <= `FALSE;
        end
    end

    always_ff @ (posedge clk) begin
        lastInstBusy    <= instReqBusy;
        lastDataBusy    <= dataReqBusy;
    end

    always_comb begin
        unique case(rState)
            sRAddr: begin
                if(rst) begin
                    nextRState = sRRst;
                end else if(axiReadAddr.valid && axiReadAddr.ready) begin
                    if(dataReqBusy && !dataReqWEn) begin
                        nextRState = sRData;
                    end else begin
                        nextRState = sRInst;
                    end
                end else begin
                    nextRState = sRAddr;
                end
            end
            sRData: begin
                if(rst) begin
                    nextRState = sRRst;
                end else if(dReadReady && dataResp.ready) begin
                    nextRState = sRAddr;
                end else begin
                    nextRState = sRData;
                end
            end
            sRInst: begin
                if(rst) begin
                    nextRState = sRRst;
                end else if(iReadReady && instResp.ready) begin
                    nextRState = sRAddr;
                end else begin
                    nextRState = sRInst;
                end
            end
            sRRst: begin
                if(rst) begin
                    nextRState = sRRst;
                end else begin
                    nextRState = sRAddr;
                end
            end
            default: begin
                nextRState = sRRst;
            end
        endcase
    end

    always_comb begin
        unique case(wState)
            sWAddr: begin
                if(rst) begin
                    nextWState = sWRst;
                end else if(axiWriteAddr.valid && axiWriteAddr.ready) begin
                    nextWState = sWData;
                end else begin
                    nextWState = sWAddr;
                end
            end
            sWData: begin
                if(rst) begin
                    nextWState = sWRst;
                end else if(axiWriteData.valid && axiWriteData.ready) begin
                    nextWState = sWResp;
                end else begin
                    nextWState = sWData;
                end
            end
            sWResp: begin
                if(rst) begin
                    nextWState = sWRst;
                end else if(axiWriteResp.valid && axiWriteResp.ready) begin
                    nextWState = sWAddr;
                end else begin
                    nextWState = sWResp;
                end
            end
            sWRst: begin
                if(rst) begin
                    nextWState = sWRst;
                end else begin
                    nextWState = sWAddr;
                end
            end
            default: begin
                nextWState = sWAddr;
            end
        endcase
    end

    always_ff @(posedge clk) begin
        rState <= nextRState;
        wState <= nextWState;
    end

    always_ff @(posedge clk) begin
        if(rst) begin
            instRespCounter <= 0;
        end else if(rState == sRInst) begin
            if(axiReadData.ready && axiReadData.valid) begin
                instRespCounter <= instRespCounter + 1;
            end
        end else begin
            instRespCounter <= 0;
        end
    end

    always_comb begin
        unique case(rState)
            sRAddr: begin
                if(dataReqBusy && !dataReqWEn) begin
                    axiReadAddr.id      = 4'h1;
                    axiReadAddr.address = dataReqAddr;
                    axiReadAddr.length  = 4'b0000;
                    axiReadAddr.size    = 3'b010;
                    axiReadAddr.burst   = 2'b10;
                end else if(instReqBusy) begin
                    axiReadAddr.id      = 4'h0;
                    axiReadAddr.address = instReqPC & 32'hFFFF_FFF0;
                    axiReadAddr.length  = 4'b0011;
                    axiReadAddr.size    = 3'b010;
                    axiReadAddr.burst   = 2'b10;
                end
                
                dReadReady = `FALSE;
                iReadReady = `FALSE;

                axiReadData.ready = `FALSE;
            end
            sRData: begin
                axiReadData.ready = `TRUE;
                if(axiReadData.valid) begin
                    dReadReady = `TRUE;
                    dataResp.data = axiReadData.data;
                end
                iReadReady = `FALSE;
            end
            sRInst: begin
                axiReadData.ready = `TRUE;
                if(axiReadData.valid) begin
                    unique case(instRespCounter)
                        2'b00: iReadRes[ 31: 0] = axiReadData.data;
                        2'b01: iReadRes[ 63:32] = axiReadData.data;
                        2'b10: iReadRes[ 95:64] = axiReadData.data;
                        2'b11: iReadRes[127:96] = axiReadData.data;
                    endcase
                end
                if(axiReadData.last) begin
                    iReadReady = `TRUE;
                    instResp.cacheLine = iReadRes;
                end
                dReadReady = `FALSE;
            end
            sRRst: begin
                axiReadData.ready = `FALSE;
                iReadReady = `FALSE;
                dReadReady = `FALSE;

                axiReadAddr.id      = 4'h0;
                axiReadAddr.address = 32'h00000000;
                axiReadAddr.length  = 4'b0000;
                axiReadAddr.size    = 3'b000;
                axiReadAddr.burst   = 2'b10;
            end
        endcase
    end

    always_comb begin
        unique case(wState)
            sWAddr: begin
                axiWriteAddr.id         = 4'h0;
                axiWriteAddr.address    = dataReqAddr;
                axiWriteAddr.length     = 4'b0000;
                axiWriteAddr.size       = 3'b010;
                axiWriteAddr.burst      = 2'b01;

                axiWriteData.valid      = `FALSE;
            end
            sWData: begin
                axiWriteData.id         = 4'h0;
                axiWriteData.data       = dataReqData;
                axiWriteData.strobe     = dataReqStrobe;
                axiWriteData.valid      = `TRUE;
            end
            sWResp: begin
                axiWriteData.valid      = `FALSE;
                axiWriteResp.ready      = `TRUE;
            end
            sWRst: begin
                axiWriteAddr.id         = 4'h0;
                axiWriteAddr.address    = dataReqAddr;
                axiWriteAddr.length     = 4'b0000;
                axiWriteAddr.size       = 3'b010;
                axiWriteAddr.burst      = 2'b01;

                axiWriteData.valid      = `FALSE;
                axiWriteResp.ready      = `FALSE;
            end
        endcase
    end

endmodule
