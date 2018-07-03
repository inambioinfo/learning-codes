#!/usr/bin/python
#-*- coding:utf-8 -*-
################################################
#File Name: index.py
#Author: C.J. Liu
#Mail: samliu@hust.edu.cn
#Created Time: Fri 10 Apr 2015 01:29:28 PM CST
################################################

'''create index for the dbsnp'''
'''input file is the dbsnp.txt from ucsc'''
import os, sys

def create_index(f):
	info = os.stat(f)
	size = info.st_size

	print '#bin\t1000\t%d' %size

	f_h = open(f, 'r')
	
	chr_flag = 'chr1'
	base = 0
	incre = 1000
	loc = 0
	first = 0
	second = int()
	while True:
		line = f_h.readline()
		line = line.rstrip()
		arr = line.split("\t")
		#current byte loc
		loc_tmp = f_h.tell()
		#for different file
		chrom = arr[0]
		start = arr[1]
		
		if chrom == chr_flag:
			dif = int(start) - base 
			if dif <  incre:
				loc = loc_tmp
			else:
				second = loc
				if first != second:
					print "%s\t%d\t%d\t%d" %(chr_flag, base, first, second)
				first = second
				base = int(start) / 1000 * 1000
				loc = loc_tmp
		else:
			
			second = loc
			if first != second:
				print "%s\t%d\t%d\t%d" %(chr_flag, base, first, second)
			
			first = second
			
			chr_flag = chrom
			base = 0
			
			dif = int(start) - base
			if dif <  incre:
				loc = loc_tmp
			else:
				second = loc_tmp
				base = int(start) / 1000 * 1000
				if first != second:
					print "%s\t%d\t%d\t%d" %(chr_flag, base, first, second)
				first = second
				loc = loc_tmp
		if loc_tmp == size:
			break
	f_h.close()

def main():
	snp = sys.argv[1]
	create_index(snp)

if __name__ == '__main__':
	main()
