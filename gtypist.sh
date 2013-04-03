#!/usr/bin/env dash
#-*- mode: shell-script; coding: utf-8; -*-
# programmed by Hiroshi Kimura, 2013-03-22.
#
# 記録を残すように改造した gtypist と共に viewer を立ち上げ、
# gtypist の終了とともに viewer を終わらす。
# VIEWER, TYPIST を正しく設定すること。

VIEWER=./gtypist_swing.rb
TYPIST=~/bin/gtypist

# 以下は変更の必要なし。
${VIEWER} &
pid=$!
${TYPIST}
kill ${pid}
