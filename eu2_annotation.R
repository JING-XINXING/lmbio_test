########################################################################################################
# Rscript funtion: Produce eucaryote 2 annotation.xlsx file
# Author: jingxinxing
# Date: 2019/12/30
# Version: v6
# Usage: runeu2
# News: 执行本脚本需要在/项目路径/4.annotation内
########################################################################################################
## 计时
pt=proc.time()

## 1.设置当前的工作目录
setwd("./")

## 2.导入R包
library("openxlsx")
library("readxl")
library("stringr")

## 3.读取数据
dep <- list.files(path = "../1.dep/", pattern = "^差异蛋白筛选结果")
des <- list.files(path = "../1.dep/", pattern = "^差异位点筛选结果")
depp <- list.files(path = "../1.dep", pattern = "^差异肽段筛选结果")
print(dep)
print(des)
print(depp)

#udname <- list.files(path = "./", pattern = "^Uniprot*") ## Uniprot_human_20190805.xlsx
#ndname <- list.files(path = "./", pattern = "^ncbi*") ## ncbi_human_20190805.xlsx
#if (length(udname) == 1){
#print(udname)
#un_data <- read.xlsx(udname, sheet = 1, startRow = 1, colNames = T, rowNames = F, detectDates = F)
#dim(un_data)
#head(un_data)
#colnames(un_data) <- c("Entry", "Product", "GeneID", "Gene_Name")
#} else if (length(udname) == 0) {
#  un_data <- read.xlsx(ndname, sheet = 1, startRow = 1, colNames = T, rowNames = F, detectDates = F)
#  dim(un_data)
#  head(un_data)
#  colnames(un_data) <- c("Entry", "GeneID", "Gene_Name", "Product")
#}

### 3.1读取“差异蛋白筛选结果.xlsx”文件中的可信蛋白（sheet=可信蛋白）
if (length(dep) == 1) {
  if ("合并可信蛋白" %in% readxl::excel_sheets("../1.dep/差异蛋白筛选结果.xlsx") == TRUE){
    dep_data_raw1 <- read.xlsx("../1.dep/差异蛋白筛选结果.xlsx", sheet = "原始数据1", startRow = 1, colNames = TRUE, rowNames = FALSE, detectDates = FALSE)
    dep_data_raw2 <- read.xlsx("../1.dep/差异蛋白筛选结果.xlsx", sheet = "原始数据2", startRow = 1, colNames = TRUE, rowNames = FALSE, detectDates = FALSE)
    dep_acc_raw1 <- as.data.frame(dep_data_raw1$Accession)
    dep_acc_raw2 <- as.data.frame(dep_data_raw2$Accession)
    colnames(dep_acc_raw1) <- c("Accession")
    colnames(dep_acc_raw2) <- c("Accession") 
    dep_acc_all <- rbind(dep_acc_raw1, dep_acc_raw2)
    colnames(dep_acc_all) <- c("Accession")
    dep_acc_all <- dep_acc_all[!duplicated(dep_acc_all$Accession),]
    dep_acc_all <- as.data.frame(dep_acc_all)
    colnames(dep_acc_all) <- c("Accession")
    print("合并原始数据蛋白个数为：")
    NROW(dep_acc_all)
    head(dep_acc_all)
    if ("原始数据3" %in% readxl::excel_sheets("../1.dep/差异蛋白筛选结果.xlsx") == TRUE) {
      dep_data_raw3 <- read.xlsx("../1.dep/差异蛋白筛选结果.xlsx", sheet = "原始数据3", startRow = 1, colNames = TRUE, rowNames = FALSE, detectDates = FALSE)
      dep_acc_raw3 <- as.data.frame(dep_data_raw3$Accession)
      colnames(dep_acc_raw3) <- c("Accession")
      dep_acc_all <- rbind(dep_acc_all, dep_acc_raw3)
      dep_acc_all <- as.data.frame(dep_acc_all)
      colnames(dep_acc_all) <- c("Accession")
      dep_acc_all <- dep_acc_all[!duplicated(dep_acc_all$Accession),]
      dep_acc_all <- as.data.frame(dep_acc_all)
      colnames(dep_acc_all) <- c("Accession")
      print("合并原始数据蛋白个数为：")
      NROW(dep_acc_all)
      head(dep_acc_all)
    }
  } else if ("原始数据" %in% readxl::excel_sheets("../1.dep/差异蛋白筛选结果.xlsx") == TRUE) {
    dep_data_raw <- read.xlsx("../1.dep/差异蛋白筛选结果.xlsx", sheet = "原始数据", startRow = 1, colNames = TRUE, rowNames = FALSE, detectDates = FALSE)
    dep_acc_all <- as.data.frame(dep_data_raw$Accession)
    colnames(dep_acc_all) <- c("Accession")
    dep_acc_all <- dep_acc_all[!duplicated(dep_acc_all$Accession),]
    dep_acc_all <- as.data.frame(dep_acc_all)
    colnames(dep_acc_all) <- c("Accession")
    print("原始数据蛋白个数为：")
    NROW(dep_acc_all)
    head(dep_acc_all)
  }
} else if (length(des) == 1) {
  des_data_raw <- read.xlsx("../1.dep/差异位点筛选结果.xlsx", sheet = "原始数据", startRow = 1, colNames = TRUE, rowNames = FALSE, detectDates = FALSE)
  print("原始数据蛋白个数为：")
  des_acc_all <- as.data.frame(des_data_raw$Accession)
  colnames(dep_acc_all) <- c("Accession")
  dep_acc_all <- dep_acc_all[!duplicated(dep_acc_all$Accession),]
  dep_acc_all <- as.data.frame(dep_acc_all)
  colnames(dep_acc_all) <- c("Accession")
  print("原始数据蛋白个数为：")
  NROW(dep_acc_all)
  head(dep_acc_all)
} else if (length(depp) == 1) {
  depp_data_raw <- read.xlsx("../1.dep/差异肽段筛选结果.xlsx", sheet = "原始数据", startRow = 1, colNames = TRUE, rowNames = FALSE, detectDates = FALSE)
  print("原始数据蛋白个数为：")
  depp_acc_all <- as.data.frame(depp_data_raw$Accession)
  colnames(dep_acc_all) <- c("Accession")
  dep_acc_all <- dep_acc_all[!duplicated(dep_acc_all$Accession),]
  dep_acc_all <- as.data.frame(dep_acc_all)
  colnames(dep_acc_all) <- c("Accession")
  print("原始数据蛋白个数为：")
  NROW(dep_acc_all)
  head(dep_acc_all)
}

