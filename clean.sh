#! /bin/bash
# SPDX-License-Identifier: Apache-2.0
#===============================
#
# clean
#
# 2021/09/22 Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
#===============================
TOP=`readlink -f "$0" | xargs dirname | xargs dirname`

#
# Each script has own checker to avoid duplicate operation.
# This script removes it
#

# for package_unpack.sh
rm -fr ${TOP}/package/*/proprietary_*

# for package_checkout.sh
rm -fr ${TOP}/scripts/template/version

# for android_checkout.sh
# for make.sh
rm -fr ${TOP}/android
