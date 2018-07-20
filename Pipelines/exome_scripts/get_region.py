#!/usr/bin/python
#-*- coding:utf-8 -*-
################################################
#File Name: get_region.py
#Author: C.J. Liu
#Mail: samliu@hust.edu.cn
#Created Time: Tue 19 May 2015 07:28:33 PM CST
################################################
import sys
import os
import json
def get_out(f):
	f_h = open(f, 'r')
	# print os.getcwd()
	# print os.path.split(os.path.realpath(sys.argv[0]))[0]
	try :
		region = json.load(open('region.txt','r'))
	except:
		region = json.load(open(os.path.split(os.path.realpath(sys.argv[0]))[0] + os.sep + 'region.txt','r'))
	# region = {
			# 'chr6': [46200000, 57000000],
			# 'chr7': [54000000, 58000000],
			# 'chr11': [31000000, 36400000],
			# 'chr13': [79000000, 110300000],
			# 'chr15': [19000000, 25700000]
			# }
	#print region
	
	for line in f_h:
		line = line.rstrip()
		arr = line.split('\t')
		if arr[0] not in region.keys():
			continue
		else:
			arr[1] = int(arr[1])
			if arr[1] < region[arr[0]][0] or arr[1] > region[arr[0]][1]:
				continue
			else:
				print line		
	f_h.close()
		



if __name__ == '__main__':
	get_out(sys.argv[1])