### 3.2读取富集的GO数据
goname <- list.files(path = "../2.background/GO", pattern = "*GO.gene.anno.xls")
print(goname)
gobg <- read.csv(paste0("../2.background/GO/",goname), sep = "\t", header = T)
dim(gobg)
head(gobg)
colnames(gobg) <- c("Accession", "GO_id", "GO_annotation")
head(gobg)
dim(gobg)

### 3.4读取富集的KEGG数据
keggname <- list.files(path = "../2.background/KEGG", pattern = "*KEGG.gene.anno.xls")
print(keggname)
keggbg <- read.csv(paste0("../2.background/KEGG/",keggname), sep = "\t", header = T)
head(keggbg)
colnames(keggbg) <- c("Accession", "e_value", "identity", "Database_GeneID", "KO", "gene_name", "Description", "Pathway", "Pathway_definition")
head(keggbg)
dim(keggbg)

### 3.5读取PFAM数据
pf <- read.xlsx("/public/hstore5/proteome/pipeline/script/project_result_system/pfam_all.xlsx", sheet = "pfam", startRow = 1, colNames = T, rowNames = F, detectDates = F)
dim(pf)
# [1] 519367      4

### 3.6读取富集的KOG（真核生物）/COG（原核生物）数据
kogname <- list.files(path = "../2.background/KOG", pattern = "*.KOG.gene.anno.xls$")
kogname
kog <- read.csv(paste0("../2.background/KOG/",kogname), sep = "\t", header = T)
dim(kog)
colnames(kog)
colnames(kog) <- c("Entry", "Portein_name_in_KOG", "E.value", "Identity", "Score", "Organism", "KOG_id", "KOG_description", "KOG_abbreviation", "Functional.categories", "KOG_function_class")

### 3.7读取eggNOG数据
eu_eggNOG <- read.xlsx("/public/hstore5/proteome/pipeline/script/project_result_system/eggNOG_new.xlsx", sheet = "真核", startRow = 1, colNames = T, rowNames = F, detectDates = F)
dim(eu_eggNOG)
head(eu_eggNOG)
nog_anno <- read.table("/public/hstore5/proteome/pipeline/script/project_result_system/NOG.annotations.txt", sep = "\t", header = T, row.names = 1)
dim(nog_anno)
head(nog_anno)
eu_anno <- merge.data.frame(eu_eggNOG, nog_anno, by.x = "eggNOG_id", by.y = "eggNOG_id", all.x = T, all = F)
head(eu_anno)
dim(eu_anno)
fun_clas <- read.xlsx("/public/hstore5/proteome/pipeline/script/project_result_system/eggNOG_new.xlsx", sheet = "function", startRow = 1, rowNames = F, colNames = T, detectDates = F)
dim(fun_clas)
# [1] 25  2
head(fun_clas)
class(fun_clas)
eu_eggNOG_new <- merge(eu_anno, fun_clas, by.x = "eggNOG_abbreviation", by.y = "eggNOG_abbreviation", all.x = T)
dim(eu_eggNOG_new)
head(eu_eggNOG_new)

