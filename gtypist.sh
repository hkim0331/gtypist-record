#!/bin/sh
#-*- mode: shell-script; coding: utf-8; -*-
# programmed by Hiroshi Kimura, 2013-03-22.
#
# 記録を残すように改造した gtypist と共に viewer を立ち上げ、
# gtypist の終了とともに viewer を終わらす。
# VIEWER, TYPIST を正しく設定すること。
#
# VERSION: 0.3

if [ -d /home/t ]; then
    VIEWER=/edu/bin/gtypist_swing.rb
    TYPIST=/edu/bin/gtypist.raw
else
    VIEWER=./gtypist_swing.rb
    TYPIST=gtypist-2.9.2/src/gtypist
fi

# 以下は変更の必要なし。
${VIEWER} &
pid=$!
${TYPIST}
kill ${pid}
