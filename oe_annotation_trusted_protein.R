#########################################################################################################
# Rscript function: 欧易注释文件处理脚本——处理欧易来的项目注释文件：gene_annotation.xlsx
# Version: v1.0
# Author: jingxinxing
# New:
# Usage: 1.自动处理——已经串到欧易来的背景文件项目的分析流程中，此步骤不需要考虑；
#        2.手动处理——在项目路径下分析目录4.annotation中，直接运行runoeanno即可
#########################################################################################################
#
## 计时
pt=proc.time()
print("脚本执行时间：")
Sys.time()

## 1.设置当前的工作目录
setwd("./")

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

## 4.读取数据
### 4.1 读取背景文件中的gene_annotation.xls文件
gene_anno <- read.csv("../2.background/gene_annotation.xls", sep = "\t", header = T)
dim(gene_anno)
# [1] 46558     7

colnames(gene_anno)
# [1] "id"                  "gene_symbol"         "Description"
# [4] "GO_id"               "GO_term"             "pathway"
# [7] "pathway_description"

### 4.2 修改蛋白ID列的列名为Protein_id，小写的gene_symbol修改为大小的Gene_symbol，其余列名保持不变
colnames(gene_anno) <- c("Protein_id", "Gene_symbol", "Description", "GO_id", "GO_term", "pathway", "pathway_description")

### 4.3 读取目录1.dep中的差异蛋白/位点/肽段中的可信蛋白/位点/肽段数据
# dep_trusted <- read.xlsx("差异蛋白筛选结果.xlsx", sheet = "可信蛋白", startRow = 1, colNames = TRUE, rowNames = FALSE, detectDates = FALSE)
# dim(dep_trusted)
# # [1] 4506   31

dep <- list.files(path = "../1.dep/", pattern = "^差异蛋白筛选结果")
des <- list.files(path = "../1.dep/", pattern = "^差异位点筛选结果")
depep <- list.files(path = "../1.dep/", pattern = "^差异肽段筛选结果")
print(dep)
print(des)
print(depep)

#!
if (length(dep) == 1) {
  if ("合并可信蛋白" %in% readxl::excel_sheets("../1.dep/差异蛋白筛选结果.xlsx") == TRUE){
    dep_data_trusted <- read.xlsx("../1.dep/差异蛋白筛选结果.xlsx", sheet = "合并可信蛋白", startRow = 1, colNames = TRUE, rowNames = FALSE, detectDates = FALSE)
    print("合并可信蛋白原始数据大小为：")
    dim(dep_data_trusted)
    row.names(dep_data_trusted) <- dep_data_trusted$Accession
    accession <- row.names(dep_data_trusted)
    length(accession)
    class(accession)
    accession_df <- as.data.frame(accession)
    dim(accession_df)
    head(accession_df)
    colnames(accession_df) <- c("Accession")
    head(accession_df)
  } else if ("可信蛋白" %in% readxl::excel_sheets("../1.dep/差异蛋白筛选结果.xlsx") == TRUE){
    dep_data_trusted <- read.xlsx("../1.dep/差异蛋白筛选结果.xlsx", sheet = "可信蛋白", startRow = 1, colNames = TRUE, rowNames = FALSE, detectDates = FALSE)
    print("可信蛋白原始数据大小为：")
    dim(dep_data_trusted)
    row.names(dep_data_trusted) <- dep_data_trusted$Accession
    accession <- row.names(dep_data_trusted)
    length(accession)
    class(accession)
    accession_df <- as.data.frame(accession)
    dim(accession_df)
    head(accession_df)
    colnames(accession_df) <- c("Accession")
    head(accession_df)
  } else if ("总可信蛋白" %in% readxl::excel_sheets("../1.dep/差异蛋白筛选结果.xlsx") == TRUE ){
    dep_data_trusted <- read.xlsx("../1.dep/差异蛋白筛选结果.xlsx", sheet = "总可信蛋白", startRow = 1, colNames = TRUE, rowNames = FALSE, detectDates = FALSE)
    print("可信蛋白原始数据大小为：")
    dim(dep_data_trusted)
    row.names(dep_data_trusted) <- dep_data_trusted$Accession
    accession <- row.names(dep_data_trusted)
    length(accession)
    class(accession)
    accession_df <- as.data.frame(accession)
    dim(accession_df)
    head(accession_df)
    colnames(accession_df) <- c("Accession")
    head(accession_df)
  }
} else if (length(des) == 1) {
  dep_data_trusted <- read.xlsx("../1.dep/差异位点筛选结果.xlsx", sheet = "可信位点", startRow = 1, colNames = TRUE, rowNames = FALSE, detectDates = FALSE)
  print("可信位点原始数据大小为：")
  dim(dep_data_trusted)
  #
  if ("Accession" %in% colnames(dep_data_trusted) == TRUE){
    accession <- unique(dep_data_trusted$Accession)
  } else if ("Protein" %in% colnames(dep_data_trusted) == TRUE){
    accession <- unique(dep_data_trusted$Protein)
  } else if ("Proteins" %in% colnames(dep_data_trusted) == TRUE){
    accession <- unique(dep_data_trusted$Proteins)
  }
  #
  class(accession)
  accession_df <- as.data.frame(accession)
  dim(accession_df)
  head(accession_df)
  colnames(accession_df) <- c("Accession")
  head(accession_df)
  ## 蛋白列去重
} else if (length(depep) == 1 ) {
  dep_data_trusted <- read.xlsx("../1.dep/差异肽段筛选结果.xlsx", sheet = "可信肽段", startRow = 1, colNames = TRUE, rowNames = FALSE, detectDates = FALSE)
  print("可信肽段原始数据大小为：")
  dim(dep_data_trusted)
  #
  # for ( i in c("Accession","Protein","Proteins")){
  #   rownames(dep_data_trusted) <- dep_data_trusted$i
  #   print(i)
  #   print(dep_data_trusted[1:5,1:5])
  # }
  #
  if ("Accession" %in% colnames(dep_data_trusted) == TRUE){
    accession <- unique(dep_data_trusted$Accession)
  } else if ("Protein" %in% colnames(dep_data_trusted) == TRUE){
    accession <- unique(dep_data_trusted$Protein)
  } else if ("Proteins" %in% colnames(dep_data_trusted) == TRUE){
    accession <- unique(dep_data_trusted$Proteins)
  }
  #
  class(accession)
  accession_df <- as.data.frame(accession)
  dim(accession_df)
  head(accession_df)
  colnames(accession_df) <- c("Accession")
  head(accession_df)
}

