#!/usr/bin/env dash
# -*- mode: Shell-script; coding: utf-8; -*-
#
if [ ! $# = 1 ]; then
	echo usage: $0 VERSION
	exit
fi
VERSION=$1

# files to footprint version number.
FILES="gtypist.sh gtypist_swing.rb"

# normally, format of comments are '# VERSION: number'.
for i in ${FILES}; do
    sed -i.bak "s/^# VERSION:.*$/# VERSION: ${VERSION}/" $i
done

# record the version number.
echo ${VERSION} > VERSION
