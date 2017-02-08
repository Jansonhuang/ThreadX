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

#ifndef _THREAD_H_
#define _THREAD_H_

#include <signal.h>
#include <stdio.h>
#include <time.h>
#include <setjmp.h>

#define _SIGMAX  100

#if defined(SOLARIS20) && !defined(_SIGMAX)
#define _SIGMAX MAXSIG
#endif

#if defined(_WIN32) && !defined(_SIGMAX)
#define _SIGMAX (NSIG-1)
#endif

typedef void (*SignalHandler)(int);

typedef struct
{
	int			Errno;
	SignalHandler 		SignalHandlers[_SIGMAX];
	char			tmpnam_space[L_tmpnam];
	char			asctime_buff[30];
	char			*strtok_saved_pos;
	struct tm		gmtime_temp;
	/* C++ pointer for exception handling */
	void 			*__eh_globals;
} ThreadLocalStorage;

#ifdef use__ghs_threadlocalstorage
#define GetThreadLocalStorage() ((ThreadLocalStorage *)__ghs_threadlocalstorage)
#else
ThreadLocalStorage *GetThreadLocalStorage(void);
#endif

void __ghsLock(void);
void __ghsUnlock(void);
#ifndef EMBEDDED
#if 0
__inline void __ghsLock(void) { }
__inline void __ghsUnlock(void) { }
#endif
#endif

int  __ghs_SaveSignalContext(jmp_buf);
void __ghs_RestoreSignalContext(jmp_buf);

/* macros used in stdio library source */
#ifdef __ghs_thread_safe
# define LOCKFILE(f)	flockfile(f);
# define TRYLOCKFILE(f)	ftrylockfile(f);
# define UNLOCKFILE(f)	funlockfile(f);
# define LOCKCREATE(f)	flockcreate(f);
# define LOCKCLEANUP(f)	flockdestroy(f);
/* prototypes for FILE lock routines (not in POSIX API) */
void __ghs_flock_file(void *);
void __ghs_funlock_file(void *);
int __ghs_ftrylock_file(void *);
void __ghs_flock_create(void **);
void __ghs_flock_destroy(void *);
/* End New */
#else
# define LOCKFILE(f)
# define TRYLOCKFILE(f)	-1;	/* no lock obtained */
# define UNLOCKFILE(f)
# define LOCKCREATE(f)	
# define LOCKCLEANUP(f)	
#endif


#endif /* _THREAD_H_ */
