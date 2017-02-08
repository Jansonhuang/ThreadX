;/**************************************************************************/
;/*                                                                        */
;/*            Copyright (c) 1996-2000 by Express Logic Inc.               */
;/*                                                                        */
;/*  This software is copyrighted by and is the sole property of Express   */
;/*  Logic, Inc.  All rights, title, ownership, or other interests         */
;/*  in the software remain the property of Express Logic, Inc.  This      */
;/*  software may only be used in accordance with the corresponding        */
;/*  license agreement.  Any unauthorized use, duplication, transmission,  */
;/*  distribution, or disclosure of this software is expressly forbidden.  */
;/*                                                                        */
;/*  This Copyright notice may not be removed or modified without prior    */
;/*  written consent of Express Logic, Inc.                                */
;/*                                                                        */
;/*  Express Logic, Inc. reserves the right to modify this software        */
;/*  without notice.                                                       */
;/*                                                                        */
;/*  Express Logic, Inc.                                                   */
;/*  11440 West Bernardo Court               info@expresslogic.com         */
;/*  Suite 366                               http://www.expresslogic.com   */
;/*  San Diego, CA  92127                                                  */
;/*                                                                        */
;/**************************************************************************/


;/**************************************************************************/
;/**************************************************************************/
;/**                                                                       */
;/** ThreadX Component                                                     */
;/**                                                                       */
;/**   Port Specific                                                       */
;/**                                                                       */
;/**************************************************************************/
;/**************************************************************************/


;/**************************************************************************/
;/*                                                                        */
;/*  PORT SPECIFIC C INFORMATION                            RELEASE        */
;/*                                                                        */
;/*    tx_tcs.s                                          ARM/Green Hills   */
;/*                                                           3.0a         */
;/*                                                                        */
;/*  AUTHOR                                                                */
;/*                                                                        */
;/*    William E. Lamie, Express Logic, Inc.                               */
;/*                                                                        */
;/*  DESCRIPTION                                                           */
;/*                                                                        */
;/*                                                                        */
;/*  RELEASE HISTORY                                                       */
;/*                                                                        */
;/*    DATE              NAME                      DESCRIPTION             */
;/*                                                                        */
;/*                                                                        */
;/**************************************************************************/

SUP_MODE    EQU         0x13
IRQ_MODE    EQU         0x12
I_BIT       EQU         0x80

    CODE32
    PRESERVE8
    AREA    tx_tcs,CODE,READONLY

    extern _tx_thread_current_ptr
    
    global _tx_thread_context_save
    
;/**************************************************************************/ 
;/*                                                                        */ 
;/*  FUNCTION                                               RELEASE        */ 
;/*                                                                        */ 
;/*    _tx_thread_context_save                                             */ 
;/*                                                           3.0a         */ 
;/*  AUTHOR                                                                */ 
;/*                                                                        */ 
;/*                                                                        */ 
;/*                                                                        */ 
;/*  DESCRIPTION                                                           */ 
;/*                                                                        */ 
;/*    Save complete interrupted context on the current Thread's stack.    */ 
;/*                                                                        */ 
;/*  INPUT                                                                 */ 
;/*                                                                        */ 
;/*    None                                                                */ 
;/*                                                                        */ 
;/*  OUTPUT                                                                */ 
;/*                                                                        */ 
;/*    None                                                                */ 
;/*                                                                        */ 
;/*  CALLS                                                                 */ 
;/*                                                                        */ 
;/*                                                                        */ 
;/*  CALLED BY                                                             */ 
;/*                                                                        */ 
;/*    interrupt vector                                                    */ 
;/*                                                                        */ 
;/*  RELEASE HISTORY                                                       */ 
;/*                                                                        */ 
;/*    DATE              NAME                      DESCRIPTION             */ 
;/*                                                                        */ 
;/*                                                                        */ 
;/**************************************************************************/ 
_tx_thread_context_save
    SUB     r0, sp, #4                     ; Pickup stack bottom of saved context
    MSR     CPSR_cxsf, #(SUP_MODE | I_BIT) ; Switch to supervisor mode (SVC)
    
;    /* Save complete context on the current stack. */
    LDMFA   r0!, {r1}                      ; Pop Pc to r1
    STMFD   sp!, {r1}                      ; Push Pc on the current stack
    
    LDMFA   r0!, {r1-r3}                   ; Pop r1-r3 to r1-r3
    STMFD   sp!, {r1-r12}                  ; Push r1-r12 on the current stack
    LDMFA   r0!, {r1-r2}                   ; Pop cpsr, r0 to r1-r2
    STMFD   sp!, {r2}                      ; Push r0 on the current stack
    
    STMFD   sp!, {r1, lr}                  ; Push cpsr, lr on the current stack
    
    LDR     r0, =_tx_thread_current_ptr
    LDR     r0, [r0]
    STR     sp, [r0, #8]                   ; Store sp on tx_stack_ptr
    
    MSR     cpsr_c, #(IRQ_MODE | I_BIT)    ; Return to Interrupt Request mode (IRQ)
    BX      lr                             ; Return to Caller
    
    
    END

