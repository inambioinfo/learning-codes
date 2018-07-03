#!/bin/bash

FILETYPE="$(file "$1")";
#echo $FILETYPE;
case "$FILETYPE" in
	"$1: Zip archive"*)
	unzip "$1";;
	"$1: gzip compressed"*)
	gunzip "$1";;
	"$1: bzip2 compressed"*)
	bunzip2 "$1";;
	*) echo "File $1 can not b4e uncompressed with smartzip";;
esac



	






