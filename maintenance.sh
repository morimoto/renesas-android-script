#! /bin/sh
# SPDX-License-Identifier: Apache-2.0
#===============================
#
# maintenance.sh
#
# 2021/09/22 Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
#===============================

#
# cd my_android
# maintenance.sh file_list_get > /tmp/my_android_file_list
#
file_list_get() {
	#
	# ignore
	#	.git
	#	.repo
	#	out
	#	cts
	#	strange file name
	#
	find -type f -not -path "*/.git/*" -not -path "./.repo/*" -not -path "./out/*" -not -path "./cts/*" -not -path "* *" -not -path "./prebuilts/gcc/linux-x86/aarch64/aarch64-linux-gnu/*"
}

#
# maintenance.sh file_list_check /tmp/my_android_file_list /tmp/your_android_file_list
#
file_list_check() {
	TMP=/tmp/maintenance-$$

	cat $1 $2 > ${TMP}
	sort ${TMP} | uniq -u

	rm ${TMP}
}

#
# cd my_android
# maintenance.sh sha256_get /tmp/my_android_file_list > /tmp/my_android_sha256
#
sha256_get() {
	for file in `cat $1`
	do
		sha256sum $file
	done
}

#
# cd my_android
# maintenance.sh sha256_check /tmp/my_android_sha256
#
sha256_check() {
	sha256sum -c $1 | grep -v ": OK$"
}

CMD=$1
shift 1

${CMD} $@
