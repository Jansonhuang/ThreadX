#########################################################################

VERSION = 3.0f

#########################################################################

OBJTREE		:= $(CURDIR)
SRCTREE		:= $(CURDIR)
TOPDIR		:= $(SRCTREE)

export	TOPDIR SRCTREE OBJTREE

#########################################################################

include $(OBJTREE)/include/config.mk
# load other configuration
include $(TOPDIR)/config.mk

export	ARCH CPU BOARD

OBJS  = cpu/$(CPU)/start.o

OBJS := $(addprefix $(obj),$(OBJS))

LIBS  = lib_generic/libgeneric.a
LIBS += lib_arm/libarm.a
LIBS += board/$(BOARDDIR)/lib$(BOARD).a
LIBS += cpu/$(CPU)/lib$(CPU).a

LIBS += threadx/libthreadx.a

LIBS := $(addprefix $(obj),$(LIBS))
.PHONY : $(LIBS)

SUBDIRS :=
.PHONY : $(SUBDIRS)

#########################################################################
#########################################################################

ALL = $(obj)LPC2106.hex

all:		$(ALL)

$(obj)LPC2106.hex:	$(obj)LPC2106.axf
		fromelf $< --i32 -o $@

$(obj)LPC2106.axf:	$(OBJS) $(LIBS)
		armlink --callgraph --verbose --map --xref --list list.txt --entry 0x0  --ro-base 0x00000000 --rw-base 0x40000000 --first start.o(INT_CODE) --errors err.txt --output $@ $^
		fromelf --text -c -s --output=LPC2106.lst $@

$(OBJS):
		$(MAKE) -C $(dir $(subst $(obj),,$@)) $(notdir $@)

$(LIBS):
		$(MAKE) -C $(dir $(subst $(obj),,$@))

$(SUBDIRS):
		$(MAKE) -C $@ all


#########################################################################
#########################################################################

clean:

