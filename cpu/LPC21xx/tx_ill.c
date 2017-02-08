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
/*    tx_ill.c                                          ARM/Green Hills   */
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
#include "tx_tim.h"
#include "tx_ini.h"

/* declear for complier.   none used   */
char __ghsbegin_events[100];
char __ghsend_events[100];

/**************************************************************************/
/*                                                                        */ 
/*     dynamic memery                                                     */ 
/*                                                                        */
/**************************************************************************/
#define TX_DYNAMIC_MEM_SIZE		    8000

/*  dynamic memery declear  */
static int _tx_initialize_first_memory[TX_DYNAMIC_MEM_SIZE];

/**************************************************************************/
/*                                                                        */ 
/*     timer thread stack                                                 */ 
/*                                                                        */
/**************************************************************************/
#define TX_THREAD_TIMER_STKSIZE       512

/* stack for timer thread  */
static int _tx_timer_stack[TX_THREAD_TIMER_STKSIZE];

/**************************************************************************/ 
/*                                                                        */ 
/*  FUNCTION                                               RELEASE        */ 
/*                                                                        */ 
/*    _tx_initialize_low_level                                            */ 
/*                                                           3.0a         */ 
/*  AUTHOR                                                                */ 
/*                                                                        */ 
/*                                                                        */ 
/*                                                                        */ 
/*  DESCRIPTION                                                           */ 
/*                                                                        */ 
/*    This function is responsible for any low-level processor            */ 
/*    initialization, including setting up interrupt vectors, saving the  */ 
/*    system stack pointer, finding the first available memory address,   */ 
/*    and setting up parameters for the system's timer thread.            */ 
/*                                                                        */ 
/*  INPUT                                                                 */ 
/*                                                                        */ 
/*    None                                                                */ 
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
/*    _tx_initialize_kernel_enter           ThreadX entry function        */ 
/*                                                                        */ 
/*  RELEASE HISTORY                                                       */ 
/*                                                                        */ 
/*    DATE              NAME                      DESCRIPTION             */ 
/*                                                                        */ 
/*                                                                        */ 
/**************************************************************************/
void _tx_initialize_low_level(void)
{
    _tx_timer_stack_start           = &_tx_timer_stack[0];
    _tx_timer_stack_size            = sizeof(_tx_timer_stack);
    _tx_timer_priority              = 0;
    _tx_initialize_unused_memory    = (VOID_PTR) &_tx_initialize_first_memory[0];    
}

