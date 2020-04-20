########################################################################################################
# /Rscript funtion: Produce eucaryote annotation.xlsx file
# /Author: jingxinxing
# /Date: 2019/12/30
# /Version: v7
# /New: 1.直接读取富集分析的gene_go.backgroud.xls和gene_kegg.backgroud.xls文件；
#       2.全物种数据eggNOG_new.xlsx、NOG.annotations.txt和pfam_all.xlsx数据的获得是通过绝对路径读取的，
#       不再复制到项目路径下（节省内存资源）
#       3.填加脚本运行的进度条
#	4.执行本脚本需要在/项目路径/4.annotation内	
# 
# /Usage: 本脚本是针对于富集分析第一类型真核生物的，运行方法：runeu
########################################################################################################
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
dep <- list.files(path = "../1.dep/", pattern = "^差异蛋白筛选结果")
des <- list.files(path = "../1.dep/", pattern = "^差异位点筛选结果")
print(dep)
print(des)

### 4.1 区分磷酸化项目和常规标记项目的结果文件进行提取可信蛋白，然后生成可信蛋白注释文件
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

### 4.2 读取物种Uniprot数据库或NCBI数据库中自定义的数据（包括descript、geneid和genename）
un_data <- read.csv("../2.background/pre2.txt", sep = "\t", header = T, fill = T)
dim(un_data)
head(un_data)
colnames(un_data)
# [1]"Entry", "Protein.names", "Cross.reference..GeneID.", "Gene.names...primary.."
colnames(un_data) <- c("Entry", "Protein.names", "Cross.reference.GeneID", "Gene.names.primary")
un_data <- un_data[!duplicated(un_data$Entry),]
### 4.3 读取富集的GO数据
# gobgname <- list.files(path = "./", pattern = "*go.backgroud_new")
# gobg <- read.table(gobgname, sep = "\t")
# dim(gobg)
# colnames(gobg)
# colnames(gobg) <- c("Entry", "Gene.Name", "GO_id", "GO_term")
# 
# gobg_new <- gobg[!duplicated(gobg[,1]),]
# row.names(gobg_new) <- gobg_new[,1]
# NROW(gobg_new)
# 
### 直接读取gene_go.backgroud.xls文件 ###
go_data <- read.table("../3.enrichment/gene_go.backgroud.xls", sep = "\t")
dim(go_data)
# [1] 978   3
colnames(go_data)
class(go_data)
# [1] "data.frame"

GO_PG <- go_data[,1]
# head(GO_PG)
GO_PG <- as.character(GO_PG)

dim(as.data.frame(str_split(GO_PG, ":")))
GO_PG_df <- t(as.data.frame(str_split(GO_PG, ":")))
# head(GO_PG_df)
GO_PG_df <- as.data.frame(GO_PG_df)
dim(GO_PG_df)
# head(GO_PG_df)
row.names(GO_PG_df) <- NULL
head(GO_PG_df)
colnames(GO_PG_df) <- c("Entry", "Gene.Name")
head(GO_PG_df)
colnames(go_data)
#
gobg_new <- cbind(GO_PG_df, go_data) # 合并GO_PG_df和go_data数据
dim(gobg_new)

colnames(gobg_new) <- c("Entry", "Gene.Name", "GO_PG", "GO_id", "GO_term") # GO_PG是指GO背景文件中的“蛋白:基因”这一列的列名

# length(unique(gobg_new[,1])) # 没有重复值

### 4.4 读取富集的KEGG数据
# keggbgname <- list.files(path = "./", pattern = "*kegg.backgroud_new")
# keggbg <- read.table(keggbgname, sep = "\t")
# dim(keggbg)
# colnames(keggbg)
# colnames(keggbg) <- c("Entry", "Gene.Name", "pathway",	"pathway_description")
# keggbg_new <- keggbg[!duplicated(keggbg[,1]),]
# NROW(keggbg_new)
# # [1] 855

### 直接读取gene_kegg.backgroud.xls文件 ###
kegg_data <- read.table("../3.enrichment/gene_kegg.backgroud.xls", sep = "\t")
dim(kegg_data)
# [1] 978   3
colnames(kegg_data)
class(kegg_data )
# [1] "data.frame"

KEGG_PG <- kegg_data[,1]
head(KEGG_PG)
# [1] P07200:TGFB1  O77633:ADAM10 O62807:PPARG  P50578:AKR1A1 P79387:NR5A1
# [6] O62651:WT1
# 978 Levels: A0A059NTB8:BMP5 A0A0G2KBD0:CALCRL ... Q9XSN6:KLK4
KEGG_PG <- as.character(KEGG_PG)
# mode(KEGG_PG)
# [1] "character"

