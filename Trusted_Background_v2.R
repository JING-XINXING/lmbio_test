########################################################################################################
# Rscript function: According to project trusted proteins "Accession" obtain Trusted_Background, just 
#                        trusted protein of GO/KEGG backgroud information
# Author: jingxinxing
# Date: 2019/08/16
# Version: v2
# Usage:
#
########################################################################################################
#
pt=proc.time()
## 1.设置当前工作目录
# setwd("./Background")
setwd("./")
list.files()

## 2.导入R包
anp <- c("openxlsx", "readxl")
sapply(anp, library, character.only = TRUE)

## 3.读取数据和数据处理.对可信蛋白数据进行提取和处理
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
## 
if ("MIX" %in% colnames(trusted_prot) == TRUE){
  trusted_prot$MIX <- NULL
}else if ("Mix" %in% colnames(trusted_prot) == TRUE){
  trusted_prot$Mix <- NULL
}else {#else if (length(colnames(trusted_prot)) != 0){
  print("查看处理过MIX/Mix问题后的可信蛋白数据大小：")
  dim(trusted_prot)
}
head(rownames(trusted_prot))

### 3.1获取可信蛋白的Accession信息
row.names(trusted_prot) <- trusted_prot$Accession
accession <- row.names(trusted_prot)
length(accession)
class(accession)
accession_df <- as.data.frame(accession)
dim(accession_df)
head(accession_df)
colnames(accession_df) <- c("Accession")
head(accession_df)
class(accession_df)

### 3.2读取项目key5.xls文件
setwd("./Background")
key5name <- list.files(path = "./", pattern = "key5*")
print(key5name)
# [1] "key5.xls"
key5 <- read.csv(key5name, sep = "\t", header = T)
dim(key5)
ak <- merge.data.frame(accession_df, key5, by.x = "Accession", by.y = "Entry", all.x = T)
dim(ak)

### 3.3读取物种背景文件
#### 3.3.1 gene_anno-kegg.backgroud.xls
kegganbg <- read.csv("gene_anno-kegg.backgroud.xls", sep = "\t", header = F)
dim(kegganbg)
colnames(kegganbg)
aka <- merge.data.frame(ak, kegganbg, by.x = "combine", by.y = "V1", all.x = T)
dim(aka)
aka$Accession <- NULL
aka$GeneID <- NULL
aka$Gene_Name <- NULL
aka$Product <- NULL
colnames(aka) <- NULL

#### 3.3.2 gene_go.backgroud.xls
gobg <- read.csv("gene_go.backgroud.xls", sep = "\t", header = F)
dim(gobg)
colnames(gobg)
# [1] "V1" "V2" "V3"
akg <- merge.data.frame(ak, gobg, by.x = "combine", by.y = "V1", all.x = T)
dim(akg)
akg$Accession <- NULL
akg$GeneID <- NULL
akg$Gene_Name <- NULL
akg$Product <- NULL
colnames(akg) <- NULL

#### 3.3.3 gene_kegg.backgroud.xls
keggbg <- read.csv("gene_kegg.backgroud.xls", sep = "\t", header = F)
dim(keggbg)
colnames(keggbg)
# [1] "V1" "V2" "V3"

akk <- merge.data.frame(ak, keggbg, by.x = "combine", by.y = "V1", all.x = T)
dim(akk)

akk$Accession <- NULL
akk$GeneID <- NULL
akk$Gene_Name <- NULL
akk$Product <- NULL
colnames(akk) <- NULL

## 4.保存结果
setwd("../")
dir.create("./Trusted_Background")
setwd("./Trusted_Background")
write.table(aka, file = "gene_anno-kegg.backgroud.xls", sep = "\t", row.names = F, col.names = F)
write.table(akg, file = "gene_go.backgroud.xls", sep = "\t", row.names = F, col.names = F)
write.table(akk, file = "gene_kegg.backgroud.xls", sep = "\t", row.names = F, col.names = F)
dir()

## 5.结束
sessionInfo()
print("脚本运行时间为：")
proc.time()-pt
