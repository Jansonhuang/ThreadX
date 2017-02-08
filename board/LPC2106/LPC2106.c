#include <type.h>
#include <LPC2106.h>
#include <LPC2106_VAL.h>


/* --------------------------------------
 * void uart_init(u32_t bps)
 * -------------------------------------- */
void uart_init(u32_t bps)
{  	
    u16_t Fdiv;
    
    PINSEL0 = (PINSEL0 & 0xfffffff0) | 0x05;    /* 选择管脚为UART0 */

    U0LCR = 0x80;                               /* 允许访问分频因子寄存器 */
    Fdiv = (Fpclk / 16) / bps;                  /* 设置波特率 */
    U0DLM = Fdiv / 256;							
	U0DLL = Fdiv % 256;						
    U0LCR = 0x03;                               /* 禁止访问分频因子寄存器 */
                                                /* 且设置为8,1,n */
	U0IER = 0x00;                               /* 禁止中断 */
    U0FCR = 0x00;                               /* 初始化FIFO */
} 

/* --------------------------------------
 * void board_init(void)
 * -------------------------------------- */
void board_init(void)
{ 
    
	/* 设置系统各部分时钟 */
    PLLCON = 1;
#if (Fpclk / (Fcclk / 4)) == 1
    VPBDIV = 0;
#endif
#if (Fpclk / (Fcclk / 4)) == 2
    VPBDIV = 2;
#endif
#if (Fpclk / (Fcclk / 4)) == 4
    VPBDIV = 1;
#endif

#if (Fcco / Fcclk) == 2
    PLLCFG = ((Fcclk / Fosc) - 1) | (0 << 5);
#endif
#if (Fcco / Fcclk) == 4
    PLLCFG = ((Fcclk / Fosc) - 1) | (1 << 5);
#endif
#if (Fcco / Fcclk) == 8
    PLLCFG = ((Fcclk / Fosc) - 1) | (2 << 5);
#endif
#if (Fcco / Fcclk) == 16
    PLLCFG = ((Fcclk / Fosc) - 1) | (3 << 5);
#endif
    PLLFEED = 0xaa;
    PLLFEED = 0x55;
    while((PLLSTAT & (1 << 10)) == 0);
    PLLCON = 3;
    PLLFEED = 0xaa;
    PLLFEED = 0x55;

	/* 设置存储器加速模块 */
    MAMCR = 2;
#if Fcclk < 20000000
    MAMTIM = 1;
#else
#if Fcclk < 40000000
    MAMTIM = 2;
#else
    MAMTIM = 3;
#endif
#endif
}



