#include <type.h>
#include <stdarg.h>
#include <LPC2106.h>
#include <LPC2106_VAL.h>

/* --------------------------------------
 * void tick_sched_timer (void)
 * -------------------------------------- */
void tick_sched_timer (void)
{
    _tx_timer_interrupt();
	
    T0IR = 0x01;
    VICVectAddr = 0; // 通知中断控制器中断结束
}


/* --------------------------------------
 * void Timer0_Initialize(void)
 * -------------------------------------- */
void Timer0_Initialize(void)
{
    /*----------------------------------------------------------------*/
    /* Local Variables                                                */
    /*----------------------------------------------------------------*/
	void timer_tick(void);

    /*----------------------------------------------------------------*/
    /* Code Body                                                      */
    /*----------------------------------------------------------------*/
    VICIntEnClr = 0xffffffff;
    VICIntEnable = 1 << 4;
    VICVectAddr0 = (u32_t)timer_tick;
    VICVectCntl0 = (0x20 | 0x04);
   
    T0IR = 0x01; // 中断复位
    T0TCR = 0x02; // 计数器复位(TC)
    T0MCR = 0x03; // 中断、TC自动复位
	// T0PR = 0; // 预分频寄存器
    T0MR0 = (Fpclk / 100);
	T0TCR = 0x01; // 启动定时器
}

