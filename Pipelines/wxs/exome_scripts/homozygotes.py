#!/usr/bin/python
#-*- coding:utf-8 -*-
################################################
#File Name: homozygotes.py
#Author: C.J. Liu
#Mail: samliu@hust.edu.cn
#Created Time: Wed 20 May 2015 04:40:08 PM CST
################################################


import os, sys

f = open(sys.argv[1])
seq = f.readlines()
f.close()
j = 0
for i in range(0, len(seq)):
	line = seq[i].rstrip()
	arr = line.split('\t')
	#11 is genotyp
	#15 is ensembl id
	if i < j: continue
	if arr[10] == '1/1':
		print line
	if arr[10] == '0/1':
		flag = 0
		for j in range(i+1, i+1000):
			rec = seq[j].rstrip()
			rec_arr = rec.split('\t')
			if arr[14] == rec_arr[14]:
				if rec_arr[10] == '0/1':
					flag += 1
					print rec
				if rec_arr[10] == '1/1':
					print rec
			else:
				break

		if flag != 0:
			print line
			




