;/**************************************************************************/
;/* MODE BITS/MASKS DEFINES                                                */
;/**************************************************************************/
LOCKOUT         EQU     0xC0                ; Interrupt lockout value
MODE_MASK       EQU     0x1F                ; Processor Mode Mask
SUP_MODE        EQU     0x13                ; Supervisor Mode (SVC)

I_BIT           EQU     0x80                ; Interrupt bit of CPSR and SPSR
F_BIT           EQU     0x40                ; Interrupt bit of CPSR and SPSR

;/**************************************************************************/
;/* STACK DEFINES                                                          */
;/**************************************************************************/
SVC_STACK_LEGTH         EQU         1024
FIQ_STACK_LEGTH         EQU         256
IRQ_STACK_LEGTH         EQU         256
ABT_STACK_LEGTH         EQU         0
UND_STACK_LEGTH         EQU         0
SYS_STACK_LEGTH         EQU         256     ; For Operating System Only

;/**************************************************************************/
;/* IMPORT SYMBOLS                                                         */
;/**************************************************************************/
        ; The imported labels
        IMPORT __use_no_semihosting_swi
        IMPORT __main
        
        IMPORT do_undefined_instruction
        IMPORT do_software_interrupt
        IMPORT do_prefetch_abort
        IMPORT do_data_abort
        IMPORT do_fiq                      ; Fast interrupt exceptions handler
        IMPORT do_irq
        
;/**************************************************************************/
;/* EXPORT SYMBOLS                                                         */
;/**************************************************************************/
        ; The exported labels
        EXPORT irq_enable
        EXPORT irq_disable
        EXPORT bottom_of_heap
        EXPORT __user_initial_stackheap
        EXPORT system_stack_ptr
        
;/**************************************************************************/
;/* CODE START                                                             */
;/**************************************************************************/
    CODE32
    PRESERVE8
    AREA INT_CODE,CODE,READONLY
    ENTRY
    