### 3.8读取swissprot数据
stname <- list.files(path = "../2.background/Swissprot", pattern = "*anno*")
print(stname)
# [1] "alsp.Swissprot.blast.best.anno.xls"

st_data <- read.csv(paste0("../2.background/Swissprot/",stname), sep = "\t", header = T)
# print(st_data)
head(st_data)
dim(st_data)
# [1] 1174    6
colnames(st_data)

colnames(st_data) <- c("Accession", "Swissprot_id", "E_value", "Identity", "Score", "Swissprot_annotation")
st_data$Swissprot_id <- as.character(st_data$Swissprot_id)
test3 <- substr(st_data$Swissprot_id, 4,9)
head(test3)
class(test3)
dim(test3)
length(test3)
test3 <- as.data.frame(test3)
dim(test3)
colnames(test3) <- c("Swissprot_ID")
head(test3)
st_data_new <- cbind.data.frame(st_data, test3)
dim(st_data_new)
st_data_new <- as.data.frame(st_data_new)

## 4.数据处理（根据可信蛋白ID或名称合并Merge各个含富集信息的数据框）
#eggp <- merge(accession_df, un_data, by.x = "Accession", by.y = "Entry", all.x = T) ## eggp 是各个列名的首字母Entry, GeneID、Gene_Name和Product
#dim(eggp)
#head(eggp)
#colnames(eggp)
# [1] "Accession" "Product"   "GeneID"    "Gene_Name"

### 4.1 GO和KEGG数据合并
GK <- merge.data.frame(gobg, keggbg, by.x = "Accession", by.y = "Accession", all.x = T, all = F)
dim(GK)

### 4.2 GK和pfam数据合并
GKP <- merge.data.frame(GK, pf, by.x = "Accession", by.y = "Entry", all.x = T, all = F)
dim(GKP)

### 4.3 原始蛋白Accession和GKP合并
annotation <- merge.data.frame(dep_acc_all, GKP, by.x = "Accession", by.y = "Accession", all.x = T)
dim(annotation)
colnames(annotation)

annotation_new <- merge.data.frame(annotation, kog, by.x = "Accession", by.y = "Entry", all.x = T)
dim(annotation_new)
colnames(annotation_new)

annotation_new2 <- merge.data.frame(annotation_new, eu_eggNOG_new, by.x = "Accession", by.y = "Entry", all.x = T)

dim(annotation_new2)

colnames(annotation_new2)

# colnames(annotation_new2) <- c("Accession", "GO_id", "GO_annotation", "Pathway", "Pathway_definition", "pfam", "PFAM_Name", "PFAM_description", "Portein_name_in_KOG", "E.value", "Identity", "Score", "Organism", "KOG_id", "KOG_description", "KOG_abbreviation", "KOG_Functional.categories", "KOG_function_class", "eggNOG_abbreviation", "eggNOG_id", "eggNOG_description", "eggNOG_function_class")
colnames(annotation_new2) <- c("Accession", "GO_id", "GO_annotation", "e_value", "identity", "Database_GeneID", "KO", "gene_name", "Description", "Pathway", "Pathway_definition", "pfam", "PFAM_Name", "PFAM_description", "Portein_name_in_KOG", "E.value", "Identity", "Score", "Organism", "KOG_id", "KOG_description", "KOG_abbreviation", "KOG_Functional.categories", "KOG_function_class", "eggNOG_abbreviation", "eggNOG_id", "eggNOG_description", "eggNOG_function_class")

annotation_new3 <- merge.data.frame(st_data_new, annotation_new2, by.x = "Accession", by.y = "Accession", all = T)
dim(annotation_new3)

## 自定义匹配数据的列名
anno_col <- c("Accession", "Swissprot_ID",	"Swissprot_annotation", "GO_annotation",	"Pathway",	"Pathway_definition",	"KOG_id",	"KOG_abbreviation",	"KOG_description", "KOG_function_class",	"eggNOG_id",	"eggNOG_abbreviation",	"eggNOG_description",	"eggNOG_function_class",	"pfam",	"PFAM_Name",	"PFAM_description")

annoma <- match(anno_col, colnames(annotation_new3))
annoma
annotation_NEW <- annotation_new3[,annoma]
dim(annotation_NEW)
colnames(annotation_NEW)

## 5.保存数据
# annotation_NEW <- annotation_NEW[!duplicated(annotation_NEW$Entry),]
write.xlsx(annotation_NEW, file = "annotation.xlsx")

## 6.结束
print("输出数据处理和绘图所需R包名称、版本和环境变量信息：")
sessionInfo()
print("脚本运行时间为：")
proc.time()-pt
