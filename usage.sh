#! /bin/sh
# SPDX-License-Identifier: Apache-2.0
#===============================
#
# usage
#
# 2021/09/16 Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
#===============================
TOP=`readlink -f "$0" | xargs dirname | xargs dirname`

LINE1=`grep -n -w "^* How to use ?" ${TOP}/README | awk -F ":" '{print $1}'`
LINE1=`expr ${LINE1} + 2`

LINE2=`tail -n +${LINE1} ${TOP}/README | egrep -n "^\S+" | head -n 1 | awk -F ":" '{print $1}'`
LINE2=`expr ${LINE1} + ${LINE2} - 2`

sed -n ${LINE1},${LINE2}p ${TOP}/README | less -F
