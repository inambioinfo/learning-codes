#########################################################################
# File Name: cp_maf_to_dest.sh
# Author: C.J. Liu
# Mail: samliu@hust.edu.cn
# Created Time: Tue 01 Sep 2015 10:29:04 AM CST
#########################################################################
#!/bin/bash

if [ $# -eq 0 ]
then
	echo 'At least, input destination path'
	exit 1
fi

MAF=($(ls $PWD/*.maf.*))

if [ ${#MAF[@]} -ne 5 ]
then
	cp $1/*.maf.* $PWD
else
	cp $PWD/*.maf.* $1
fi



