#include <type.h>
#include <stdarg.h>
#include <LPC2106.h>
#include <LPC2106_VAL.h>


/* --------------------------------------
 * u8_t sendchar(u8_t data)
 * -------------------------------------- */
u8_t sendchar(u8_t data)
{
	if (data == '\n') {
		U0THR = '\r';
	    while ((U0LSR & 0x40) == 0); //等待数据发送完毕
	    {
	   	  u32_t i;
	      for (i = 0; i < 5; i++);
		}
	}
	
	U0THR = data; //发送数据
    while ((U0LSR & 0x40) == 0); //等待数据发送完毕
    {
   	  u32_t i;
      for(i = 0; i < 5; i++);
	}
	return 0;
}

/* --------------------------------------
 * int printk(const char *fmt,...)
 * -------------------------------------- */
int printk(const char *fmt,...)
{
	va_list ap;
	char strval[6];     
	char *str;
	char *p; 
	int nval; 
	signed char i = 0;

	va_start(ap, fmt);
	for(p = (char *)fmt; *p; p++) 
	{ 
		if (*p != '%') 
		{
			sendchar(*p);
			continue; 
		} 

		p++; 

		switch (*p) 
		{ 
		case 'd': 
			nval = va_arg(ap, int);
			i = 0;
			do
			{
				strval[i] = nval % 10;
				nval /= 10;
				i++;
			} while (nval > 0);
			i--;
			break; 

		case 'x': 
			nval = va_arg(ap, int);
			i = 0;
			do
			{
				strval[i] = nval % 16;
				if(strval[i] > 9)
					strval[i] = strval[i] - 10 + 'A' - '0';
				nval /= 16;
				i++;
			} while (nval > 0);
			i--;
			break; 

		case 'c': 
			i = -1;
			nval = va_arg(ap, int);							
			sendchar(nval);			  
			break;	

		case 's':
			i = -1;
			str = (char *)va_arg(ap, int);
			do
			{
				nval = *str++;
				if (nval != 0)
				{
					sendchar(nval);
				}
				else 
				{
					break;
				}
			} while (1);
			break;

		default: 
			break;	 
		} 

		for(; i >= 0; i--)
		{
			nval = strval[i] + '0';
			sendchar(nval);
		}
	}

	va_end(ap);
	return 0;
}

/* --------------------------------------
 * int printf(const char *fmt,...)
 * -------------------------------------- */
int printf(const char *format,...)
{
	va_list ap;
	char buffer[128], *s;
	va_start(ap, format);
	sprintf(buffer, format, ap);
	va_end(ap);

	s = buffer;
	while(*s)
	{
		sendchar(*s++);
	}
	
	return 0;
}

/* --------------------------------------
 * void assert(int expression)
 * -------------------------------------- */
void assert(int expression)
{
	if(!expression)
		__asm {swi 0x0;}
}



