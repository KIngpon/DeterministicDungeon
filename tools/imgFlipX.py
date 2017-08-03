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
        im = Image.open(path + filename)
		# x = im.size[0]  
		# y = im.size[1]  
		# img = im.load()  
		# c = Image.new("RGB",(x,y))  
		# for i in range (0, x):  
			# for j in range (0, y):  
				# w = x-i-1  
				# h = y-j-1  
			   # rgb = img[w,j] #镜像翻转  
			   # rgb=img[w,h] #翻转180度  
			   # rgv=img[i,h] #上下翻转  
			   # c.putpixel([i,j],rgb) 
		# c.show()  
		# c.save(filename) 
#获取当前目录
d = os.path.dirname(os.getcwd()) + '\\laya\\assets\\icon\\enemy\\'
print "run in document: " + d 
flipImg(str(d))