// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtb_alu.h for the primary calling header

#include "Vtb_alu__pch.h"

VlCoroutine Vtb_alu___024root___eval_initial__TOP__Vtiming__0(Vtb_alu___024root* vlSelf);

void Vtb_alu___024root___eval_initial(Vtb_alu___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_alu___024root___eval_initial\n"); );
    Vtb_alu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    Vtb_alu___024root___eval_initial__TOP__Vtiming__0(vlSelf);
}

VlCoroutine Vtb_alu___024root___eval_initial__TOP__Vtiming__0(Vtb_alu___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_alu___024root___eval_initial__TOP__Vtiming__0\n"); );
    Vtb_alu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.tb_alu__DOT__a = 0x0000000aU;
    vlSelfRef.tb_alu__DOT__b = 0x00000014U;
    vlSelfRef.tb_alu__DOT__alu_control = 0U;
    co_await vlSelfRef.__VdlySched.delay(0x000000000000000aULL, 
                                         nullptr, "tb\\tb_alu.sv", 
                                         24);
    if ((0x0000001eU == vlSelfRef.tb_alu__DOT__result)) {
        VL_WRITEF_NX("ADD PASS\n",0);
    } else {
        VL_WRITEF_NX("ADD FAIL\n",0);
    }
    vlSelfRef.tb_alu__DOT__a = 0x00000014U;
    vlSelfRef.tb_alu__DOT__b = 0x0000000aU;
    vlSelfRef.tb_alu__DOT__alu_control = 1U;
    co_await vlSelfRef.__VdlySched.delay(0x000000000000000aULL, 
                                         nullptr, "tb\\tb_alu.sv", 
                                         35);
    if ((0x0000000aU == vlSelfRef.tb_alu__DOT__result)) {
        VL_WRITEF_NX("SUB PASS\n",0);
    } else {
        VL_WRITEF_NX("SUB FAIL\n",0);
    }
    vlSelfRef.tb_alu__DOT__a = 0x0000000aU;
    vlSelfRef.tb_alu__DOT__b = 0x0000000cU;
    vlSelfRef.tb_alu__DOT__alu_control = 2U;
    co_await vlSelfRef.__VdlySched.delay(0x000000000000000aULL, 
                                         nullptr, "tb\\tb_alu.sv", 
                                         46);
    if ((8U == vlSelfRef.tb_alu__DOT__result)) {
        VL_WRITEF_NX("AND PASS\n",0);
    } else {
        VL_WRITEF_NX("AND FAIL\n",0);
    }
    vlSelfRef.tb_alu__DOT__a = 0x0000000aU;
    vlSelfRef.tb_alu__DOT__b = 0x0000000cU;
    vlSelfRef.tb_alu__DOT__alu_control = 3U;
    co_await vlSelfRef.__VdlySched.delay(0x000000000000000aULL, 
                                         nullptr, "tb\\tb_alu.sv", 
                                         57);
    if ((0x0000000eU == vlSelfRef.tb_alu__DOT__result)) {
        VL_WRITEF_NX("OR PASS\n",0);
    } else {
        VL_WRITEF_NX("OR FAIL\n",0);
    }
    vlSelfRef.tb_alu__DOT__a = 0x0000000aU;
    vlSelfRef.tb_alu__DOT__b = 0x0000000cU;
    vlSelfRef.tb_alu__DOT__alu_control = 4U;
    co_await vlSelfRef.__VdlySched.delay(0x000000000000000aULL, 
                                         nullptr, "tb\\tb_alu.sv", 
                                         68);
    if ((6U == vlSelfRef.tb_alu__DOT__result)) {
        VL_WRITEF_NX("XOR PASS\n",0);
    } else {
        VL_WRITEF_NX("XOR FAIL\n",0);
    }
    vlSelfRef.tb_alu__DOT__a = 0x0000000aU;
    vlSelfRef.tb_alu__DOT__b = 0x0000000aU;
    vlSelfRef.tb_alu__DOT__alu_control = 1U;
    co_await vlSelfRef.__VdlySched.delay(0x000000000000000aULL, 
                                         nullptr, "tb\\tb_alu.sv", 
                                         79);
    if ((0U == vlSelfRef.tb_alu__DOT__result)) {
        VL_WRITEF_NX("ZERO FLAG PASS\n",0);
    } else {
        VL_WRITEF_NX("ZERO FLAG FAIL\n",0);
    }
    VL_WRITEF_NX("\n================================\nALL ALU TESTS COMPLETED\n================================\n",0);
    VL_FINISH_MT("tb\\tb_alu.sv", 91, "");
    co_return;
}

