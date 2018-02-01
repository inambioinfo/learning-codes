#########################################################################
# File Name: thread.sh
# Author: C.J. Liu
# Mail: samliu@hust.edu.cn
# Created Time: Tue 03 Mar 2015 01:36:48 PM CST
#########################################################################
#!/bin/bash

#$1 is the max parallel number you set.
#$2 is the total task to deal with
#open a fifo file

tmp_fifofile='/tmp/$$.fifo'
mkfifo $tmp_fifofile
exec 6<>$tmp_fifofile
rm -rf $tmp_fifofile

#set parallel number
thread=$1
for (( i=0 ;i<$thread; i++ ))
do
	echo ""
done>&6

#your program 
for i in $(ls *.pl)
do
	str=${i%.pl}
	array+=($str)
done


#all task to tackle with
All_task=$2
for (( i=0; i<$2; i++ ))
do
	
	read -u6

	{
		sh nothing.sh ${array[i]}
		echo "">&6

	}&
	
done 
wait
exec 6>&-
exit 0



