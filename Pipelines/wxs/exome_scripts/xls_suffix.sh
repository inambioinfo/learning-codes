#!/bin/bash
num=0
folder=`pwd`
for filename in `ls $folder`;do
let num=$num+1
mv $filename $filename.xls
done
exit





