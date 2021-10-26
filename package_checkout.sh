#! /bin/bash
# SPDX-License-Identifier: Apache-2.0
#===============================
#
# package_checkout
#
# 2021/09/21 Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
#===============================
TOP=`readlink -f "$0" | xargs dirname | xargs dirname`

source ${TOP}/scripts/param

link() {
	[ x$2 != x ] && [ ! -d $2 ] && return
	cp -r  ${RP_DIR}/$1 ${TOP}/android/$1
	[ $? != 0 ] && exit 1

	# some scripts/template has .gitkeep
	# which is not needed on Android. Remove it.
	find ${TOP}/android/$1 -name ".gitkeep" -exec rm {} \;
}

unlink() {
	rm -fr ${TOP}/android/$1
}

android_link() {
	$1 ${DIR_PROPRIETARY}/gfx
	$1 ${DIR_PROPRIETARY}/omx
	$1 ${DIR_PROPRIETARY}/adsp
	$1 ${DIR_PROPRIETARY}/usb
	$1 ${DIR_MODULES}/gfx
	$1 ${DIR_MODULES}/uvcs
	$1 ${DIR_MODULES}/adsp-s492c
	$1 ${DIR_GCC}/${GCC_GNU}
	$1 ${DIR_VHAL}/cms		${PK_DIR}/${SV_DIR}/cms
}

clean_template() {
	git -C ${TOP}/scripts clean -df template
}

unpack_gfx() {
	#
	# *** FIXME ***
	#
	# It is assuming Gen3 name
	#
	(
		cd ${PK_DIR}/${SV_DIR}/gfx

		#
		# for proprietary
		#
		for gfx in `find . -type f | grep "RTM8RC779.ZGG00Q.0JPAQE_.*/gfx.tar.gz$"`
		do
			tar -zxf ${gfx} -C ${RP_DIR}/${DIR_PROPRIETARY}
		done

		#
		# for modules
		#
		for gfx in `find . -type f | grep "RC.3G001A1001ZDO_.*/gfx.tar.gz$"`
		do
			tar -zxf ${gfx} -C ${RP_DIR}/${DIR_MODULES}
		done
	)
}

unpack_omx() {

	#	RTM8RC0000ZMD3LQ00JPAQE : not use
	preb="	RTM8RC0000ZMD0LQ00JPAQE
		RTM8RC0000ZMD4LQ00JPAQE
		RTM8RC0000ZME0LQ00JPAQE
		RTM8RC0000ZMX0LQ00JPAQE
		RTM8RC0000ZMD1LQ00JPAQE
		RTM8RC0000ZMD8LQ00JPAQE
		RTM8RC0000ZME1LQ00JPAQE
		RTM8RC0000ZMD2LQ00JPAQE
		RTM8RC0000ZMD9LQ00JPAQE
		RTM8RC0000ZME8LQ00JPAQE
		RTM8RC0000ZMDALQ00JPAQE"
	uvcs="	RTM8RC0000ZMX0DQ00JFAQE"

	#
	# use --strip-components on tar to ignore folder
	#
	# > tar -jxf RTM8RC0000ZMD0LQ00JPAQE.tar.bz2
	# > ls
	#	RTM8RC0000ZMD0LQ00JPAQE ...
	# > ls  RTM8RC0000ZMD0LQ00JPAQE
	#	config  include  lib64  src
	#
	(
		cd ${PK_DIR}/${SV_DIR}/omx

		#
		# for proprietary
		#
		for pkg in ${preb}
		do
			# RTM8RC0000ZMD9LQ00JPAQE might not exist
			[ ! -d ${pkg}_* ] && continue
			tar -jxf ${pkg}_*/${pkg}/Software/${pkg}.tar.bz2 -C ${RP_DIR}/${DIR_PROPRIETARY}/omx/prebuilts --strip-components 1
		done

		#
		# for modules
		#
		for pkg in ${uvcs}
		do
			tar -jxf ${pkg}_*/${pkg}/Software/${pkg}.tar.bz2 -C ${RP_DIR}/${DIR_MODULES}/uvcs --strip-components 1
		done
	)

	(
		#
		# needs configs from prebuilts/config
		#       ^^^^^^^                ^^^^^^
		cd ${RP_DIR}/${DIR_PROPRIETARY}/omx/
		mv ./prebuilts/config configs

		# remove un-needed folders
		rm -fr ./prebuilts/include
		rm -fr ./prebuilts/src
	)
}

