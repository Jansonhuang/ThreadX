#########################################################################

include $(TOPDIR)/config.mk

LIB	= lib$(CPU).a

START	= start.o

SOBJS	:= Int.o tx_tcr.o tx_tcs.o tx_tpc.o tx_ts.o tx_tsr.o

COBJS 	:= tx_ill.o tx_tic.o tx_timin.o tx_tsb.o cpu.o interrupts.o Int_c.o

SRCS 	:= $(COBJS:.o=.c)
OBJS 	:= $(addprefix $(obj),$(COBJS))

all:	$(LIB) $(START)

$(LIB): $(OBJS) $(SOBJS)
	$(AR) $(ARFLAGS) $@ $(SOBJS) $(OBJS)

#########################################################################
include $(SRCTREE)/rules.mk

#########################################################################
