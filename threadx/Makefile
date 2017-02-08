#
# (C) Copyright 2000-2006
# Wolfgang Denk, DENX Software Engineering, wd@denx.de.
#
# See file CREDITS for list of people who contributed to this
# project.
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation; either version 2 of
# the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston,
# MA 02111-1307 USA
#

include $(TOPDIR)/config.mk

LIB	= $(obj)libthreadx.a

COBJS	= tx_ba.o     tx_efi.o   tx_si.o     tx_tprch.o  txe_byta.o  txe_taa.o	\
	tx_bpc.o    tx_efs.o   tx_sp.o     tx_tr.o     txe_bytc.o  txe_tc.o	\
	tx_bpcle.o  tx_el.o    tx_ta.o     tx_tra.o    txe_bytd.o  txe_tda.o	\
	tx_bpd.o    tx_ghs.o   tx_taa.o    tx_trel.o   txe_bytr.o  txe_tdel.o	\
	tx_bpi.o    tx_ihl.o   tx_tc.o     tx_tsa.o    txe_efc.o   txe_timd.o	\
	tx_br.o     tx_ike.o   tx_td.o     tx_tse.o    txe_efd.o   txe_tmch.o	\
	tx_byta.o   tx_qc.o    tx_tda.o    tx_tsle.o   txe_efg.o   txe_tmcr.o	\
	tx_bytc.o   tx_qcle.o  tx_tdel.o   tx_tsus.o   txe_efs.o   txe_tpch.o	\
	tx_bytcl.o  tx_qd.o    tx_ti.o     tx_tt.o     txe_qc.o    txe_tra.o	\
	tx_bytd.o   tx_qf.o    tx_tide.o   tx_tte.o    txe_qd.o    txe_trel.o	\
	tx_byti.o   tx_qi.o    tx_timch.o  tx_tto.o    txe_qf.o    txe_trpc.o	\
	tx_bytr.o   tx_qr.o    tx_timcr.o  tx_tts.o    txe_qr.o    txe_tsa.o	\
	tx_byts.o   tx_qs.o    tx_timd.o   tx_ttsc.o   txe_qs.o    txe_tt.o	\
	tx_efc.o    tx_sc.o    tx_timeg.o  txe_ba.o    txe_sc.o    txe_ttsc.o	\
	tx_efcle.o  tx_scle.o  tx_times.o  txe_bpc.o   txe_sd.o			\
	tx_efd.o    tx_sd.o    tx_timi.o   txe_bpd.o   txe_sg.o			\
	tx_efg.o    tx_sg.o    tx_tpch.o   txe_br.o    txe_sp.o

SOBJS	= 

SRCS 	:= $(COBJS:.o=.c)
OBJS	:= $(addprefix $(obj),$(COBJS))

$(LIB): $(OBJS) $(SOBJS)
	$(AR) $(ARFLAGS) $@ $(OBJS) $(SOBJS)

#########################################################################
include $(SRCTREE)/rules.mk

#########################################################################
