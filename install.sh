#! /bin/bash
# SPDX-License-Identifier: Apache-2.0
#===============================
#
# install
#
# 2021/09/24 Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
#===============================
TOP=`readlink -f "$0" | xargs dirname | xargs dirname`

source ${TOP}/scripts/param

NAME=renesas-android-${R_VER}-${SOC}-${BOARD}-${USER}-`date +%Y%m%d`

if [ -d ${NAME} ]; then
	echo "${NAME} exist"
	exit 1
fi

mkdir -p ${NAME}
LIST="	${TOP}/android/out/target/product/${BOARD}/boot.img
	${TOP}/android/out/target/product/${BOARD}/dtb.img
	${TOP}/android/out/target/product/${BOARD}/dtbo.img
	${TOP}/android/out/target/product/${BOARD}/vbmeta.img
	${TOP}/android/out/target/product/${BOARD}/system.img
	${TOP}/android/out/target/product/${BOARD}/vendor.img
	${TOP}/android/out/target/product/${BOARD}/product.img
	${TOP}/android/out/target/product/${BOARD}/bootloader.img
	${TOP}/android/out/target/product/${BOARD}/odm.img
	${TOP}/android/out/target/product/${BOARD}/ramdisk.img
	${TOP}/android/out/target/product/${BOARD}/ramdisk-debug.img
	${TOP}/android/out/target/product/${BOARD}/boot-debug.img
	${TOP}/android/out/target/product/${BOARD}/super.img
	${TOP}/android/out/target/product/${BOARD}/super_empty.img
	${TOP}/android/out/target/product/${BOARD}/bl2.srec
	${TOP}/android/out/target/product/${BOARD}/bl31.srec
	${TOP}/android/out/target/product/${BOARD}/bootparam_sa0.srec
	${TOP}/android/out/target/product/${BOARD}/cert_header_sa6.srec
	${TOP}/android/out/target/product/${BOARD}/tee.srec
	${TOP}/android/out/target/product/${BOARD}/u-boot-elf.srec
	${TOP}/android/out/target/product/${BOARD}/bl2.bin
	${TOP}/android/vendor/renesas/utils/fastboot/fastboot.sh
	${TOP}/android/vendor/renesas/utils/fastboot/fastboot_functions.sh
	${TOP}/android/out/host/linux-x86/bin/adb
	${TOP}/android/out/host/linux-x86/bin/mke2fs
	${TOP}/android/out/host/linux-x86/bin/fastboot
"
for list in ${LIST}
do
	[ -f ${list} ] && cp ${list} ${NAME}
done
