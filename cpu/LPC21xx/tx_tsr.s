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
;/*    tx_tsr.s                                          ARM/Green Hills   */
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
I_BIT       EQU         0x80

    CODE32
    PRESERVE8
    AREA    tx_tsr,CODE,READONLY

    extern _tx_thread_current_ptr
    extern _tx_thread_schedule
    
    global _tx_thread_system_return
    
;/**************************************************************************/ 
;/*                                                                        */ 
;/*  FUNCTION                                               RELEASE        */ 
;/*                                                                        */ 
;/*    _tx_thread_system_return                                            */ 
;/*                                                           3.0a         */ 
;/*  AUTHOR                                                                */ 
;/*                                                                        */ 
;/*                                                                        */ 
;/*                                                                        */ 
;/*  DESCRIPTION                                                           */ 
;/*                                                                        */ 
;/*    Save a thread's minimal context and exiting to the ThreadX          */ 
;/*      scheduling loop.                                                  */ 
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
;/*    _tx_thread_schedule                                                 */ 
;/*                                                                        */ 
;/*  CALLED BY                                                             */ 
;/*                                                                        */ 
;/*    core                                                                */ 
;/*                                                                        */ 
;/*  RELEASE HISTORY                                                       */ 
;/*                                                                        */ 
;/*    DATE              NAME                      DESCRIPTION             */ 
;/*                                                                        */ 
;/*                                                                        */ 
;/**************************************************************************/ 
_tx_thread_system_return
    MRS     r0,         SPSR
    MOV     r1,         lr
;
;    /* Lockout interrupts.  */
;
    MSR     CPSR_cxsf, #(SUP_MODE | I_BIT)
    
;
;   /* Save complete context on the current stack. */
;
    STMFD   sp!, {r1}                      ; Push Pc on the current stack
    STMFD   sp!, {r0-r12, lr}              ; Push r0-r12 on the current stack
    STMFD   sp!, {r0}                      ; Push cpsr on the current stack
    
    LDR     r0, =_tx_thread_current_ptr    ; Pickup address of _tx_thread_current_ptr
    LDR     r0, [r0]                       ; Pickup _tx_thread_current_ptr value
    STR     sp, [r0, #8]                   ; Store sp on tx_stack_ptr
    
    MSR     CPSR_cxsf, #(SUP_MODE)         ; Re-enable interrupts
    LDR     pc, =_tx_thread_schedule
   
    END

