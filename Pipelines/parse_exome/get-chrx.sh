#########################################################################
# File Name: get-chrx.sh
# Author: Chun-Jie Liu
# Mail: chunjie-sam-liu@foxmail.com
# Created Time: Fri 20 Jul 2018 01:31:44 PM CST
#########################################################################
#!/bin/bash

data_dir=/data/liucj/wxs/liujy/Project_C0571180007/wxs-result

avinputs=`find ${data_dir} -name "*avinput"`

for av in ${avinputs};
do
    grep "chrX" ${av} | grep "0/1" > ${av}.01
    grep "chrX" ${av} | grep "1/1" > ${av}.11
done