; /* Interrupt vectors */
_start
        LDR     pc, ResetAddr
        LDR     pc, _undefined_instruction
        LDR     pc, _software_interrupt
        LDR     pc, _prefetch_abort
        LDR     pc, _data_abort
        DCD     0xb9205f80
        LDR     pc, [pc, #-0xff0]
        LDR     pc, _fiq
        
ResetAddr               DCD     reset
_undefined_instruction  DCD     undefined_instruction
_software_interrupt     DCD     software_interrupt
_prefetch_abort         DCD     prefetch_abort
_data_abort             DCD     data_abort
_not_used               DCD     0
_irq                    DCD     irq
_fiq                    DCD     fiq

; /* Reset entry */
reset
        BL     STACK_Init                   ; Initialize the stack
        
        LDR    r0, =__main
        BX     r0                           ; Jump to the entry point of C program
        
;/**************************************************************************/
;/* STACK INIT                                                             */
;/**************************************************************************/
STACK_Init    
        MOV    r0, lr
        MSR    CPSR_c, #0xd2                ; Switch to Interrupt Request mode (IRQ)
        LDR    sp, STACK_Irq                ; Pickup STACK_Irq value to sp
        MSR    CPSR_c, #0xd1                ; Switch to Fast Interrupt Request mode (FIQ)
        LDR    sp, STACK_Fiq                ; Pickup STACK_Fiq value to sp
        MSR    CPSR_c, #0xd7                ; Switch to Data Abort mode (ABT)
        LDR    sp, STACK_Abt                ; Pickup STACK_Abt value to sp
        MSR    CPSR_c, #0xdb                ; Switch to Undefined Instruction mode (UND)
        LDR    sp, STACK_Und                ; Pickup STACK_Und value to sp
        MSR    CPSR_c, #0xdf                ; Switch to System mode (SYS)
        LDR    sp, =StackUsr                ; Pickup StackUsr value to sp
        MSR    CPSR_c, #(SUP_MODE | I_BIT)  ; Switch to supervisor mode (SVC)
        LDR    sp, STACK_Svc                ; Pickup STACK_Svc value to sp
        
        BX     r0                           ; Return to Caller

;/**************************************************************************/
;/* INTERUPT                                                               */
;/**************************************************************************/

S_FRAME_SIZE    EQU         72
S_SP            EQU         52

    MACRO
$label bad_save_user_regs
        SUB    sp, sp, #S_FRAME_SIZE
        STMIA  sp, {r0 - r12}               ; Push r0-r12 on the current stack
        
        ADD    r0, sp, #S_FRAME_SIZE
        MOV    r1, lr
        MOV    r2, pc
        MRS    r3, SPSR
        ADD    r5, sp, #S_SP
        STMIA  r5, {r0 - r3}
        MOV    r0, sp
    MEND
    
;/**************************************************************************/
;/* Undefined Instruction interrupt                                        */
;/**************************************************************************/
undefined_instruction
        bad_save_user_regs
        B      do_undefined_instruction
        
;/**************************************************************************/
;/* Software interrupt                                                     */
;/**************************************************************************/
software_interrupt
        bad_save_user_regs
        B      do_software_interrupt   

;/**************************************************************************/
;/* Pre fetch abort interrupt                                              */
;/**************************************************************************/
prefetch_abort
        bad_save_user_regs
        B      do_prefetch_abort
        
;/**************************************************************************/
;/* Data abort interrupt                                                   */
;/**************************************************************************/
data_abort
        bad_save_user_regs
        B      do_data_abort
        
;/**************************************************************************/
;/* IRQ interrupt                                                          */
;/**************************************************************************/
irq
        STMFD  sp!, {r0-r3,r12,lr}
        BL     do_irq
        LDMFD  sp!, {r0-r3,r12,lr}
        SUBS   pc,  lr,  #4
        
;/**************************************************************************/
;/* FIQ interrupt                                                          */
;/**************************************************************************/
fiq
        STMFD  sp!, {r0-r3,r12,lr}
        BL     do_fiq
        LDMFD  sp!, {r0-r3,r12,lr}
        SUBS   pc,  lr,  #4
        
;/**************************************************************************/
;/* Disable IRQ interrupt                                                  */
;/**************************************************************************/
irq_disable
        MRS    r0, SPSR
        ORR    r0, r0, #I_BIT
        MSR    SPSR_c, r0
        BX     lr
        
;/**************************************************************************/
;/* Enable IRQ interrupt                                                   */
;/**************************************************************************/
irq_enable
        MRS    r0, SPSR
        BIC    r0, r0, #I_BIT
        MSR    SPSR_c, r0
        BX     lr
        
;/**************************************************************************/
;/* Disable FIQ interrupt                                                  */
;/**************************************************************************/
fiq_disable
        MRS    r0, SPSR
        ORR    r0, r0, #F_BIT
        MSR    SPSR_c, r0
        BX     lr

;/**************************************************************************/
;/* Enable FIQ interrupt                                                   */
;/**************************************************************************/
fiq_enable
        MRS    r0, SPSR
        BIC    r0, r0, #F_BIT
        MSR    SPSR_c, r0
        BX     lr

;/**************************************************************************/
;/* User stack heap Initialize                                             */
;/**************************************************************************/
__user_initial_stackheap    
        LDR    r0, =bottom_of_heap
;       LDR    r1, =StackUsr
        BX     lr

;/**************************************************************************/
;/* STACK BOTTOM ADDRES                                                    */
;/**************************************************************************/
STACK_Svc          DCD    SVCStackSpace + (SVC_STACK_LEGTH - 1)* 4
STACK_Irq          DCD    IRQStackSpace + (IRQ_STACK_LEGTH - 1)* 4
STACK_Fiq          DCD    FIQStackSpace + (FIQ_STACK_LEGTH - 1)* 4
STACK_Abt          DCD    ABTStackSpace + (ABT_STACK_LEGTH - 1)* 4
STACK_Und          DCD    UNDStackSpace + (UND_STACK_LEGTH - 1)* 4
system_stack_ptr   DCD    SYSStackSpace + (SYS_STACK_LEGTH - 1)* 4
        
        
;/**************************************************************************/
;/* STACK AREA                                                             */
;/**************************************************************************/
        AREA STACK_Area, DATA, NOINIT, ALIGN=2
SVCStackSpace      SPACE    SVC_STACK_LEGTH * 4  ; Stack spaces for Administration Mode
IRQStackSpace      SPACE    IRQ_STACK_LEGTH * 4  ; Stack spaces for Interrupt ReQuest Mode
FIQStackSpace      SPACE    FIQ_STACK_LEGTH * 4  ; Stack spaces for Fast Interrupt reQuest Mode
ABTStackSpace      SPACE    ABT_STACK_LEGTH * 4  ; Stack spaces for Suspend Mode
UNDStackSpace      SPACE    UND_STACK_LEGTH * 4  ; Stack spaces for Undefined Mode
SYSStackSpace      SPACE    SYS_STACK_LEGTH * 4  ; Stack spaces for Operating System

;/**************************************************************************/
;/* HEAP AREA                                                              */
;/**************************************************************************/
        AREA HEAP_Area, DATA, NOINIT, ALIGN=2
bottom_of_heap     SPACE    1024 * 4

;/**************************************************************************/
;/* User/System STACK AREA                                                 */
;/**************************************************************************/
        AREA SYS_Area, DATA, NOINIT, ALIGN=2
StackUsr

    END

