########################################################################################################
# Python script: 生成项目分析的目录结构
# Data: 2019/09/18
# Author: jingxinxing
# Version: 2
# Usage: 1.在项目路径下执行python start_analysis.py --exclude=1,2,3,4,5,6,7（不需要的目录，就排除，不生成）；
#        2.目录：1.dep
#		 2.background'
#		 3.enrichment
#		 4.annotation
#		 5.result
#		 6.report
########################################################################################################
#!/usr/bin/python
#coding=utf8
# -*- coding: UTF-8 -*-
import os
import time
import argparse
import configparser

localtime = time.asctime( time.localtime(time.time()) )
print ("新建项目分析目录的时间为 :", localtime)

parser=argparse.ArgumentParser(description='Protein analysis pipeline')
parser.add_argument('--exclude',help='the analysis to exclude',metavar='')

#argv
argv=parser.parse_args()
rootdir=os.getcwd()
exclude=argv.exclude

if exclude != None:
	exclude=exclude.strip().split(',')
if exclude == None:
	exclude=[]

include={'1':'1.dep','2':'2.background','3':'3.enrichment','4':'4.annotation','5':'5.result','6':'6.report','7':'7.script'}

#mkdir 
os.system('mkdir -p %s/rawdata' %(rootdir))
# os.system('mkdir -p %s/7.script' %(rootdir))
for each in include:
	if each not in exclude:
		os.system('mkdir -p %s/%s' %(rootdir,include[each]))

if exclude==[]:
	excludes=exclude
else:
	excludes=','.join(exclude)
# END
print("您所需要的目录结构已经建立，请查看：")
