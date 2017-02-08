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
;/*    tx_tpc.s                                          ARM/Green Hills   */
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
    AREA    tx_tpc,CODE,READONLY
    
    extern _tx_thread_execute_ptr
    extern _tx_thread_current_ptr
    
    extern _tx_thread_schedule
    extern _tx_thread_context_save
    
    global _tx_thread_preempt_check
    
;/**************************************************************************/ 
;/*                                                                        */ 
;/*  FUNCTION                                               RELEASE        */ 
;/*                                                                        */ 
;/*    _tx_thread_preempt_check                                            */ 
;/*                                                           3.0a         */ 
;/*  AUTHOR                                                                */ 
;/*                                                                        */ 
;/*                                                                        */ 
;/*                                                                        */ 
;/*  DESCRIPTION                                                           */ 
;/*                                                                        */ 
;/*    This function checks for a preempt condition that might have taken  */ 
;/*    place on top of an optimized assembly language ISR.  If preemption  */ 
;/*    should take place, context save/restore processing is called.       */ 
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
;/*    _tx_thread_context_save                                             */ 
;/*    _tx_thread_schedule                                                 */ 
;/*                                                                        */ 
;/*  CALLED BY                                                             */ 
;/*                                                                        */ 
;/*    timer_tick                                                          */ 
;/*                                                                        */ 
;/*  RELEASE HISTORY                                                       */ 
;/*                                                                        */ 
;/*    DATE              NAME                      DESCRIPTION             */ 
;/*                                                                        */ 
;/*                                                                        */ 
;/**************************************************************************/ 
_tx_thread_preempt_check
    LDR     r1, =_tx_thread_current_ptr    ; Pickup Current Thread's pointer to r1
    LDR     r2, =_tx_thread_execute_ptr    ; Pickup Execute Thread's pointer to r2
    
    LDR     r1, [r1]                       ; Pickup Current Thread's value to r1
    LDR     r2, [r2]                       ; Pickup Execute Thread's value to r1
    CMP     r1, r2  
    LDMFDEQ sp!, {r0-r3, pc}^              ; Pop minimal context on the current stack without preempt
    
;
;    /* Execute Thread's stack check. */
;
_tx_stack_start_check
    LDR     r0, [r2, #0x08]                ; Pickup Execute Thread's stack pointer to r0
    LDR     r3, [r2, #0x0c]                ; Pickup Execute Thread's Stack starting address to r3
    CMP     r0, r3
    BLO     _tx_stack_check_loop           ; If tx_stack_ptr < tx_stack_start Jump to _tx_stack_check_loop
    
_tx_stack_end_check
    LDR     r3, [r2, #0x10]                ; Pickup Execute Thread's Stack ending address to r3
    CMP     r0, r3
    BLS     _tx_current_stack_check        ; If tx_stack_ptr <= tx_stack_end Jump to _tx_current_stack_check
    
_tx_stack_check_loop
    B       _tx_stack_check_loop           ; Execute Thread's Stack Check error

;
;    /* Check if Current Thread's context have been saved or not. */
;
_tx_current_stack_check
    LDR     r2, [r1, #0x08]                ; Pickup Current Thread's stack pointer to r2
    CMP     r2, #0x00
                                           ; Current Thread's context have been saved if tx_stack_ptr is not zero
    BEQ     _tx_context_save_all           ; Jump to _tx_context_save_all and save complete context
    
;        
;   /* No need to save current Thread's context and Skip Saved minimal context on the current stack. */
;
    ADD     sp, sp, #4*5                   ; Skip r0-r3, lr on the current stack
    B       _tx_thread_preempt_check_exit
    
_tx_context_save_all
    MRS     r0, SPSR
    STMFD   sp!, {r0}                      ; Save cpsr on the current stack
    ADD     sp, sp, #4*6                   ; Restore interrupt sp
    
;        
;   /* Save complete context on the current Thread's stack. */
;
    BL      _tx_thread_context_save        ; Save context on the current Thread's stack
    
_tx_thread_preempt_check_exit
    MSR     CPSR_cxsf, #(SUP_MODE)         ; Switch to supervisor mode (SVC) and Re-enable interrupts
    LDR     pc, =_tx_thread_schedule
    
    END

