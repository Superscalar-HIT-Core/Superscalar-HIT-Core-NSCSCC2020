`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/11 21:37:15
// Design Name: 
// Module Name: Predecoder
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

module Predecoder(
    input   logic [31:0]    pc,
    input   logic [31:0]    inst,
    input   logic           valid,
    output  logic           isJ,
    output  logic           isBr,
    output  logic           jr,
    output  logic [31:0]    target
);

    always_comb begin
        if(valid) begin
            priority casex (inst)
                // quick redirect
                32'b000010??_????????_????????_????????,        // J
                32'b000011??_????????_????????_????????: begin  // JAL
                    isJ     = `TRUE;    // must redirect
                    isBr    = `FALSE;
                    jr      = `TRUE;
                    target  = {pc[31:28], inst[25:0], 2'b00};
                end
                32'b00010000_00000000_????????_????????,        // B
                32'b00000100_00010001_????????_????????: begin  // BAL
                    isJ     = `TRUE;    // must redirect, with different address
                    isBr    = `FALSE;
                    jr      = `TRUE;
                    target  = pc + {{14{inst[15]}}, inst[15:0] << 2};
                end
                // backend-redirect, predecode for wrong target or checking NLP/BPD false postive(br/normal mispredict)
                32'b000100??_????????_????????_????????,        // BEQ
                32'b000001??_???00001_????????_????????,        // BGEZ
                32'b000001??_???10001_????????_????????,        // BGEZAL
                32'b000111??_???00000_????????_????????,        // BGTZ
                32'b000110??_???00000_????????_????????,        // BLEZ
                32'b000001??_???00000_????????_????????,        // BLTZ
                32'b000001??_???10000_????????_????????: begin  // BLTZAL
                    isJ     = `FALSE;  // redirect unknown;
                    isBr    = `TRUE;
                    target  = pc + {{14{inst[15]}}, inst[15:0] << 2};
                end
             // 32'b000000??_???00000_00000???_??001000,        // JR
                32'b000000??_???00000_????????_??001001: begin  // JALR
                    isJ     = `TRUE;
                    isBr    = `FALSE;
                    jr      = `TRUE;    // must redirect, unless unknown target info
                end
                default: begin
                    isJ     = `FALSE;
                    isBr    = `FALSE;
                    jr      = `FALSE;   // don't redirect on normal instrutions
                end
            endcase
        end
    end

endmodule