bool Vtb_alu___024root___trigger_anySet__act(const VlUnpacked<QData/*63:0*/, 1> &in) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_alu___024root___trigger_anySet__act\n"); );
    // Locals
    IData/*31:0*/ n;
    // Body
    n = 0U;
    do {
        if (in[n]) {
            return (1U);
        }
        n = ((IData)(1U) + n);
    } while ((1U > n));
    return (0U);
}

void Vtb_alu___024root___trigger_orInto__act_vec_vec(VlUnpacked<QData/*63:0*/, 1> &out, const VlUnpacked<QData/*63:0*/, 1> &in) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_alu___024root___trigger_orInto__act_vec_vec\n"); );
    // Locals
    IData/*31:0*/ n;
    // Body
    n = 0U;
    do {
        out[n] = (out[n] | in[n]);
        n = ((IData)(1U) + n);
    } while ((0U >= n));
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtb_alu___024root___dump_triggers__act(const VlUnpacked<QData/*63:0*/, 1> &triggers, const std::string &tag);
#endif  // VL_DEBUG

bool Vtb_alu___024root___eval_phase__act(Vtb_alu___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_alu___024root___eval_phase__act\n"); );
    Vtb_alu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    CData/*0:0*/ __VactExecute;
    // Body
    {
        // Inlined CFunc: _eval_triggers_vec__act
        vlSelfRef.__VactTriggered[0U] = (QData)((IData)(vlSelfRef.__VdlySched.awaitingCurrentTime()));
    }
    Vtb_alu___024root___trigger_orInto__act_vec_vec(vlSelfRef.__VactTriggered, vlSelfRef.__VactTriggeredAcc);
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vtb_alu___024root___dump_triggers__act(vlSelfRef.__VactTriggered, "act"s);
    }
#endif
    Vtb_alu___024root___trigger_orInto__act_vec_vec(vlSelfRef.__VnbaTriggered, vlSelfRef.__VactTriggered);
    __VactExecute = Vtb_alu___024root___trigger_anySet__act(vlSelfRef.__VactTriggered);
    if (__VactExecute) {
        vlSelfRef.__VactTriggeredAcc.fill(0ULL);
        {
            // Inlined CFunc: _timing_resume
            if ((1ULL & vlSelfRef.__VactTriggered[0U])) {
                vlSelfRef.__VdlySched.resume();
            }
        }
        {
            // Inlined CFunc: _eval_act
            if ((1ULL & vlSelfRef.__VactTriggered[0U])) {
                {
                    // Inlined CFunc: _act_sequent__TOP__0
                    vlSelfRef.tb_alu__DOT__result = 
                        ((4U & (IData)(vlSelfRef.tb_alu__DOT__alu_control))
                          ? ((- (IData)((1U & (~ (IData)(vlSelfRef.tb_alu__DOT__alu_control))))) 
                             & ((vlSelfRef.tb_alu__DOT__a 
                                 ^ vlSelfRef.tb_alu__DOT__b) 
                                & (- (IData)((1U & 
                                              (~ ((IData)(vlSelfRef.tb_alu__DOT__alu_control) 
                                                  >> 1U)))))))
                          : ((2U & (IData)(vlSelfRef.tb_alu__DOT__alu_control))
                              ? ((1U & (IData)(vlSelfRef.tb_alu__DOT__alu_control))
                                  ? (vlSelfRef.tb_alu__DOT__a 
                                     | vlSelfRef.tb_alu__DOT__b)
                                  : (vlSelfRef.tb_alu__DOT__a 
                                     & vlSelfRef.tb_alu__DOT__b))
                              : ((1U & (IData)(vlSelfRef.tb_alu__DOT__alu_control))
                                  ? (vlSelfRef.tb_alu__DOT__a 
                                     - vlSelfRef.tb_alu__DOT__b)
                                  : (vlSelfRef.tb_alu__DOT__a 
                                     + vlSelfRef.tb_alu__DOT__b))));
                }
            }
        }
    }
    return (__VactExecute);
}

bool Vtb_alu___024root___eval_phase__inact(Vtb_alu___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_alu___024root___eval_phase__inact\n"); );
    Vtb_alu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    CData/*0:0*/ __VinactExecute;
    // Body
    __VinactExecute = vlSelfRef.__VdlySched.awaitingZeroDelay();
    if (__VinactExecute) {
        VL_FATAL_MT("tb\\tb_alu.sv", 1, "", "ZERODLY: Design Verilated with '--no-sched-zero-delay', but #0 delay executed at runtime");
    }
    return (__VinactExecute);
}

void Vtb_alu___024root___trigger_clear__act(VlUnpacked<QData/*63:0*/, 1> &out) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_alu___024root___trigger_clear__act\n"); );
    // Locals
    IData/*31:0*/ n;
    // Body
    n = 0U;
    do {
        out[n] = 0ULL;
        n = ((IData)(1U) + n);
    } while ((1U > n));
}

