#########################################################################

include $(TOPDIR)/config.mk

LIB 	:= $(obj)libgeneric.a

SOBJS	:= 

COBJS 	:= application.o generic.o

SRCS 	:= $(COBJS:.o=.c)
OBJS 	:= $(addprefix $(obj),$(COBJS))

all:	$(LIB) $(START)

$(LIB): $(OBJS)
	$(AR) $(ARFLAGS) $@ $(OBJS)

#########################################################################
include $(SRCTREE)/rules.mk

#########################################################################
