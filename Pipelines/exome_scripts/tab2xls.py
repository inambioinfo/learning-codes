#!/usr/bin/python
#-*- coding:utf-8 -*-
################################################
#File Name: tab_to_xls.py
#Author: C.J. Liu
#Mail: samliu@hust.edu.cn
#Created Time: Thu 21 May 2015 11:17:12 PM CST
################################################

import os,sys
import xlwt

f = open(sys.argv[1], 'r')
row = 0

workbook = xlwt.Workbook(encoding = 'utf-8')
worksheet = workbook.add_sheet('sheet 1')

for line in f:
	line = line.rstrip()
	arr = line.split('\t')
	for col in range(0,len(arr)):
		try:
			worksheet.write(row, col, label = arr[col])	
		except:
			pass
	row += 1

workbook.save(sys.argv[1] + '.xls')
f.close()
