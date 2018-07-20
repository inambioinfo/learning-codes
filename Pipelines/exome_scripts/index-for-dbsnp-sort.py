#!/usr/bin/python
#-*- coding:utf-8 -*-
################################################
#File Name: index-for-dbsnp-sort.py
#Author: C.J. Liu
#Mail: samliu@hust.edu.cn
#Created Time: Mon 13 Apr 2015 08:26:29 PM CST
################################################


import sys, os
'''There are lots of genome assembly patches in the dbsnp file, for example chr17_gl000203_random; i extract major chromosome for hg19. sort the size of idx and idx.sort is different'''

chrom = ['chr' + str(i) for i in range(1,23)]
chrom.extend(['chrX', 'chrY', 'chrM'])

idx = sys.argv[1]
foo = open(idx, 'r')
first = foo.readline().rstrip()
print first
foo.close()

for it in chrom:

	foo = open(idx, 'r')	
	for line in foo:
		if line.startswith('#'): continue
		line = line.rstrip()
		arr = line.split("\t")
		if it == arr[0]:
			print line
		
			
	
	#print '----' * 10, it





