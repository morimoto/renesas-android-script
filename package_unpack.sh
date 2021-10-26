#! /bin/bash
# SPDX-License-Identifier: Apache-2.0
#===============================
#
# unzip_package
#
# 2021/09/15 Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
#===============================
TOP=`readlink -f "$0" | xargs dirname | xargs dirname`

source ${TOP}/scripts/param

#
# ex)
#
# ./package/salvator/SV00_Android_10_1.2_Software_001.zip	=> ${PK_DIR}/${ZIP}
# ./package/salvator/SV00_Android_10_1.2			=> ${PK_DIR}/${SV_DIR}
#

get_params() {

	#
	# check ${PK_DIR}
	#
	if [ ! -d ${PK_DIR} ]; then
		echo "Un Supported board"
		echo
		echo "Supported boards are"
		ls ${TOP}/package
		exit 1
	fi

	#
	# check zip file
	#
	ZIP="SV00_Android_${R_VER}.zip"
	if [ ! -f ${PK_DIR}/${ZIP} ]; then
		ZIP="SV00_Android_${R_VER}_Software_001.zip"
	fi

	if [ ! -f ${PK_DIR}/${ZIP} ]; then
		cat ${PK_DIR}/HOW_TO_GET
		exit 1
	fi
}

unpack_zip() {
	#
	# unzip and move it as
	# ex)
	#	./package/salvator/SV00_Android_10_1.2
	#
	cd ${PK_DIR}
	unzip ${ZIP}
	mv proprietary/pkgs_dir ${SV_DIR}
	rm -fr proprietary

	#
	# unzip at all subdir, and remove zip file itself
	#
	cd ${SV_DIR}
	for d in `ls`
	do
		(
			cd ${d}
			for f in `ls *.zip`
			do
				unzip ${f}
				rm -fr ${f}
			done
		)
	done
}

[ -d ${PK_DIR}/${SV_DIR} ] && exit

get_params
unpack_zip
