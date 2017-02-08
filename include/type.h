#ifndef __TYPE_H__
#define __TYPE_H__

#ifdef	__cplusplus
extern	"C" {
#endif

#ifndef TRUE
#define TRUE  1
#endif

#ifndef FALSE
#define FALSE 0
#endif

typedef unsigned char	boolean;
typedef unsigned char 	u8_t;                    /* Unsigned  8 bit quantity                           */
typedef signed   char 	s8_t;                    /* Signed    8 bit quantity                           */
typedef unsigned short 	u16_t;                   /* Unsigned 16 bit quantity                           */
typedef signed   short 	s16_t;                   /* Signed   16 bit quantity                           */
typedef unsigned int 	u32_t;                   /* Unsigned 32 bit quantity                           */
typedef signed   int 	s32_t;                   /* Signed   32 bit quantity                           */
typedef float          	fp32;                    /* single precision floating point variable (32bits)  */
typedef double         	fp64;                    /* double precision floating point variable (64bits)  */
typedef unsigned long  	u64_t;


#ifdef	__cplusplus
}
#endif

#endif // __TYPE_H__

