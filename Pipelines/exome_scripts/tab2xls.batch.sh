#########################################################################
# File Name: tab2xls.batch.sh
# Author: C.J. Liu
# Mail: samliu@hust.edu.cn
# Created Time: Tue 01 Sep 2015 01:02:26 PM CST
#########################################################################
#!/bin/bash

if [ $# -eq 0 ]
then
	echo "	Input several tab delimited file"
	exit 1
fi

for i in "$@"
do 
	tab2xls.py $i &
done


