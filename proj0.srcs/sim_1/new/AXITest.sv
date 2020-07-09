`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/08 02:24:04
// Design Name: 
// Module Name: AXITestbench
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


module AXITest(

    );

    AXIReadAddr     axiReadAddr();
    AXIReadData     axiReadData();
    AXIWriteAddr    axiWriteAddr();
    AXIWriteData    axiWriteData();
    AXIWriteResp    axiWriteResp();
    InstReq         instReq();
    InstResp        instResp();
    DataReq         dataReq();
    DataResp        dataResp();

    wire rsta_busy      ;
    wire rstb_busy      ;
    wire s_aclk         ;
    wire s_aresetn      ;
    wire s_axi_awid     ;
    wire s_axi_awaddr   ;
    wire s_axi_awlen    ;
    wire s_axi_awsize   ;
    wire s_axi_awburst  ;
    wire s_axi_awvalid  ;
    wire s_axi_awready  ;
    wire s_axi_wdata    ;
    wire s_axi_wstrb    ;
    wire s_axi_wlast    ;
    wire s_axi_wvalid   ;
    wire s_axi_wready   ;
    wire s_axi_bid      ;
    wire s_axi_bresp    ;
    wire s_axi_bvalid   ;
    wire s_axi_bready   ;
    wire s_axi_arid     ;
    wire s_axi_araddr   ;
    wire s_axi_arlen    ;
    wire s_axi_arsize   ;
    wire s_axi_arburst  ;
    wire s_axi_arvalid  ;
    wire s_axi_arready  ;
    wire s_axi_rid      ;
    wire s_axi_rdata    ;
    wire s_axi_rresp    ;
    wire s_axi_rlast    ;
    wire s_axi_rvalid   ;
    wire s_axi_rready   ;

    AXIInterface axiInterface(.*);
    axi_test_blk_mem axi_mem(.*);

    

    // axi_test_blk_mem axi_mem (
    //     .rsta_busy(rsta_busy),          // output wire rsta_busy
    //     .rstb_busy(rstb_busy),          // output wire rstb_busy
    //     .s_aclk(s_aclk),                // input wire s_aclk
    //     .s_aresetn(s_aresetn),          // input wire s_aresetn
    //     .s_axi_awid(s_axi_awid),        // input wire [3 : 0] s_axi_awid
    //     .s_axi_awaddr(s_axi_awaddr),    // input wire [31 : 0] s_axi_awaddr
    //     .s_axi_awlen(s_axi_awlen),      // input wire [7 : 0] s_axi_awlen
    //     .s_axi_awsize(s_axi_awsize),    // input wire [2 : 0] s_axi_awsize
    //     .s_axi_awburst(s_axi_awburst),  // input wire [1 : 0] s_axi_awburst
    //     .s_axi_awvalid(s_axi_awvalid),  // input wire s_axi_awvalid
    //     .s_axi_awready(s_axi_awready),  // output wire s_axi_awready
    //     .s_axi_wdata(s_axi_wdata),      // input wire [31 : 0] s_axi_wdata
    //     .s_axi_wstrb(s_axi_wstrb),      // input wire [3 : 0] s_axi_wstrb
    //     .s_axi_wlast(s_axi_wlast),      // input wire s_axi_wlast
    //     .s_axi_wvalid(s_axi_wvalid),    // input wire s_axi_wvalid
    //     .s_axi_wready(s_axi_wready),    // output wire s_axi_wready
    //     .s_axi_bid(s_axi_bid),          // output wire [3 : 0] s_axi_bid
    //     .s_axi_bresp(s_axi_bresp),      // output wire [1 : 0] s_axi_bresp
    //     .s_axi_bvalid(s_axi_bvalid),    // output wire s_axi_bvalid
    //     .s_axi_bready(s_axi_bready),    // input wire s_axi_bready
    //     .s_axi_arid(s_axi_arid),        // input wire [3 : 0] s_axi_arid
    //     .s_axi_araddr(s_axi_araddr),    // input wire [31 : 0] s_axi_araddr
    //     .s_axi_arlen(s_axi_arlen),      // input wire [7 : 0] s_axi_arlen
    //     .s_axi_arsize(s_axi_arsize),    // input wire [2 : 0] s_axi_arsize
    //     .s_axi_arburst(s_axi_arburst),  // input wire [1 : 0] s_axi_arburst
    //     .s_axi_arvalid(s_axi_arvalid),  // input wire s_axi_arvalid
    //     .s_axi_arready(s_axi_arready),  // output wire s_axi_arready
    //     .s_axi_rid(s_axi_rid),          // output wire [3 : 0] s_axi_rid
    //     .s_axi_rdata(s_axi_rdata),      // output wire [31 : 0] s_axi_rdata
    //     .s_axi_rresp(s_axi_rresp),      // output wire [1 : 0] s_axi_rresp
    //     .s_axi_rlast(s_axi_rlast),      // output wire s_axi_rlast
    //     .s_axi_rvalid(s_axi_rvalid),    // output wire s_axi_rvalid
    //     .s_axi_rready(s_axi_rready)    // input wire s_axi_rready
    // );
endmodule
