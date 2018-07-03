#########################################################################
# File Name: sed_name.sh
# Author: C.J. Liu
# Mail: samliu@hust.edu.cn
# Created Time: Tue 01 Sep 2015 12:09:27 PM CST
#########################################################################
#!/bin/bash


if [ $# -ne 3 ]
then
	echo "Usage:"
	echo "	Input two parameters"
	echo "	First is the file or directory"
	echo "	Second is the old name"
	echo "	Third is the part of new name"
	echo "Example:"
	echo "	rename.sed.sh `pwd` old_name new_name"
	echo "	rename.sed.sh file old_name new_name"
	exit 1
fi


Old=$2
New=$3
File=$1

if [ -d $File ];then
for i in `ls $PWD`;
do
	Name=`echo $i|sed -e s/$Old/$New/`
	mv  $i $Name
done
fi

if [ -f $File ];
then
	Name=`echo $File|sed -e s/$Old/$New/`
	mv $File $Name
fi