### 4.4 数据结构转换为数据框
dep_trusted_id <- accession_df
NROW(dep_trusted_id)
# [1] 4506

head(dep_trusted_id)
#   dep_trusted$Accession
# 1          MD00G1002100
# 2          MD00G1003800
# 3          MD00G1004100
# 4          MD00G1004200
# 5          MD00G1005600
# 6          MD00G1007800

### 4.5 修改数据框列名
colnames(dep_trusted_id) <- "Accession"

head(dep_trusted_id)
#      Accession
# 1 MD00G1002100
# 2 MD00G1003800
# 3 MD00G1004100
# 4 MD00G1004200
# 5 MD00G1005600
# 6 MD00G1007800

### 4.6 根据蛋白ID进行数据合并
dep_trusted_anno <- merge.data.frame(x = dep_trusted_id, y = gene_anno, by.x = "Accession", by.y = "Protein_id", all.x = TRUE)

dim(dep_trusted_anno)
# [1] 4506    7

### 4.7 再次修改合并后的数据框的列名
colnames(dep_trusted_anno) <- c("Protein_id", "Gene_symbol", "Description", "GO_id", "GO_term", "pathway", "pathway_description")

### 4.8 查看数据框的行数和列数
print("可信蛋白的注释文件大小为：")
print(paste0("行数为：",NROW(dep_trusted_anno)))
print(paste0("列数为：",NCOL(dep_trusted_anno)))

## 5.保存结果文件
write.xlsx(dep_trusted_anno, file = "annotation.xlsx", borders = "columns", firstRow = T, zoom = 120)

## 6.结束
print("输出数据处理和绘图所需R包名称、版本和环境变量信息：")
sessionInfo()

## 7.分析完成进度条
ppbb <- progress_bar$new(
  format = "  完成百分比 [:bar] :percent",
  total = 1000, clear = FALSE, width= 100)
for (i in 1:1000) {
  ppbb$tick()
  Sys.sleep(1 / 1000)
}

## 8.脚本运行的时间
print("脚本运行时间为：")
proc.time()-pt
