#! /bin/bash
# SPDX-License-Identifier: Apache-2.0
#===============================
#
# repo_init ${R_VER}
#
# 2021/09/15 Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
#===============================
TOP=`readlink -f "$0" | xargs dirname | xargs dirname`

source ${TOP}/scripts/param

URL=https://android.googlesource.com/platform/manifest
LOCAL_MANIFESTS=https://github.com/morimoto/renesas-android-local-manifests.git

android_init() {
	#
	# prepare .repo
	#
	(
		cd ${TOP}/scripts

		# Get repo
		if [ ! -f repo ]; then
			wget -q https://storage.googleapis.com/git-repo-downloads/repo
			chmod +x repo
		fi
	)

	#
	# create .repo
	#
	# android_checkout / user will remote android.
	# Let's keep .repo under scripts, and avoid re-download all repository again.
	#
	if [ ! -d .repo ]; then
		${TOP}/scripts/repo init -u ${URL}
		[ $? != 0 ] && exit 1
	fi

	# create local_manifests
	# LOCAL_MANIFESTS might be updated
	if [ ! -d .repo/local_manifests ]; then
		git clone ${LOCAL_MANIFESTS} .repo/local_manifests
		[ $? != 0 ] && exit 1
	fi

	(
		cd .repo/local_manifests
		git remote update --prune
		git checkout origin/renesas-android/${R_VER}
	)
	[ $? != 0 ] && exit 1

	#
	# FIXME !!!
	#
	# I'm not sure why but Android build will have too many issues
	# if we re-use same Android folder between different versions
	# even though repo sync was successed.
	#
	# ex)
	#	1) repo sync ver X
	#	2) build Android X
	#	3) repo sync ver Y
	#	4) build Android Y
	#
	# In above case, we will have issue at 4).
	# It is not a build error, but some kind of cp error and/or
	# unknown status error, etc.
	#
	# And we might have other issue if user uses Ctrl-C during
	# checkouting. It might breaks each package's git.
	# It will be couse of unknown error,
	#
	# To avoid this issues, renesas-android-maker will *remove*
	# android folder, and clean checkout all.
	#
	# One note here is that .repo is safe, because it is located
	# at xxx ${TOP}/scripts/.repo
	# We don't need to re-full-download repository
	#
	rm -fr ${TOP}/android
}

android_checkout() {

	# create "android" and missing "proprietary"
	mkdir -p ${TOP}/android/hardware/renesas/proprietary

	(
		cd ${TOP}/android

		# re-use ${TOP}/scripts/.repo
		[ ! -d .repo ] && ln -s ${TOP}/.repo .

		# repo update
		${TOP}/scripts/repo selfupdate
		[ $? != 0 ] && exit 1

		# repo init
		${TOP}/scripts/repo init -u ${URL} -b ${A_VER}
		[ $? != 0 ] && exit 1

		# sync
		${TOP}/scripts/repo sync --force-sync --fail-fast -j 4
		[ $? != 0 ] && exit 1

		# last
		exit 0
	)
	[ $? != 0 ] && exit 1
}

apply_patch() {
	#
	# Because original AOSP git is too much big size,
	# having own git repository is risk and/or impossible.
	# On some project, we can't push it for example to Github.
	#
	# ex)
	#	> git push github ...
	#	...
	#	remote: fatal: pack exceeds maximum allowed size
	#	fatal: the remote end hung up unexpectedly
	#	fatal: the remote end hung up unexpectedly
	#
	# Don't have own-project, and use normal patch style
	# on renesas-android-maker
	#
	(
		cd ${TOP}/scripts/patches/android
		PATCHES=`find -type f | grep "\.patch\$" | sort`

		for PATCH in ${PATCHES}
		do
			DIR=`dirname ${PATCH}`

			cd ${TOP}/android/${DIR}
			git am -3 ${TOP}/scripts/patches/android/${PATCH}
			[ $? != 0 ] && exit 1
		done

		# last
		exit 0
	)
	[ $? != 0 ] && exit 1
}

grep ${R_VER} ${TOP}/android/renesas-version > /dev/null 2>&1
[ $? = 0 ] && exit

android_init
android_checkout

apply_patch

echo ${R_VER} > ${TOP}/android/renesas-version
