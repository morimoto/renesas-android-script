#! /bin/bash
# SPDX-License-Identifier: Apache-2.0
#===============================
#
# make
#
# 2021/09/21 Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
#===============================
TOP=`readlink -f "$0" | xargs dirname | xargs dirname`

source ${TOP}/scripts/param

#
# export
#
export TARGET_BOARD_PLATFORM=${TARGET_BOARD_PLATFORM}
export BUILD_BOOTLOADERS=true
export BUILD_BOOTLOADERS_SREC=true
export LC_ALL=C

[ x${H3_OPTION}		!= x ] && export H3_OPTION=${H3_OPTION}
[ x${RCAR_SA6_TYPE}	!= x ] && export RCAR_SA6_TYPE=${RCAR_SA6_TYPE}
[ x${RCAR_BOOT_EMMC}	!= x ] && export RCAR_BOOT_EMMC=${RCAR_BOOT_EMMC}

# CMS/ADSP
[ -d ${PK_DIR}/${SV_DIR}/cms  ] && export ENABLE_CMS=true
[ -d ${PK_DIR}/${SV_DIR}/adsp ] && export ENABLE_ADSP=true

#
# prepare
#
cd ${TOP}/android
source build/envsetup.sh

#
# run make
#
lunch ${BOARD}-${USER}
[ $? != 0 ] && exit 1

m
