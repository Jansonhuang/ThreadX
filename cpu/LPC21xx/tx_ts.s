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
;/*    tx_ts.s                                           ARM/Green Hills   */
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
    AREA    tx_tsr,CODE,READONLY

    extern system_stack_ptr
    extern _tx_thread_current_ptr
    extern _tx_thread_execute_ptr
    extern _tx_timer_time_slice

    extern _tx_thread_context_restore
    
    global _tx_thread_schedule
    
;/**************************************************************************/ 
;/*                                                                        */ 
;/*  FUNCTION                                               RELEASE        */ 
;/*                                                                        */ 
;/*    _tx_thread_schedule                                                 */ 
;/*                                                           3.0a         */ 
;/*  AUTHOR                                                                */ 
;/*                                                                        */ 
;/*                                                                        */ 
;/*                                                                        */ 
;/*  DESCRIPTION                                                           */ 
;/*                                                                        */ 
;/*    Schedule and restore the last context of the highest-priority       */ 
;/*      thread ready for execution.                                       */ 
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
;/*    _tx_thread_context_restore                                          */ 
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
_tx_thread_schedule
;
;    /* Switch to System Stack. */
;
    MSR     CPSR_cxsf, #(SUP_MODE | I_BIT) ; Lockout interrupts
    LDR     sp, =system_stack_ptr          ; Pickup address of system_stack_ptr
    LDR     sp, [sp]                       ; Store system_stack_ptr value to sp
    MSR     CPSR_cxsf, #(SUP_MODE)         ; Re-enable interrupts

;
;    /* Scheduling loop. */
;    
_tx_thread_schedule_loop
    LDR     r0, =_tx_thread_execute_ptr    ; Pickup address of _tx_thread_execute_ptr
    LDR     r0, [r0]                       ; Pickup _tx_thread_execute_ptr value
    
    CMP     r0, #0
    LDRNE   pc, =_tx_thread_to_schedule    ; If _tx_thread_execute_ptr is not null, Schedule to _tx_thread_execute_ptr
       
    B       _tx_thread_schedule_loop       ; Jump to _tx_thread_schedule_loop
    
;
;    /* Scheduling. */
;
_tx_thread_to_schedule
    LDR     r0, =_tx_thread_current_ptr    ; Pickup address of _tx_thread_current_ptr
    LDR     r1, =_tx_thread_execute_ptr    ; Pickup address of _tx_thread_execute_ptr
    LDR     r1, [r1]                       ; Pickup _tx_thread_execute_ptr value
    STR     r1, [r0]                       ; Store new _tx_thread_current_ptr

    LDR     r0, [r0]                       ; Pickup _tx_thread_current_ptr value
    LDR     r1, [r0, #4]                   ; Pickup time slice value
    ADD     r1, #1                         ; Increment the scheduled count
    STR     r1, [r0, #4]                   ; Store new scheduled count

    LDR     r2, =_tx_timer_time_slice      ; Pickup _tx_timer_time_slice address
    LDR     r3, [r0, #24]                  ; Pickup tx_time_slice
    LDR     r4, [r0, #28]                  ; Pickup tx_new_time_slice
    CMP     r3, #0
    STRNE   r3, [r2]                       ; Store tx_time_slice to _tx_timer_time_slice
    STREQ   r4, [r2]                       ; Store tx_new_time_slice to _tx_timer_time_slice
    
    LDR     pc, =_tx_thread_context_restore
    
    END

