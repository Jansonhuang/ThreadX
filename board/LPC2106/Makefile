#########################################################################

include $(TOPDIR)/config.mk

LIB 	:= lib$(BOARD).a

SOBJS	:=

COBJS 	:= LPC2106.o

SRCS 	:= $(COBJS:.o=.c)
OBJS 	:= $(addprefix $(obj),$(COBJS))

all:	$(LIB) $(START)

$(LIB): $(OBJS) $(SOBJS)
	$(AR) $(ARFLAGS) $@ $(SOBJS) $(OBJS)

#########################################################################
include $(SRCTREE)/rules.mk

#########################################################################
