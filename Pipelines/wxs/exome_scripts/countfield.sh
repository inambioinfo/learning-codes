#########################################################################
# File Name: countfield.sh
# Author: C.J. Liu
# Mail: samliu@hust.edu.cn
# Created Time: Tue 24 Mar 2015 11:50:20 PM CST
#########################################################################
#!/bin/bash



awk -F "\t" '{print NF}' $1
