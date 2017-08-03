#! /usr/bin/env python
#coding=utf-8
from xml.etree import ElementTree as et
import json
import os
import sys
reload(sys)
sys.setdefaultencoding('utf-8')
print sys.getdefaultencoding()
def xml2json(path):
    filesList = os.listdir(path)
    for file in filesList:
        filename = str(file)
        #忽略.开头的文件 ~开头的文件
        if filename.startswith(".") or filename.startswith("~"):
            continue
        #只取.xlsm文件
        if filename.endswith("xml") == False:
            continue
        #print "filename: " + path + filename
        root = et.parse(path + filename)
        childNodeName = filename.split(".")[0]
        #print childNodeName
        nodeList = []
        f = open(path + childNodeName + ".json", "w")  
        for node in root.getiterator(childNodeName):
            nodeList.append(node.attrib)
        tempJson = json.dumps(nodeList, ensure_ascii=False)
        print tempJson
        f.write(tempJson + "\n")
        f.close() 

#获取当前目录
d = os.path.dirname(os.getcwd()) + '\\table\\cfg\\'
print "run in document: " + d 
xml2json(str(d))