`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/09 18:41:29
// Design Name: 
// Module Name: IF_3
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

module IF_3(
    Regs_IF3.if3            regs_if3,
    BPD_IF3.if3             bpd_if3,

    IF3_Regs.if3            if3_regs,
    IF3Redirect.if3         if3_0,
    NLPUpdate.if3           if3_nlp,
    Ctrl.slave              ctrl_if3    // only care aboud flushReq
);
    typedef enum { sCorrect, sFalsePos, sFalseNeg, sWrongTarget } BranchPredictState;

    logic       inst0Jr;
    logic       inst1Jr;

    logic       inst0NLPTaken;
    logic       inst1NLPTaken;

    InstBundle  inst0;
    InstBundle  inst1;

    BranchPredictState inst0State, inst1State;

    Predecoder pre0(
        .pc     (regs_if3.inst0.pc      ),
        .inst   (regs_if3.inst0.inst    ),
        .valid  (regs_if3.inst0.valid   ),
        .isJ    (regs_if3.inst0.isJ     ),
        .isBr   (regs_if3.inst0.isBr    ),
        .target (regs_if3.inst0.target  ),
        .jr     (inst0Jr                )
    );

    Predecoder pre1(
        .pc     (regs_if3.inst1.pc      ),
        .inst   (regs_if3.inst1.inst    ),
        .valid  (regs_if3.inst1.valid   ),
        .isJ    (regs_if3.inst1.isJ     ),
        .isBr   (regs_if3.inst1.isBr    ),
        .target (regs_if3.inst1.target  ),
        .jr     (inst1Jr                )
    );

    assign inst0 = if3_regs.inst0;
    assign inst1 = if3_regs.inst1;

    assign inst0NLPTaken = (inst0.nlpInfo.valid && inst0.nlpInfo.taken) ? `TRUE : `FALSE;   // eliminate X state
    assign inst1NLPTaken = (inst1.nlpInfo.valid && inst1.nlpInfo.taken) ? `TRUE : `FALSE;

    assign ctrl_if3.flushReq = inst0State != sCorrect || inst1State != sCorrect;

    always_comb begin
        if3_regs.inst0.pc       = regs_if3.inst0.pc;
        if3_regs.inst0.inst     = regs_if3.inst0.inst;
        if3_regs.inst0.valid    = regs_if3.inst0.valid;
        if3_regs.inst0.nlpInfo  = regs_if3.inst0.nlpInfo;
        if3_regs.inst0.bpdInfo  = bpd_if3.bpdInfo0;
        
        if3_regs.inst1.pc       = regs_if3.inst1.pc;
        if3_regs.inst1.inst     = regs_if3.inst1.inst;
        if3_regs.inst1.valid    = regs_if3.inst1.valid;
        if3_regs.inst1.nlpInfo  = regs_if3.inst1.nlpInfo;
        if3_regs.inst1.bpdInfo  = bpd_if3.bpdInfo1;

        if(!inst0.valid) begin                  // invalid inst
            inst0.taken = `FALSE;
        end else if(inst0.isJ) begin            // unconditional
            inst0.taken = `TRUE;
        end else if(!inst0.isBr) begin          // normal
            inst0.taken = `FALSE;
        end else if(inst0.bpdInfo.valid) begin  // predict by bpd
            inst0.taken = inst0.bpdInfo.taken;
        end else if(inst0.nlpInfo.valid) begin  // predict by nlp
            inst0.taken = inst0.nlpInfo.taken;
        end else begin                          // both miss
            inst0.taken = `FALSE;
        end

        if(!inst1.valid) begin                  // invalid inst
            inst1.taken = `FALSE;
        end else if(inst1.isJ) begin            // unconditional
            inst1.taken = `TRUE;
        end else if(!inst1.isBr) begin          // normal
            inst1.taken = `FALSE;
        end else if(inst1.bpdInfo.valid) begin  // predict by bpd
            inst1.taken = inst1.bpdInfo.taken;
        end else if(inst1.nlpInfo.valid) begin  // predict by nlp
            inst1.taken = inst1.nlpInfo.taken;
        end else begin                          // both miss
            inst1.taken = `FALSE;
        end

        if((!inst0.nlpInfo.valid && !inst0.bpdInfo.valid) || (!inst0.isJ && !inst0.isBr)) begin
            inst0State = sCorrect;
        end else if(inst0.taken && inst0NLPTaken && (inst0Jr || inst0.nlpInfo.target == inst0.target)) begin
            inst0State = sCorrect;
        end else if(inst0.taken && inst0NLPTaken) begin
            inst0State = sWrongTarget;
        end else if(!inst0.taken && !inst0NLPTaken) begin
            inst0State = sCorrect;
        end else if(inst0NLPTaken) begin
            inst0State = sFalsePos;
        end else begin
            inst0State = sFalseNeg;
        end

        if((!inst1.nlpInfo.valid && !inst1.bpdInfo.valid) || (!inst1.isJ && !inst1.isBr)) begin
            inst1State = sCorrect;
        end else if(inst1.taken && inst1NLPTaken && (inst1Jr || inst1.nlpInfo.target == inst1.target)) begin
            inst1State = sCorrect;
        end else if(inst1.taken && inst1NLPTaken) begin
            inst1State = sWrongTarget;
        end else if(!inst1.taken && !inst1NLPTaken) begin
            inst1State = sCorrect;
        end else if(inst1NLPTaken) begin
            inst1State = sFalsePos;
        end else begin
            inst1State = sFalseNeg;
        end
        
        if(inst0State != sCorrect) begin
            case(inst0State)
                sFalsePos: begin
                    if3_0.redirect      = `TRUE;
                    if3_0.redirectPC    = inst0.pc + 32'h8;
                end
                sFalseNeg: begin
                    if(inst0Jr && !inst0.nlpInfo.valid) begin
                        if3_0.redirect      = `FALSE;
                    end else if(inst0Jr) begin
                        if3_0.redirect      = `TRUE;
                        if3_0.redirectPC    = inst0.nlpInfo.target;
                    end else begin
                        if3_0.redirect      = `TRUE;
                        if3_0.redirectPC    = inst0.target;
                    end
                end
                sWrongTarget: begin
                    if3_0.redirect      = `TRUE;
                    if3_0.redirectPC    = inst0.target;
                end
            endcase
            regs_if3.rescueDS = `FALSE;
        end else if(inst1State != sCorrect) begin
            case(inst1State)
                sFalsePos: begin
                    if3_0.redirect      = `TRUE;
                    if3_0.redirectPC    = inst1.pc + 32'h8;
                    regs_if3.rescueDS   = `TRUE;
                end
                sFalseNeg: begin
                    if(inst1Jr && !inst1.nlpInfo.valid) begin
                        if3_0.redirect      = `FALSE;
                        regs_if3.rescueDS   = `FALSE;
                    end else if(inst1Jr) begin
                        if3_0.redirect      = `TRUE;    // probably not gonna happen
                        if3_0.redirectPC    = inst1.nlpInfo.target;
                        regs_if3.rescueDS   = `TRUE;
                    end else begin
                        if3_0.redirect      = `TRUE;
                        if3_0.redirectPC    = inst1.target;
                        regs_if3.rescueDS   = `TRUE;
                    end
                end
                sWrongTarget: begin
                    if3_0.redirect      = `TRUE;
                    if3_0.redirectPC    = inst1.target;
                    regs_if3.rescueDS   = `TRUE;
                end
            endcase
        end else begin
            if3_0.redirect      = `FALSE;
            regs_if3.rescueDS   = `FALSE;
        end

        case(inst0State)
            sCorrect: begin
                if(
                    inst0.nlpInfo.valid &&
                    !inst0.nlpInfo.taken &&
                    !inst0.taken &&
                    !(inst0.nlpInfo.target == inst0.target)
                ) begin
                    if3_nlp.update0.valid       = `TRUE;
                    if3_nlp.update0.target      = inst0.target;
                    if3_nlp.update0.shouldTake  = `TRUE;
                    if3_nlp.update0.bimState    = inst0.nlpInfo.bimState;
                end else begin
                    if3_nlp.update0.valid   = `FALSE;
                end
            end
            sFalsePos: begin
                if3_nlp.update0.valid       = `TRUE;
                if3_nlp.update0.target      = inst0Jr ? inst0.nlpInfo.target : inst0.target;
                if3_nlp.update0.shouldTake  = `FALSE;
                if3_nlp.update0.bimState    = inst0.nlpInfo.bimState;
            end
            sFalseNeg: begin
                if(!inst0.nlpInfo.valid && inst0Jr) begin
                    if3_nlp.update0.valid       = `FALSE;   // jalr, wait for backend update
                end else if(!inst0.nlpInfo.valid && !inst0Jr) begin
                    if3_nlp.update0.valid       = `TRUE;
                    if3_nlp.update0.target      = inst0.target;
                    if3_nlp.update0.shouldTake  = `TRUE;
                    if3_nlp.update0.bimState    = inst0.isJ ? 2'b11 : inst0.nlpInfo.bimState;
                end else begin
                    if3_nlp.update0.valid       = `TRUE;
                    if3_nlp.update0.target      = inst0Jr ? inst0.nlpInfo.target : inst0.target;
                    if3_nlp.update0.shouldTake  = `TRUE;
                    if3_nlp.update0.bimState    = inst0.isJ ? 2'b11 : inst0.nlpInfo.bimState;
                end
            end
            sWrongTarget: begin
                if3_nlp.update0.valid       = `TRUE;
                if3_nlp.update0.target      = inst0.target;
                if3_nlp.update0.shouldTake  = `TRUE;
                if3_nlp.update0.bimState    = inst0.nlpInfo.bimState;
            end
        endcase

        case(inst1State)
            sCorrect: begin
                if(
                    inst1.nlpInfo.valid &&
                    !inst1.nlpInfo.taken &&
                    !inst1.taken &&
                    !(inst1.nlpInfo.target == inst1.target)
                ) begin
                    if3_nlp.update1.valid       = `TRUE;
                    if3_nlp.update1.target      = inst1.target;
                    if3_nlp.update1.shouldTake  = `TRUE;
                    if3_nlp.update1.bimState    = inst1.nlpInfo.bimState;
                end else begin
                    if3_nlp.update1.valid   = `FALSE;
                end
            end
            sFalsePos: begin
                if3_nlp.update1.valid       = `TRUE;
                if3_nlp.update1.target      = inst1Jr ? inst1.nlpInfo.target : inst1.target;
                if3_nlp.update1.shouldTake  = `FALSE;
                if3_nlp.update1.bimState    = inst1.nlpInfo.bimState;
            end
            sFalseNeg: begin
                if(!inst1.nlpInfo.valid && inst1Jr) begin
                    if3_nlp.update1.valid       = `FALSE;   // jalr, wait for backend update
                end else if(!inst1.nlpInfo.valid && !inst1Jr) begin
                    if3_nlp.update1.valid       = `TRUE;
                    if3_nlp.update1.target      = inst1.target;
                    if3_nlp.update1.shouldTake  = `TRUE;
                    if3_nlp.update1.bimState    = inst1.isJ ? 2'b11 : inst1.nlpInfo.bimState;
                end else begin
                    if3_nlp.update1.valid       = `TRUE;
                    if3_nlp.update1.target      = inst1Jr ? inst1.nlpInfo.target : inst1.target;
                    if3_nlp.update1.shouldTake  = `TRUE;
                    if3_nlp.update1.bimState    = inst1.isJ ? 2'b11 : inst1.nlpInfo.bimState;
                end
            end
            sWrongTarget: begin
                if3_nlp.update1.valid       = `TRUE;
                if3_nlp.update1.target      = inst1.target;
                if3_nlp.update1.shouldTake  = `TRUE;
                if3_nlp.update1.bimState    = inst1.nlpInfo.bimState;
            end
        endcase


    end

endmodule