dim(as.data.frame(str_split(KEGG_PG, ":")))
KEGG_PG_df <- t(as.data.frame(str_split(KEGG_PG, ":")))
# head(KEGG_PG_df)
#                       [,1]     [,2]
# c..P07200....TGFB1..  "P07200" "TGFB1"
# c..O77633....ADAM10.. "O77633" "ADAM10"
# c..O62807....PPARG..  "O62807" "PPARG"
# c..P50578....AKR1A1.. "P50578" "AKR1A1"
# c..P79387....NR5A1..  "P79387" "NR5A1"
# c..O62651....WT1..    "O62651" "WT1"
KEGG_PG_df <- as.data.frame(KEGG_PG_df)
dim(KEGG_PG_df)
# head(KEGG_PG_df)
row.names(KEGG_PG_df) <- NULL
# head(KEGG_PG_df)
#       V1     V2
# 1 P07200  TGFB1
# 2 O77633 ADAM10
# 3 O62807  PPARG
# 4 P50578 AKR1A1
# 5 P79387  NR5A1
# 6 O62651    WT1

colnames(KEGG_PG_df) <- c("Entry", "Gene.Name")
head(KEGG_PG_df)
#    Entry Gene.Name
# 1 P07200     TGFB1
# 2 O77633    ADAM10
# 3 O62807     PPARG
# 4 P50578    AKR1A1
# 5 P79387     NR5A1
# 6 O62651       WT1
colnames(kegg_data)

# tail(KEGG_PG_df)
#          Entry    Gene.Name
# 973     K7GN93       ZNF75D
# 974 A0A287BF90 LOC100524576
# 975     F1SBV4 LOC100154723
# 976 A0A286ZSU1 LOC100523983
# 977 A0A286ZMI7 LOC100737921
# 978 A0A287BLW2 LOC100511653
#
colnames(kegg_data)
# [1] "V1" "V2" "V3"

keggbg_new <- cbind(KEGG_PG_df, kegg_data) # 合并KEGG_PG_df和kegg_data数据
dim(keggbg_new)
# [1] 978   5
colnames(keggbg_new) <- c("Entry", "Gene.Name", "KEGG_PG", "pathway",  "pathway_description") # GO_PG是指GO背景文件中的“蛋白:基因”这一列的列名


### 4.5读取PFAM数据
pf <- read.xlsx("/public/hstore5/proteome/pipeline/script/project_result_system/pfam_all.xlsx", sheet = "pfam", startRow = 1, colNames = T, rowNames = F, detectDates = F)
dim(pf)
# [1] 519367      4

### 4.6读取富集的KOG（真核生物）/COG（原核生物）数据
kogname <- list.files(path = "../2.background/KOG/", pattern = "*.KOG.gene.anno.xls$")
kogname

kog <- read.csv(paste0("../2.background/KOG/",kogname), sep = "\t", header = T)
dim(kog)
colnames(kog)
colnames(kog) <- c("Entry", "Portein_name_in_KOG", "E.value", "Identity", "Score", "Organism", "KOG_id", "KOG_description", "KOG_abbreviation", "Functional.categories", "KOG_function_class")

### 4.7读取eggNOG数据
eu_eggNOG <- read.xlsx("/public/hstore5/proteome/pipeline/script/project_result_system/eggNOG_new.xlsx", sheet = "真核", startRow = 1, colNames = T, rowNames = F, detectDates = F)
dim(eu_eggNOG)
head(eu_eggNOG)
#    Entry   eggNOG_id
# 1 A3CRI4 ENOG4102SM4
# 2 Q12TZ6 ENOG4102SM4
# 3 Q2NG79 ENOG4102SQR
# 4 Q57781 ENOG4102SUV
# 5 Q0W2Y2 ENOG4102SX7
# 6 O27943 ENOG4102SZU

nog_anno <- read.table("/public/hstore5/proteome/pipeline/script/project_result_system/NOG.annotations.txt", sep = "\t", header = T, row.names = 1)
dim(nog_anno)
head(nog_anno)
eu_anno <- merge.data.frame(eu_eggNOG, nog_anno, by.x = "eggNOG_id", by.y = "eggNOG_id", all.x = T, all = F)
head(eu_anno)
dim(eu_anno)
fun_clas <- read.xlsx("/public/hstore5/proteome/pipeline/script/project_result_system/eggNOG_new.xlsx", sheet = "function", startRow = 1, rowNames = F, colNames = T, detectDates = F)
dim(fun_clas)
# [1] 25  2
fun_clas
class(fun_clas)
eu_eggNOG_new <- merge(eu_anno, fun_clas, by.x = "eggNOG_abbreviation", by.y = "eggNOG_abbreviation", all.x = T)
dim(eu_eggNOG_new)
head(eu_eggNOG_new)

## 5.数据处理（根据可信蛋白ID或名称合并Merge各个含富集信息的数据框）
eggp <- merge(accession_df, un_data, by.x = "Accession", by.y = "Entry", all.x = T) ## eggp 是各个列名的首字母Entry, GeneID、Gene_Name和Product
dim(eggp)
head(eggp)
colnames(eggp)
# [1] "Accession" "Product"   "GeneID"    "Gene_Name" ## 问题的根源在key5.xls文件
# [1] "Accession" "combine"   "GeneID"    "Gene_Name" "Product" ## V3这才是eggo数据框的列名
# [1] "Accession", "Protein.names", "Cross.reference.GeneID", "Gene.names.primary" ## V4这是最新的eggo数据框的列名
colnames(eggp) <- c("Accession", "Product", "GeneID", "Gene_Name") # eggp数据框列名修改

