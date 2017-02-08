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
/*    tx_timin.c                                        ARM/Green Hills   */
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
#include "tx_thr.h"
#include "tx_tim.h"

/**************************************************************************/ 
/*                                                                        */ 
/*  FUNCTION                                               RELEASE        */ 
/*                                                                        */ 
/*    _tx_timer_interrupt                                                 */ 
/*                                                           3.0a         */ 
/*  AUTHOR                                                                */ 
/*                                                                        */ 
/*                                                                        */ 
/*                                                                        */ 
/*  DESCRIPTION                                                           */ 
/*                                                                        */ 
/*    This function processes the hardware timer interrupt.  This         */ 
/*    processing includes incrementing the system clock and checking for  */ 
/*    time slice and/or timer expiration.  If either is found, the        */ 
/*    interrupt context save/restore functions are called along with the  */ 
/*    expiration functions.                                               */ 
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
/*    _tx_thread_resume                     Resume timer processing thread*/ 
/*    _tx_thread_time_slice                 Time slice interrupted thread */ 
/*                                                                        */ 
/*  CALLED BY                                                             */ 
/*                                                                        */ 
/*    interrupt vector                                                    */ 
/*                                                                        */ 
/*  RELEASE HISTORY                                                       */ 
/*                                                                        */ 
/*    DATE              NAME                      DESCRIPTION             */ 
/*                                                                        */ 
/*                                                                        */ 
/**************************************************************************/ 
void _tx_timer_interrupt(void)
{
    _tx_timer_system_clock++;
    if (_tx_timer_time_slice) {
		_tx_timer_time_slice--;
		if (_tx_timer_time_slice == 0) {
			_tx_timer_expired_time_slice =  TX_TRUE;
		}
    }

    if (*_tx_timer_current_ptr) {
        _tx_timer_expired =  TX_TRUE;
    } else {
        _tx_timer_current_ptr++;
        if (_tx_timer_current_ptr == _tx_timer_list_end){
            _tx_timer_current_ptr =  _tx_timer_list_start;
		}
    }

    if ((_tx_timer_expired_time_slice) || (_tx_timer_expired)) {
		if (_tx_timer_expired) {
		    _tx_timer_expired   = TX_FALSE;
			_tx_thread_preempt_disable++;
	
			_tx_thread_resume(&_tx_timer_thread);
		}
		if (_tx_timer_expired_time_slice) {
    		_tx_timer_expired_time_slice    = TX_FALSE;
			if (_tx_thread_time_slice() == TX_FALSE) {
				_tx_timer_time_slice =  _tx_thread_current_ptr -> tx_time_slice;
			}
		 } 
    }
}


