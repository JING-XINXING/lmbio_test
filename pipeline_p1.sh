#!/bin/bash
########################################################################################################
# Pipeline1: 蛋白分析流程头部，包括质谱原始数据读取、筛选、分析和绘图，简称P1
# Version: v2.6
# Date: 2019/12/30
# New: 
# Usage: RUNP1
########################################################################################################
echo "RUNP1执行时间为："
date
###################################################
## 1.参数
foldchange="1.5"
project_type="single_mark"
method="None"
project_path=`pwd` # 获取项目路径
unionplot_parameter="h" # 此参数为了绘制只有一个比较组的上下调图，默认参数是不绘制单个比较组的上下调图，需要绘制时就将参数设置为"g"即可
###################################################

## 2.新建项目分析目录
# SA 0
## 在目录1.dep内进行差异蛋白筛选
### 单组标记、Label free、磷酸化项目
echo ${project_path} # 打印项目路径
ls -RF ${project_path}/rawdata # 查看项目路径/rawdata/目录中的内容
cp ./rawdata/*.xlsx ./1.dep # 复制项目原始数据到目录/1.dep中
cp ./rawdata/*.txt ./1.dep # 针对于磷酸化项目的原始数据

### 多组标记项目数据
if find ${project_path}/rawdata/'TMT results 1'
then
	echo "是TMT多组标记"
	cp -r ${project_path}/rawdata/'TMT results 1' ./1.dep
	cp -r ${project_path}/rawdata/'TMT results 2' ./1.dep
	cp -r ${project_path}/rawdata/'TMT results 3' ./1.dep
elif find ${project_path}/rawdata/'iTRAQ results 1'
then
	echo "是iTRAQ多组标记"
	cp -r ${project_path}/rawdata/'iTRAQ results 1' ./1.dep
	cp -r ${project_path}/rawdata/'iTRAQ results 2' ./1.dep
	cp -r ${project_path}/rawdata/'iTRAQ results 3' ./1.dep
else
	echo "不是TMT或iTRAQ多组标记项目"
fi
## 3.切换工作目录
cd ./1.dep
pwd
ls -RF ./
pwd

## 4.差异蛋白筛选
# condaoff 
# source /public/hstore5/proteome/Personal_dir/jingxinxing/software/anaconda3/bin/deactivate
# source /public/hstore5/software/anaconda3/bin/activate # 激活公共anaconda3环境，执行prap3进行差异蛋白/位点筛选
export PATH=/public/hstore5/software/anaconda3/bin/:$PATH # 导入公共anaconda3环境的环境变量

### 单组数据和多组数据的差异蛋白筛选脚本不同，所以这里要判断之后再执行
#
if find ${project_path}/rawdata/'TMT results 1'
then
        echo "是TMT多组标记"
	prap3 -r ${foldchange} -f ${project_type} -e ${method} -i ${project_path}/1.dep
elif find ${project_path}/rawdata/'iTRAQ results 1'
then
        echo "是iTRAQ多组标记"
	prap3 -r ${foldchange} -f ${project_type} -e ${method} -i ${project_path}/1.dep
else
        echo "不是TMT或iTRAQ多组标记项目"
	prap3 -r ${foldchange} -f ${project_type} -e ${method}
fi
#
# prap3 -r ${foldchange} -f ${project_type} -e ${method}

## 5.绘制热图、韦恩图和火山图
# export PATH=/public/hstore5/list/prap/anaconda3/bin/:$PATH
unionplot2m -f ${foldchange}
sleep 3;

### 5.1如果是一个比较组就用下面的命令绘制上下调图
# runprap
source /public/hstore5/software/anaconda3/bin/activate prap # 进入prap环境
unionplot -$unionplot_parameter
source /public/hstore5/software/anaconda3/bin/deactivate prap # 退出prap环境

## 6.R绘图(自动判断项目类型，然后选择用对应的脚本：（iTRAQ,TMT,Label_free）runplo，（DIA）rundiap，（磷酸化项目Phosph）runphosp)
pwd=`pwd`
pwd2=`echo ${pwd:34}`
project_type=`echo ${pwd2%%/*}`

## 激活R绘图环境 ##
source /public/hstore5/proteome/Personal_dir/jingxinxing/software/anaconda3/bin/activate

### 1.项目类型：iTRAQ、TMT
# if [ ${project_type} -eq 'iTRAQ_TMT' ];
#
if [ ${project_type} == 'iTRAQ_TMT' ];
then
	runplo
fi
#
### 2.项目类型：Label_free
# if [ ${project_type} -eq 'Label_free' ];
#
if [ ${project_type} == 'Label_free' ];
then
	runplo
fi
#
### 3.项目类型：DIA
# DIA项目标志文件：数据质控文件.docx和DDA_library.xlsx
# if find ../rawdata/'DDA_library.xlsx' # DIA项目标志文件：数据质控文件.docx和DDA_library.xlsx
# then
# 	rundiap
# fi
# if [ ${project_type} -eq 'DIA' ];
#
if [ ${project_type} == 'DIA' ];
then
	rundiap
fi
#
### 4.项目类型：Phosph
# if find ../rawdata/'Phospho (STY)Sites.txt'
# then
# 	runphosp
# fi
# if [ ${project_type} -eq 'phospho' ];
#
if [ ${project_type} == 'phospho' ];
then
	runphosp
fi
#
### 5.项目类型：Phospho_DIA
#
if [ ${project_type} == 'Phospho_DIA' ];
then
	runphos_dia
fi
#
### 6.项目类型：Acetyla_Labelfree
#
if [ ${project_type} == 'Acetyla_LF' ];
then
        runacetlf
fi
#
echo
echo "恭喜你！蛋白项目分析流程第一阶段RUNP1(P1)——差异蛋白分析及R绘图完成！"
echo "可以进行下一阶段分析RUNP2(P2)——背景文件准备和富集分析"
date
