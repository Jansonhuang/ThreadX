#########################################################################

include $(TOPDIR)/config.mk

LIB 	:= $(obj)libarm.a

SOBJS	:= 

COBJS 	:= rt_sys.o

SRCS 	:= $(COBJS:.o=.c)
OBJS 	:= $(addprefix $(obj),$(COBJS))

all:	$(LIB) $(START)

$(LIB): $(OBJS)
	$(AR) $(ARFLAGS) $@ $(OBJS)

#########################################################################
include $(SRCTREE)/rules.mk

#########################################################################
