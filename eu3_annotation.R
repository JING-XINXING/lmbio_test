################################################################################################################
# Rscript Function: Produce Protein Project of Eucaryote No-Uniprot Protein Enrichment Annotation Information File
# Date: 2020/04/19
# Author: jingxinxing
# Version: V1.0
# News:
################################################################################################################

## 0.计时
pt=proc.time()
print("脚本执行时间：")
Sys.time()

## 1.设置当前工作目录
getwd0()
setwd("./")
# setwd("D:/工作空间/研发/2020年研发工作目录/2020年4月/项目分析注释文件annotation.xlsx生成脚本升级/1.非Uniprot蛋白登录号用Swissprot登录号注释/")
## 2.导入R包
anp <- c("openxlsx", "readxl", "progress", "stringr")
sapply(anp, library, character.only = TRUE)

## 3.脚本执行进度条
print("分析开始：Start")
ppbb <- progress_bar$new(total = 1000)
for (i in 1:1000) {
  ppbb$tick()
	  Sys.sleep(1 / 1000)
		}
 
## 7.结束
print("输出数据处理和绘图所需R包名称、版本和环境变量信息：")
sessionInfo()

## 8.分析完成进度条
ppbb <- progress_bar$new(
  format = "  完成百分比 [:bar] :percent",
	total = 1000, clear = FALSE, width= 100)
for (i in 1:1000) {
  ppbb$tick()
	Sys.sleep(1 / 1000)
}

## 9.脚本运行的时间
print("脚本运行时间为：")
proc.time()-pt

