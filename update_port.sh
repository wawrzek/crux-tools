#!/bin/bash

print_help(){

echo """
Simple script to automate port update. It requires rootlesskit
The script:
  - downloads source and build the package (ignoring footprint &
    signature)
  - updates footprint (ignoring signature)
  - updates signature
  - optional: create git commit in pushes it to the remote repo
"""
exit 0
}

GIT=0

while getopts gh flag
do
	case "${flag}" in
		g) GIT=1;;
		h) print_help;;
	esac
done

command="rootlesskit pkgmk"

$command -d -if -is && \
$command -uf -is && \
	$command -us

if [[ $GIT -eq 1 ]]; then
	git commit -a -m:"$(basename $PWD): update version" && git push
fi

# vim: set noet ts=4 sw=4:
