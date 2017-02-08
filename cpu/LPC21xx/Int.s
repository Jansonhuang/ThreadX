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
;/*    Int.s                                             ARM/Green Hills   */
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
    AREA    Int,CODE,READONLY

    extern _tx_thread_preempt_check
    extern tick_sched_timer

    global _tx_interrupt_enable
    global _tx_interrupt_disable
    global timer_tick
    
    

;/**************************************************************************/ 
;/*                                                                        */ 
;/*  FUNCTION                                               RELEASE        */ 
;/*                                                                        */ 
;/*    timer_tick                                                          */ 
;/*                                                           3.0a         */ 
;/*  AUTHOR                                                                */ 
;/*                                                                        */ 
;/*                                                                        */ 
;/*                                                                        */ 
;/*  DESCRIPTION                                                           */ 
;/*                                                                        */ 
;/*    irq handle function, Should be ecectud after irq interupt, on other */
;/*    words, it should been put at the vector table                       */ 
;/*                                                                        */ 
;/*  INPUT                                                                 */ 
;/*                                                                        */ 
;/*                                                                        */ 
;/*  OUTPUT                                                                */ 
;/*                                                                        */ 
;/*    None                                                                */ 
;/*                                                                        */ 
;/*  CALLS                                                                 */ 
;/*                                                                        */ 
;/*    _tx_thread_preempt_check                                            */ 
;/*    _tx_thread_context_save                                             */ 
;/*    _tx_thread_schedule                                                 */ 
;/*                                                                        */ 
;/*  CALLED BY                                                             */ 
;/*                                                                        */ 
;/*    vector                                                              */ 
;/*                                                                        */ 
;/*  RELEASE HISTORY                                                       */ 
;/*                                                                        */ 
;/*    DATE              NAME                      DESCRIPTION             */ 
;/*                                                                        */ 
;/*                                                                        */ 
;/**************************************************************************/ 
timer_tick
;
;    /* Save minimal context on the current stack. */
;
    SUB     lr, lr, #4
    STMFD   sp!, {r0-r3, lr}               ; Push r0-r3, lr on the current stack
    BL      tick_sched_timer
	
    ; Check if reschedule is needed. If needn't to reschedule Thread, return to current Thread from saved minimal context,
	;   else if current Thread's context has been saved, restore current interrupt stack and schedule new Thread,
	;   else Save complete context on the current Thread's stack and schedule new Thread.
    B       _tx_thread_preempt_check
	
;/**************************************************************************/ 
;/*                                                                        */ 
;/*  FUNCTION                                               RELEASE        */ 
;/*                                                                        */ 
;/*    _tx_interrupt_enable                                                */ 
;/*                                                           3.0a         */ 
;/*  AUTHOR                                                                */ 
;/*                                                                        */ 
;/*                                                                        */ 
;/*                                                                        */ 
;/*  DESCRIPTION                                                           */ 
;/*                                                                        */ 
;/*    Enable IRQ interrupt.                                               */ 
;/*                                                                        */ 
;/*  INPUT                                                                 */ 
;/*                                                                        */ 
;/*                                                                        */ 
;/*  OUTPUT                                                                */ 
;/*                                                                        */ 
;/*    None                                                                */ 
;/*                                                                        */ 
;/*  CALLS                                                                 */ 
;/*                                                                        */ 
;/*    None                                                                */ 
;/*                                                                        */ 
;/*  CALLED BY                                                             */ 
;/*                                                                        */ 
;/*    TX_RESTORE                                                          */
;/*                                                                        */ 
;/*  RELEASE HISTORY                                                       */ 
;/*                                                                        */ 
;/*    DATE              NAME                      DESCRIPTION             */ 
;/*                                                                        */ 
;/*                                                                        */ 
;/**************************************************************************/ 
_tx_interrupt_enable
    MSR     CPSR_c, r0                     ; Store new cpsr
    BX      lr                             ; Return to Caller


;/**************************************************************************/ 
;/*                                                                        */ 
;/*  FUNCTION                                               RELEASE        */ 
;/*                                                                        */ 
;/*    _tx_interrupt_disable                                               */ 
;/*                                                           3.0a         */ 
;/*  AUTHOR                                                                */ 
;/*                                                                        */ 
;/*                                                                        */ 
;/*                                                                        */ 
;/*  DESCRIPTION                                                           */ 
;/*                                                                        */ 
;/*                                                                        */ 
;/*  INPUT                                                                 */ 
;/*                                                                        */ 
;/*                                                                        */ 
;/*  OUTPUT                                                                */ 
;/*                                                                        */ 
;/*    None                                                                */ 
;/*                                                                        */ 
;/*  CALLS                                                                 */ 
;/*                                                                        */ 
;/*    None                                                                */ 
;/*                                                                        */ 
;/*  CALLED BY                                                             */ 
;/*                                                                        */ 
;/*    TX_DISABLE                                                          */ 
;/*                                                                        */ 
;/*  RELEASE HISTORY                                                       */ 
;/*                                                                        */ 
;/*    DATE              NAME                      DESCRIPTION             */ 
;/*                                                                        */ 
;/*                                                                        */ 
;/**************************************************************************/ 
_tx_interrupt_disable
    MRS     r0, CPSR                       ; Set IRQ and FIQ bits in CPSR to disable all interrupts
    ORR     r1, r0, #0xc0
    MSR     CPSR_c, r1
    MRS     r1, CPSR                       ; Confirm that CPSR contains the proper interrupt disable flags
    BX      lr                             ; Disabled, return the original CPSR contents in r0
    
    END

