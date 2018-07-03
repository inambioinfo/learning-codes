#!/usr/bin/python
#coding=utf-8
################################################
#File Name: seminar.schedule.py
#Author: C.J. Liu
#Mail: samliu@hust.edu.cn
#Created Time: Mon 09 Mar 2015 12:47:37 PM CST
################################################
import datetime, calendar, time
import string
import random


'''for seminar schedule'''

def getNameList():
	nameList = list()
	print 'Input your name list'
	getName = raw_input('Input Chinese name with space sperated>>')
	nameList = getName.split(" ")
	random.shuffle(nameList)
	return nameList


def getTime():
	birthLine = raw_input('Input birth time in the form of "Y-M-D">>')
	year, month, day = birthLine.split('-')
	birthLine = datetime.date(int(year), int(month), int(day))
	
	deadLine = raw_input('Input dead time in the form of "Y-M-D">>')
	year, month, day = deadLine.split('-')
	deadLine = datetime.date(int(year), int(month), int(day))

	return birthLine, deadLine

def getRandom(birthLine, deadLine, nameList):
	today = birthLine
	delta = datetime.timedelta(days = 7)

	myList = nameList
	tmpNameList = myList[:]

	times = 0
	number = len(myList)

	half = number / 2 
	if number % 2 == 0:
		

		while 1:
			if deadLine < today:
				break
			times += 1

			if times % half  == 1:
				tmpNameList = myList[:]
				random.shuffle(tmpNameList)
			
			first = tmpNameList.pop()
			second = tmpNameList.pop()

			print times, today, first, second
			
			today +=  delta
		
		for i in tmpNameList:
			rand = random.randint(1, times)
			print rand, i
	else:	
		flag = 0
		while 1:
			if deadLine < today:
				break
			times += 1

			if times % half == 1:
				tmpNameList = myList[:]
				random.shuffle(tmpNameList)
				flag += 1

			if times % half == 0:
				print times, today, tmpNameList.pop(), tmpNameList.pop(), tmpNameList.pop()
			else:
				print times, today, tmpNameList.pop(), tmpNameList.pop()

			today += delta
		for i in tmpNameList:
			rand = random.randint(half * (flag - 1), times)
			print rand, i
			
			

if __name__ == '__main__':
	nameList = getNameList()
		
	birthLine, deadLine = getTime()
	getRandom(birthLine, deadLine, nameList)

