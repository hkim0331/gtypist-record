#!/usr/bin/env dash
# -*- mode: Shell-script; coding: utf-8; -*-
#
if [ ! $# = 1 ]; then
	echo usage: $0 VERSION
	exit
fi
VERSION=$1

# files to footprint version number.
FILES="Makefile bashrc bash_profile "

# normally, format of comments are '# VERSION: number'.
for i in ${FILES}; do
    sed -i.bak "s/^# VERSION:.*$/# VERSION: ${VERSION}/" $i
done

# special format example.
sed -i.bak "s/VERSION:\s*.*$/VERSION: ${VERSION}/" emacs.d/init.el

# record the version number.
echo ${VERSION} > VERSION
echo ${VERSION} > emacs.d/VERSION
