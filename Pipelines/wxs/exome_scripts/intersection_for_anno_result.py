#!/usr/bin/python
#-*- coding:utf-8 -*-
################################################
#File Name: intersection_for_anno_result.py
#Author: C.J. Liu
#Mail: samliu@hust.edu.cn
#Created Time: Sat 10 Oct 2015 08:36:35 PM CST
################################################

import os, sys
import optparse

def setAndLoc(f):
	'''convert annovar output file to a dict
	key is a string of 1-5 
	value is the file.tell() position'''
	result = dict()
	with open(f,'r') as foo:
		value = foo.tell()
		line = foo.readline()
		while line:
			arr = line.rstrip().split('\t')
			key = '#'.join(arr[0:5])
			result[key] = value
			line = foo.readline()
			value = foo.tell()
	
	
	# tmp = list()
	# for key,val in result.items():
		# tmp.append(val)
	# tmp.sort()
	# print tmp[0]
	# with open(f,'r') as bar:
		# for i in tmp:
			# bar.seek(i)
			# line = bar.readline().rstrip()
			# print line
	return result
		
def intersect(mafs):
	'''mafs is a list contains f,len(mafs)>1;print last file records'''
	setslist = list()
	for maf in mafs:
		setslist.append(setAndLoc(maf))
	
	last = setslist.pop()
	filename = mafs[-1]
	inter = set(last.keys())
	
	it = last
	while it:
		inter = inter & set(it.keys())
		try:
			it = setslist.pop()
		except:
			break
			
	with open(filename,'r') as foo:
		Locs = list()
		for i in inter:
			Locs.append(last[i])
		Locs.sort()
		for i in Locs:
			foo.seek(i)
			line = foo.readline().rstrip()
			print line

def complement(f1,f2):
	'''f1-f2'''
	info1 = setAndLoc(f1)
	info2 = setAndLoc(f2)
	com = set(info1.keys()) - set(info2.keys())
	with open(f1,'r') as foo:
		Locs = list()
		for i in com:
			Locs.append(info1[i])
		Locs.sort()
		for i in Locs:
			foo.seek(i)
			line = foo.readline().rstrip()
			print line	
		
def main():
	usage="""
	Task: To get intersection and complementary record from annovar output files; use 1-5 column identifiers
	usage: 
	"""
	parser = optparse.OptionParser(usage)
	pass
	

if __name__ == '__main__':
	sys.argv.pop(0)
	intersect(sys.argv)
	#complement(sys.argv[1],sys.argv[2])
	
