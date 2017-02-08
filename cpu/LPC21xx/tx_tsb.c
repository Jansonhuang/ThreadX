/**************************************************************************/
/*                                                                        */
/*            Copyright (c) 1996-2000 by Express Logic Inc.               */
/*                                                                        */
/*  This software is copyrighted by and is the sole property of Express   */
/*  Logic, Inc.  All rights, title, ownership, or other interests         */
/*  in the software remain the property of Express Logic, Inc.  This      */
/*  software may only be used in accordance with the corresponding        */
/*  license agreement.  Any unauthorized use, duplication, transmission,  */
/*  distribution, or disclosure of this software is expressly forbidden.  */
/*                                                                        */
/*  This Copyright notice may not be removed or modified without prior    */
/*  written consent of Express Logic, Inc.                                */
/*                                                                        */
/*  Express Logic, Inc. reserves the right to modify this software        */
/*  without notice.                                                       */
/*                                                                        */
/*  Express Logic, Inc.                                                   */
/*  11440 West Bernardo Court               info@expresslogic.com         */
/*  Suite 366                               http://www.expresslogic.com   */
/*  San Diego, CA  92127                                                  */
/*                                                                        */
/**************************************************************************/


/**************************************************************************/
/**************************************************************************/
/**                                                                       */
/** ThreadX Component                                                     */
/**                                                                       */
/**   Port Specific                                                       */
/**                                                                       */
/**************************************************************************/
/**************************************************************************/


/**************************************************************************/
/*                                                                        */
/*  PORT SPECIFIC C INFORMATION                            RELEASE        */
/*                                                                        */
/*    tx_tsb.c                                          ARM/Green Hills   */
/*                                                           3.0a         */
/*                                                                        */
/*  AUTHOR                                                                */
/*                                                                        */
/*    William E. Lamie, Express Logic, Inc.                               */
/*                                                                        */
/*  DESCRIPTION                                                           */
/*                                                                        */
/*                                                                        */
/*  RELEASE HISTORY                                                       */
/*                                                                        */
/*    DATE              NAME                      DESCRIPTION             */
/*                                                                        */
/*                                                                        */
/**************************************************************************/

/* Include necessary system files.  */
#include "tx_api.h"

/**************************************************************************/
/*      target model declear                                              */ 
/**************************************************************************/
#define MODE_SVC32         0x13       	  /*  管理模式                    */


/**************************************************************************/
/*                                                                        */ 
/*     data struct for arm target                                         */ 
/*                                                                        */
/**************************************************************************/
typedef struct arm_stack_struct {
    unsigned int cpsr;
    unsigned int lr;
    unsigned int r0;
    unsigned int r1;
    unsigned int r2;
    unsigned int r3;
    unsigned int r6;
    unsigned int r4;
    unsigned int r5;
    unsigned int r7;
    unsigned int r8;
    unsigned int r9;
    unsigned int r10;
    unsigned int r11;
    unsigned int r12;
    unsigned int pc;
} ARM_STACK;

/**************************************************************************/ 
/*                                                                        */ 
/*  FUNCTION                                               RELEASE        */ 
/*                                                                        */ 
/*    _tx_thread_stack_build                                              */ 
/*                                                           3.0a         */ 
/*  AUTHOR                                                                */ 
/*                                                                        */ 
/*                                                                        */ 
/*                                                                        */ 
/*  DESCRIPTION                                                           */ 
/*                                                                        */ 
/*    This function builds a stack frame on the supplied thread's stack.  */
/*    The stack frame results in a fake interrupt return to the supplied  */
/*    function pointer.                                                   */ 
/*                                                                        */ 
/*  INPUT                                                                 */ 
/*                                                                        */ 
/*    thread_ptr                            Pointer to thread control blk */
/*    function_ptr                          Pointer to return function    */
/*                                                                        */ 
/*  OUTPUT                                                                */ 
/*                                                                        */ 
/*    None                                                                */
/*                                                                        */ 
/*  CALLS                                                                 */ 
/*                                                                        */ 
/*    None                                                                */
/*                                                                        */ 
/*  CALLED BY                                                             */ 
/*                                                                        */ 
/*    _tx_thread_create                     Create thread service         */
/*                                                                        */ 
/*  RELEASE HISTORY                                                       */ 
/*                                                                        */ 
/*    DATE              NAME                      DESCRIPTION             */ 
/*                                                                        */ 
/*                                                                        */ 
/**************************************************************************/ 
void _tx_thread_stack_build(TX_THREAD *thread_ptr, void (*function_ptr)(void))
{    
    ARM_STACK    *ArmRegister   = 0;
    
    ArmRegister         = (ARM_STACK *)(((int)thread_ptr->tx_stack_end - sizeof(ARM_STACK) - 1) & 0xfffffffc);
    
    ArmRegister->cpsr   = MODE_SVC32;
    ArmRegister->lr     = (int)(thread_ptr->tx_thread_entry);    
    ArmRegister->r0     = (unsigned int)thread_ptr->tx_entry_parameter;    
    ArmRegister->r1     = 0;    
    ArmRegister->r2     = 0;    
    ArmRegister->r3     = 0;    
    ArmRegister->r4     = 0;    
    ArmRegister->r5     = 0;    
    ArmRegister->r6     = 0;    
    ArmRegister->r7     = 0;    
    ArmRegister->r8     = 0;    
    ArmRegister->r9     = 0;    
    ArmRegister->r10    = 0;    
    ArmRegister->r11    = 0;    
    ArmRegister->r12    = 0;    
    ArmRegister->pc     = (int)(thread_ptr->tx_thread_entry);    

    thread_ptr->tx_stack_ptr    = (VOID_PTR)ArmRegister;
}

