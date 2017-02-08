#########################################################################

obj :=
src :=

#
# When cross-compiling on NetBSD, we have to define __PPC__ or else we
# will pick up a va_list declaration that is incompatible with the
# actual argument lists emitted by the compiler.
#
# [Tested on NetBSD/i386 1.5 + cross-powerpc-netbsd-1.3]

ifdef	ARCH
sinclude $(TOPDIR)/$(ARCH)_config.mk	# include architecture dependend rules
endif
ifdef	CPU
sinclude $(TOPDIR)/cpu/$(CPU)/config.mk	# include  CPU	specific rules
endif
ifdef	SOC
sinclude $(TOPDIR)/cpu/$(CPU)/$(SOC)/config.mk	# include  SoC	specific rules
endif
ifdef	VENDOR
BOARDDIR = $(VENDOR)/$(BOARD)
else
BOARDDIR = $(BOARD)
endif
ifdef	BOARD
sinclude $(TOPDIR)/board/$(BOARDDIR)/config.mk	# include board specific rules
endif

#########################################################################

AR	= armar
AS	= armasm
LD	= armlink
CC	= armcc

#########################################################################

ARFLAGS = --create
AFLAGS  = --keep -g --cpu arm7tdmi --cpreproc --apcs=interwork --nowarn

CFLAGS  = -c -W -O0 -g --cpu arm7tdmi --apcs=interwork -Ono_fp_formats

CFLAGS += -I $(SRCTREE)/include
CFLAGS += -I $(SRCTREE)/threadx

CFLAGS += -I $(SRCTREE)/cpu/LPC21xx

#########################################################################

%.o:	%.s
	$(AS) $(AFLAGS) -c -o $@ $<
%.o:	%.c
	$(CC) $(CFLAGS) -c -o $@ $<

#########################################################################
