########################################################################################################
# Rscript function: According to project trusted proteins "Accession" obtain Trusted_Backgroud, just 
#			 trusted protein of GO/KEGG backgroud information
# Author: jingxinxing
# Date: 2019/08/14
# Version: v1
# Usage:
# 
########################################################################################################
# 
pt=proc.time()
## 设置当前工作目录
setwd("./")
## 读取数据和数据处理
### 三个富集分析背景文件：gene_anno-kegg.backgroud_new.xls；gene_go.backgroud_new.xls；gene_kegg.backgroud_new.xls

library("openxlsx")
### 项目路径下新建一个目录：Trusted_Backgroud
### 读取差异蛋白筛选结果中的可信蛋白Accession
# depname <- list.files(path = "./", pattern = "差异蛋白筛选结果.xlsx")
# print(depname)

if ("合并可信蛋白" %in% readxl::excel_sheets("./差异蛋白筛选结果.xlsx") == TRUE){
  trusted_prot <- read.xlsx("./差异蛋白筛选结果.xlsx", sheet = "合并可信蛋白", startRow = 1, colNames = TRUE, rowNames = FALSE, detectDates = FALSE)
  print("合并可信蛋白原始数据大小为：")
  dim(trusted_prot)
}else if ("可信蛋白" %in% readxl::excel_sheets("./差异蛋白筛选结果.xlsx") == TRUE){
  trusted_prot <- read.xlsx("./差异蛋白筛选结果.xlsx", sheet = "可信蛋白", startRow = 1, colNames = TRUE, rowNames = FALSE, detectDates = FALSE)
  print("可信蛋白原始数据大小为：")
  dim(trusted_prot)
} else {
  trusted_prot <- read.xlsx("./差异蛋白筛选结果.xlsx", sheet = "总可信蛋白", startRow = 1, colNames = TRUE, rowNames = FALSE, detectDates = FALSE)
  print("可信蛋白原始数据大小为：")
  dim(trusted_prot)
}
## 数据处理：对可信蛋白数据进行提取和处理
if ("MIX" %in% colnames(trusted_prot) == TRUE){
  trusted_prot$MIX <- NULL
}else if ("Mix" %in% colnames(trusted_prot) == TRUE){
  trusted_prot$Mix <- NULL
}else {#else if (length(colnames(trusted_prot)) != 0){
  print("查看处理过MIX/Mix问题后的可信蛋白数据大小：")
  dim(trusted_prot)
}

accession <- trusted_prot$Accession
accession_df <- as.data.frame(accession)
colnames(accession_df) <- c("Accession")
head(accession_df)

### gene_anno-kegg.backgroud_new.xls >> gene_anno-kegg.backgroud.xls
kegganno <- read.csv("gene_anno-kegg.backgroud.xls", sep = "\t", header = F) # kegg anno > gene_anno-kegg.backgroud_new.xls
dim(kegganno)
# [1] 9315    4

colnames(kegganno)
# [1] "V1" "V2" "V3" "V4"

aka <- merge.data.frame(accession_df, kegganno, by.x = "Accession", by.y = "V1", all.x = T) ## aka >> accession_df kegganno merge

dim(aka)
# [1] 5542    4

colnames(aka) <- NULL

### gene_go.backgroud_new.xls >> gene_go.backgroud.xls
gobg <- read.csv("gene_go.backgroud.xls", sep = "\t", header = F)
dim(gobg)
# [1] 13777     4
ag <- merge.data.frame(accession_df, gobg, by.x = "Accession", by.y = "V1", all.x = T)

dim(ag)
# [1] 5529    4

colnames(ag) <- NULL

### gene_kegg.backgroud_new.xls >> gene_kegg.backgroud.xls
keggbg <- read.csv("gene_kegg.backgroud.xls", sep = "\t", header = F)
dim(keggbg)

ak <- merge.data.frame(accession_df, keggbg, by.x = "Accession", by.y = "V1", all.x = T)
colnames(ak) <- NULL
dim(ak)
# [1] 5542    4

## 保存结果
getwd()
dir.create("Trusted_Backgroud")
setwd("./Trusted_Backgroud")

### gene_kegg.backgroud.xls
write.xlsx(ak, file = "gene_kegg.backgroud.xlsx", colNames = F, rowNames = F)
### gene_go.backgroud.xls
write.xlsx(ag, file = "gene_go.backgroud.xlsx", colNames = F, rowNames = F)
### gene_anno-kegg.backgroud.xls
write.xlsx(aka, file = "gene_anno-kegg.backgroud.xlsx", colNames = F, rowNames = F)

## 结束
sessionInfo()
#
print("脚本运行时间为：")
proc.time()-pt