unpack_adsp() {
	#
	# use --strip-components on tar to ignore folder
	#
	# > tar -jxf RTM8RC0000ZNA3SS00JFAQE.tar.bz2
	# > ls
	#	RTM8RC0000ZNA3SS00JFAQE ...
	# > tree
	#	RTM8RC0000ZNA3SS00JFAQE
	#	 - lib
	#	   - firmware
	#	     - xf-rcar.fw
	#

	#
	# for proprietary
	#
	pkg=RTM8RC0000ZNA3SS00JFAQE

	tar -xf ${PK_DIR}/${SV_DIR}/adsp/${pkg}_*/${pkg}/Software/${pkg}.tar.gz -C ${RP_DIR}/${DIR_PROPRIETARY}/adsp --strip-components 3

	#
	# for modules
	#
	mod=RTM8RC0000ZNA2DS00JFAQE

	tar -xf ${PK_DIR}/${SV_DIR}/adsp/${mod}_*/${mod}/Software/${mod}.tar.gz -C ${RP_DIR}/${DIR_MODULES}/adsp-s492c --strip-components 1

	#
	# remove un-needed folders
	#
	rm -fr ${RP_DIR}/${DIR_MODULES}/adsp-s492c/kernel-source
}

unpack_usb() {

	#
	# download linux-firmware under ${TOP}/scripts
	# and share it.
	#
	(
		cd ${TOP}/scripts
		if [ ! -d ${TOP}/scripts/linux-firmware ]; then
			git clone https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git
		else
			cd linux-firmware
			git remote update --prune
			git checkout origin/master
		fi
	)

	(
		cd ${RP_DIR}/${DIR_PROPRIETARY}/usb
		cp ${TOP}/scripts/linux-firmware/r8a779x_usb3_v2.dlmem .
		cp ${TOP}/scripts/linux-firmware/r8a779x_usb3_v3.dlmem .
		cp ${TOP}/scripts/linux-firmware/LICENCE.r8a779x_usb3  .
	)
}

unpack_cms() {
	# not always exist
	[ ! -d ${PK_DIR}/${SV_DIR}/cms ] && return

	pack[0]=RTM8RC0000ZVC1LQ00JPAQE
	pack[1]=RTM8RC0000ZVC2LQ00JPAQE
	pack[2]=RTM8RC0000ZVC3LQ00JPAQE

	dir[0]=libcmsbcm
	dir[1]=libcmsdgc
	dir[2]=libcmsblc

	(
		cd ${TOP}/scripts/
		if [ ! -d cms ]; then
			git clone https://github.com/morimoto/renesas-android-vendor-renesas-hal-cms.git cms
			[ $? != 0 ] && exit 1
		fi

		cd ${TOP}/scripts/cms
		git remote update --prune
		git clean -df
		git archive origin/renesas-android/${R_VER} --output=cms.tar.gz
		[ $? != 0 ] && exit 1

		tar -xf cms.tar.gz -C ${RP_DIR}/${DIR_VHAL}/cms/
	)
	[ $? != 0 ] && exit 1

	for ((i = 0; i < ${#pack[@]}; i++)) {
		(
			cd ${PK_DIR}/${SV_DIR}/cms/${pack[i]}*/${pack[i]}/Software
			tar -xf ${pack[i]}.tar.gz
			cp include/* lib/* ${RP_DIR}/${DIR_VHAL}/cms/${dir[i]}
		)
		[ $? != 0 ] && exit 1
	}
}

get_gcc() {

	GCC_FUL=gcc-linaro-7.3.1-2018.05-x86_64_${GCC_GNU}

	if [ ! -f ${TOP}/scripts/${GCC_FUL}.tar.xz ]; then
		(
			cd ${TOP}/scripts
			wget https://releases.linaro.org/components/toolchain/binaries/7.3-2018.05/aarch64-linux-gnu/${GCC_FUL}.tar.xz
		)
	fi

	(
		cd ${RP_DIR}/${DIR_GCC}
		tar -xf ${TOP}/scripts/${GCC_FUL}.tar.xz
		mv ${GCC_FUL} ${GCC_GNU}
	)
}

grep ${R_VER}_${BOARD} ${RP_DIR}/version > /dev/null 2>&1
if [ $? != 0 ]; then
	android_link	unlink
	clean_template
	unpack_gfx
	unpack_omx
	unpack_adsp
	unpack_usb
	unpack_cms
	get_gcc
	android_link	link
fi

echo ${R_VER}_${BOARD} > ${RP_DIR}/version
