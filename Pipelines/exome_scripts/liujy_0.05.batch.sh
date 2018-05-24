#########################################################################
# File Name: liujy.filter.batch.sh
# Author: C.J. Liu
# Mail: samliu@hust.edu.cn
# Created Time: Tue 01 Sep 2015 12:53:38 PM CST
#########################################################################
#!/bin/bash

if [ $# -eq 0 ]
then
	echo "	The aim of script is to filter maf < 0.05 records"
	echo 1
fi
for i in "$@"
do
	liujy_0.05.awk $i>$i.0.05 &
done