bool Vtb_alu___024root___eval_phase__nba(Vtb_alu___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_alu___024root___eval_phase__nba\n"); );
    Vtb_alu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    CData/*0:0*/ __VnbaExecute;
    // Body
    __VnbaExecute = Vtb_alu___024root___trigger_anySet__act(vlSelfRef.__VnbaTriggered);
    if (__VnbaExecute) {
        {
            // Inlined CFunc: _eval_nba
            if ((1ULL & vlSelfRef.__VnbaTriggered[0U])) {
                {
                    // Inlined CFunc: _act_sequent__TOP__0
                    vlSelfRef.tb_alu__DOT__result = 
                        ((4U & (IData)(vlSelfRef.tb_alu__DOT__alu_control))
                          ? ((- (IData)((1U & (~ (IData)(vlSelfRef.tb_alu__DOT__alu_control))))) 
                             & ((vlSelfRef.tb_alu__DOT__a 
                                 ^ vlSelfRef.tb_alu__DOT__b) 
                                & (- (IData)((1U & 
                                              (~ ((IData)(vlSelfRef.tb_alu__DOT__alu_control) 
                                                  >> 1U)))))))
                          : ((2U & (IData)(vlSelfRef.tb_alu__DOT__alu_control))
                              ? ((1U & (IData)(vlSelfRef.tb_alu__DOT__alu_control))
                                  ? (vlSelfRef.tb_alu__DOT__a 
                                     | vlSelfRef.tb_alu__DOT__b)
                                  : (vlSelfRef.tb_alu__DOT__a 
                                     & vlSelfRef.tb_alu__DOT__b))
                              : ((1U & (IData)(vlSelfRef.tb_alu__DOT__alu_control))
                                  ? (vlSelfRef.tb_alu__DOT__a 
                                     - vlSelfRef.tb_alu__DOT__b)
                                  : (vlSelfRef.tb_alu__DOT__a 
                                     + vlSelfRef.tb_alu__DOT__b))));
                }
            }
        }
        Vtb_alu___024root___trigger_clear__act(vlSelfRef.__VnbaTriggered);
    }
    return (__VnbaExecute);
}

void Vtb_alu___024root___eval(Vtb_alu___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_alu___024root___eval\n"); );
    Vtb_alu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    IData/*31:0*/ __VnbaIterCount;
    // Body
    __VnbaIterCount = 0U;
    do {
        if (VL_UNLIKELY(((0x00002710U < __VnbaIterCount)))) {
#ifdef VL_DEBUG
            Vtb_alu___024root___dump_triggers__act(vlSelfRef.__VnbaTriggered, "nba"s);
#endif
            VL_FATAL_MT("tb\\tb_alu.sv", 1, "", "DIDNOTCONVERGE: NBA region did not converge after '--converge-limit' of 10000 tries");
        }
        __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
        vlSelfRef.__VinactIterCount = 0U;
        do {
            if (VL_UNLIKELY(((0x00002710U < vlSelfRef.__VinactIterCount)))) {
                VL_FATAL_MT("tb\\tb_alu.sv", 1, "", "DIDNOTCONVERGE: Inactive region did not converge after '--converge-limit' of 10000 tries");
            }
            vlSelfRef.__VinactIterCount = ((IData)(1U) 
                                           + vlSelfRef.__VinactIterCount);
            vlSelfRef.__VactIterCount = 0U;
            do {
                if (VL_UNLIKELY(((0x00002710U < vlSelfRef.__VactIterCount)))) {
#ifdef VL_DEBUG
                    Vtb_alu___024root___dump_triggers__act(vlSelfRef.__VactTriggered, "act"s);
#endif
                    VL_FATAL_MT("tb\\tb_alu.sv", 1, "", "DIDNOTCONVERGE: Active region did not converge after '--converge-limit' of 10000 tries");
                }
                vlSelfRef.__VactIterCount = ((IData)(1U) 
                                             + vlSelfRef.__VactIterCount);
                vlSelfRef.__VactPhaseResult = Vtb_alu___024root___eval_phase__act(vlSelf);
            } while (vlSelfRef.__VactPhaseResult);
            vlSelfRef.__VinactPhaseResult = Vtb_alu___024root___eval_phase__inact(vlSelf);
        } while (vlSelfRef.__VinactPhaseResult);
        vlSelfRef.__VnbaPhaseResult = Vtb_alu___024root___eval_phase__nba(vlSelf);
    } while (vlSelfRef.__VnbaPhaseResult);
}

#ifdef VL_DEBUG
void Vtb_alu___024root___eval_debug_assertions(Vtb_alu___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_alu___024root___eval_debug_assertions\n"); );
    Vtb_alu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}
#endif  // VL_DEBUG
