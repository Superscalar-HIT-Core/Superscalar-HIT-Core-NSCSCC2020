`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/08 03:42:39
// Design Name: 
// Module Name: AXIWarp
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


module AXIWarp(
    input clk,
    input rst,

    AXIReadAddr.slave  axiReadAddr,
    AXIReadData.slave  axiReadData,
    AXIWriteAddr.slave axiWriteAddr,
    AXIWriteData.slave axiWriteData,
    AXIWriteResp.slave axiWriteResp,

    output wire rsta_busy    ,      // dont care
    output wire rstb_busy    ,      // dont care
    output wire s_aclk       ,
    output wire s_aresetn    ,

    output wire s_axi_awid   ,
    output wire s_axi_awaddr ,
    output wire s_axi_awlen  ,
    output wire s_axi_awsize ,
    output wire s_axi_awburst,
    output wire s_axi_awvalid,
    output wire s_axi_awready,

    output wire s_axi_wdata  ,
    output wire s_axi_wstrb  ,
    output wire s_axi_wlast  ,
    output wire s_axi_wvalid ,
    output wire s_axi_wready ,

    output wire s_axi_bid    ,
    output wire s_axi_bresp  ,
    output wire s_axi_bvalid ,
    output wire s_axi_bready ,

    output wire s_axi_arid   ,
    output wire s_axi_araddr ,
    output wire s_axi_arlen  ,
    output wire s_axi_arsize ,
    output wire s_axi_arburst,
    output wire s_axi_arvalid,
    output wire s_axi_arready,

    output wire s_axi_rid    ,
    output wire s_axi_rdata  ,
    output wire s_axi_rresp  ,
    output wire s_axi_rlast  ,
    output wire s_axi_rvalid ,
    output wire s_axi_rready 
    );

    assign s_aclk           = clk;
    assign s_aresetn        = ~rst;

    assign s_axi_awid       = axiWriteAddr.id;
    assign s_axi_awaddr     = axiWriteAddr.address;
    assign s_axi_awlen      = axiWriteAddr.length;
    assign s_axi_awsize     = axiWriteAddr.size;
    assign s_axi_awburst    = axiWriteAddr.burst;
    assign s_axi_awvalid    = axiWriteAddr.valid;
    assign s_axi_awready    = axiWriteAddr.ready;

    assign s_axi_wdata      = axiWriteData.data;
    assign s_axi_wstrb      = axiWriteData.strobe;
    assign s_axi_wlast      = axiWriteData.last;
    assign s_axi_wvalid     = axiWriteData.valid;
    assign s_axi_wready     = axiWriteData.ready;

    assign s_axi_bid        = axiWriteResp.id;
    assign s_axi_bresp      = axiWriteResp.respond;
    assign s_axi_bvalid     = axiWriteResp.valid;
    assign s_axi_bready     = axiWriteResp.ready;

    assign s_axi_arid       = axiReadAddr.id;
    assign s_axi_araddr     = axiReadAddr.address;
    assign s_axi_arlen      = axiReadAddr.length;
    assign s_axi_arsize     = axiReadAddr.size;
    assign s_axi_arburst    = axiReadAddr.burst;
    assign s_axi_arvalid    = axiReadAddr.valid;
    assign s_axi_arready    = axiReadAddr.ready;

    assign s_axi_rid        = axiReadData.id;
    assign s_axi_rdata      = axiReadData.data;
    assign s_axi_rresp      = axiReadData.respond;
    assign s_axi_rlast      = axiReadData.last;
    assign s_axi_rvalid     = axiReadData.valid;
    assign s_axi_rready     = axiReadData.ready;

endmodule
