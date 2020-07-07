`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/07 23:58:49
// Design Name: 
// Module Name: MyCPU
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


module MyCPU(
    input clk,
    input rst
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

    AXIInterface axiInterface(.*);
endmodule
