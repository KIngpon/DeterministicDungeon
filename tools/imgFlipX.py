#! /usr/bin/env python
#coding=utf-8
import Image
import os
import sys
reload(sys)
sys.setdefaultencoding('utf-8')
print sys.getdefaultencoding()
def flipImg(path):
	filesList = os.listdir(path)
	for file in filesList:
		filename = str(file)
		#忽略.开头的文件 ~开头的文件
		if filename.startswith(".") or filename.startswith("~"):
			continue
		if filename.endswith("png") == False:
			continue
		print path + filename
		im = Image.open(path + filename)
		im.transpose(Image.FLIP_LEFT_RIGHT) 
#获取当前目录
d = os.path.dirname(os.getcwd()) + '\\laya\\assets\\icon\\enemy\\'
print "run in document: " + d 
flipImg(str(d))