GK <- merge.data.frame(gobg_new, keggbg_new, by.x = "Entry", by.y = "Entry", all.x = T, all = F)
dim(GK)

colnames(GK)
# [1] "Entry"               "Gene.Name.x"         "GO_PG"
# [4] "GO_id"               "GO_term"             "Gene.Name.y"
# [7] "KEGG_PG"             "pathway"             "pathway_description"
#
GKP <- merge.data.frame(GK, pf, by.x = "Entry", by.y = "Entry", all.x = T, all = F)
dim(GKP)
# [1] 979  12
colnames(GKP)
annotation <- merge.data.frame(eggp, GKP, by.x = "Accession", by.y = "Entry", all.x = T, all = F)
dim(annotation)
# [1] 5188   15
colnames(annotation)
# [1] "Accession"           "Product"             "GeneID"              "Gene_Name"           "Gene.Name.x"         "GO_PG"
# [7] "GO_id"               "GO_term"             "Gene.Name.y"         "KEGG_PG"             "pathway"             "pathway_description"
# [13] "pfam"                "PFAM_Name"           "PFAM_desc"

annotation_new <- merge.data.frame(annotation, kog, by.x = "Accession", by.y = "Entry", all.x = T, all = F)
dim(annotation_new)
# [1] 5188   25
colnames(annotation_new)
#
# [1] "Accession"             "Product"               "GeneID"                "Gene_Name"             "Gene.Name.x"           "GO_PG"
# [7] "GO_id"                 "GO_term"               "Gene.Name.y"           "KEGG_PG"               "pathway"               "pathway_description"
# [13] "pfam"                  "PFAM_Name"             "PFAM_desc"             "Portein_name_in_KOG"   "E.value"               "Identity"
# [19] "Score"                 "Organism"              "KOG_id"                "KOG_description"       "KOG_abbreviation"      "Functional.categories"
# [25] "KOG_function_class"
#
colnames(annotation_new) <- c("Entry", "Product", "GeneID", "Gene_Name",  "Gene.Name.x", "GO_PG", "GO_id", "GO_term", "Gene.Name.y", "KEGG_PG", "pathway", "pathway_description", "pfam", "PFAM_Name", "PFAM_description", "Portein_name_in_KOG", "E.value", "Identity", "Score", "Organism", "KOG_id", "KOG_description", "KOG_abbreviation", "Functional.categories", "KOG_function_class")

annotation_new2 <- merge.data.frame(annotation_new, eu_eggNOG_new, by.x = "Entry", by.y = "Entry", all.x = T)

dim(annotation_new2)
# [1] 5188   29
colnames(annotation_new2)
#
# [1] "Entry"                 "Product"               "GeneID"                "Gene_Name"             "Gene.Name.x"           "GO_PG"
# [7] "GO_id"                 "GO_term"               "Gene.Name.y"           "KEGG_PG"               "pathway"               "pathway_description"
# [13] "pfam"                  "PFAM_Name"             "PFAM_description"      "Portein_name_in_KOG"   "E.value"               "Identity"
# [19] "Score"                 "Organism"              "KOG_id"                "KOG_description"       "KOG_abbreviation"      "Functional.categories"
# [25] "KOG_function_class"    "eggNOG_abbreviation"   "eggNOG_id"             "eggNOG_description"    "eggNOG_function_class"
#

### 5.1 自定义匹配数据的列名
anno_col <- c("Entry",	"Gene_Name", "GeneID", "Product",	"GO_id",	"GO_term",	"pathway",	"pathway_description",	"KOG_id",	"KOG_abbreviation",	"KOG_description", "KOG_function_class",	"eggNOG_id",	"eggNOG_abbreviation",	"eggNOG_description",	"eggNOG_function_class",	"pfam",	"PFAM_Name",	"PFAM_description")

annoma <- match(anno_col, colnames(annotation_new2))
annoma
# [1]  1  4  3  2  7  8 11 12 21 23 22 25 27 26 28 29 13 14 15
annotation_NEW <- annotation_new2[,annoma]
dim(annotation_NEW)
# [1] 5188   19
colnames(annotation_NEW)
# [1] "Entry"                 "Gene_Name"            
# [3] "GeneID"                "Product"              
# [5] "GO_id"                 "GO_term"              
# [7] "pathway"               "pathway_description"  
# [9] "KOG_id"                "KOG_abbreviation"     
# [11] "KOG_description"       "KOG_function_class"   
# [13] "eggNOG_id"             "eggNOG_abbreviation"  
# [15] "eggNOG_description"    "eggNOG_function_class"
# [17] "pfam"                  "PFAM_Name"            
# [19] "PFAM_description"     
# 
## 6.保存数据
annotation_NEW <- annotation_NEW[!duplicated(annotation_NEW$Entry),]
write.xlsx(annotation_NEW, file = "annotation.xlsx")

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
