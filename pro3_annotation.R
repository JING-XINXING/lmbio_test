################################################################################################################
# Rscript function: Produce Procaryote No-Uniprot Protein of Annotation File
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
getwd()
setwd("D:/工作空间/研发/2020年研发工作目录/2020年4月/项目分析注释文件annotation.xlsx生成脚本升级/1.非Uniprot蛋白登录号用Swissprot登录号注释/")
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

## 4.dep
dep <- list.files(path = "../1.dep/", pattern = "^差异蛋白筛选结果")
des <- list.files(path = "../1.dep/", pattern = "^差异位点筛选结果")
depp <- list.files(path = "../1.dep/", pattern = "^差异肽段筛选结果")
print(dep)
print(des)
print(depp)

if (length(dep) == 1) {
  if ("合并可信蛋白" %in% readxl::excel_sheets("../1.dep/差异蛋白筛选结果.xlsx") == TRUE){
    dep_data_raw1 <- openxlsx::read.xlsx("../1.dep/差异蛋白筛选结果.xlsx", sheet = "原始数据1", startRow = 1, colNames = TRUE, rowNames = FALSE, detectDates = FALSE)
    dep_data_raw2 <- openxlsx::read.xlsx("../1.dep/差异蛋白筛选结果.xlsx", sheet = "原始数据2", startRow = 1, colNames = TRUE, rowNames = FALSE, detectDates = FALSE)
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
      dep_data_raw3 <- openxlsx::read.xlsx("../1.dep/差异蛋白筛选结果.xlsx", sheet = "原始数据3", startRow = 1, colNames = TRUE, rowNames = FALSE, detectDates = FALSE)
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
    dep_data_raw <- openxlsx::read.xlsx("../1.dep/差异蛋白筛选结果.xlsx", sheet = "原始数据", startRow = 1, colNames = TRUE, rowNames = FALSE, detectDates = FALSE)
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
  des_data_raw <- openxlsx::read.xlsx("../1.dep/差异位点筛选结果.xlsx", sheet = "原始数据", startRow = 1, colNames = TRUE, rowNames = FALSE, detectDates = FALSE)
  print("原始数据蛋白个数为：")
  des_acc_all <- as.data.frame(des_data_raw$Accession)
  dep_acc_all <- des_acc_all
  colnames(dep_acc_all) <- c("Accession")
  dep_acc_all <- dep_acc_all[!duplicated(dep_acc_all$Accession),]
  dep_acc_all <- as.data.frame(dep_acc_all)
  colnames(dep_acc_all) <- c("Accession")
  print("原始数据蛋白个数为：")
  NROW(dep_acc_all)
  head(dep_acc_all)
} else if (length(depp) == 1) {
  depp_data_raw <- openxlsx::read.xlsx("../1.dep/差异肽段筛选结果.xlsx", sheet = "原始数据", startRow = 1, colNames = TRUE, rowNames = FALSE, detectDates = FALSE)
  print("原始数据蛋白个数为：")
  depp_acc_all <- as.data.frame(depp_data_raw$Accession)
  dep_acc_all <- depp_acc_all
  colnames(dep_acc_all) <- c("Accession")
  dep_acc_all <- dep_acc_all[!duplicated(dep_acc_all$Accession),]
  dep_acc_all <- as.data.frame(dep_acc_all)
  colnames(dep_acc_all) <- c("Accession")
  print("原始数据蛋白个数为：")
  NROW(dep_acc_all)
  head(dep_acc_all)
}


#@ if判断流程控制 #@

if (length(dir(path = "../2.background/", pattern = "Swissprot")) != 1 ) { # 非Perl脚本自动注释生成的背景文件
  print("-------------------------------------------------------")
  ### 4.2 读取物种Uniprot数据库或NCBI数据库中自定义的数据（包括descript、geneid和genename）
  un_data <- read.csv("../2.background/pre1.txt", sep = "\t", header = T, fill = T)
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
  go_data <- read.csv("../3.enrichment/gene_go.backgroud.xls", sep = "\t")
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
  kegg_data <- read.csv("../3.enrichment/gene_kegg.backgroud.xls", sep = "\t")
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
  cogname <- list.files(path = "../2.background/COG/", pattern = "*.COG.gene.anno.xls$")
  cogname
  
  cog <- read.csv(paste0("../2.background/COG/",kogname), sep = "\t", header = T)
  dim(cog)
  colnames(cog)
  colnames(cog) <- c("Entry", "Portein_name_in_KOG", "E.value", "Identity", "Score", "Organism", "COG_id", "COG_description", "COG_abbreviation", "Functional.categories", "COG_function_class")
  
  ### 4.7读取eggNOG数据
  pro_eggNOG <- read.xlsx("/public/hstore5/proteome/pipeline/script/project_result_system/eggNOG_new.xlsx", sheet = "原核", startRow = 1, colNames = T, rowNames = F, detectDates = F)
  dim(pro_eggNOG)
  head(pro_eggNOG)
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
  pro_anno <- merge.data.frame(eu_eggNOG, nog_anno, by.x = "eggNOG_id", by.y = "eggNOG_id", all.x = T, all = F)
  head(pro_anno)
  dim(pro_anno)
  fun_clas <- read.xlsx("/public/hstore5/proteome/pipeline/script/project_result_system/eggNOG_new.xlsx", sheet = "function", startRow = 1, rowNames = F, colNames = T, detectDates = F)
  dim(fun_clas)
  # [1] 25  2
  fun_clas
  class(fun_clas)
  pro_eggNOG_new <- merge(eu_anno, fun_clas, by.x = "eggNOG_abbreviation", by.y = "eggNOG_abbreviation", all.x = T)
  dim(pro_eggNOG_new)
  head(pro_eggNOG_new)
  
  ## 5.数据处理（根据可信蛋白ID或名称合并Merge各个含富集信息的数据框）
  # colnames(dep_acc_all) <- c("Accession")
  dim(dep_acc_all)
  class(dep_acc_all)
  eggp <- merge(dep_acc_all, un_data, by.x = "Accession", by.y = "Entry", all.x = T) ## eggp 是各个列名的首字母Entry, GeneID、Gene_Name和Product
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
  
  annotation_new <- merge.data.frame(annotation, cog, by.x = "Accession", by.y = "Entry", all.x = T, all = F)
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
  colnames(annotation_new) <- c("Entry", "Product", "GeneID", "Gene_Name",  "Gene.Name.x", "GO_PG", "GO_id", "GO_term", "Gene.Name.y", "KEGG_PG", "pathway", "pathway_description", "pfam", "PFAM_Name", "PFAM_description", "Portein_name_in_KOG", "E.value", "Identity", "Score", "Organism", "COG_id", "COG_description", "COG_abbreviation", "Functional.categories", "COG_function_class")
  
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
  anno_col <- c("Entry",	"Gene_Name", "GeneID", "Product",	"GO_id",	"GO_term",	"pathway",	"pathway_description",	"COG_id",	"COG_abbreviation",	"COG_description", "COG_function_class",	"eggNOG_id",	"eggNOG_abbreviation",	"eggNOG_description",	"eggNOG_function_class",	"pfam",	"PFAM_Name",	"PFAM_description")
  
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
  print("-------------------------------------------------------")
  
} else { # Perl脚本自动注释生成的背景文件 ######################################
  
  print("-------------------------------------------------------")
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
  # pf <- read.xlsx("/public/hstore5/proteome/pipeline/script/project_result_system/pfam_all.xlsx", sheet = "pfam", startRow = 1, colNames = T, rowNames = F, detectDates = F)
  pf <- read.xlsx("../../pfam_all.xlsx", sheet = "pfam", startRow = 1, colNames = T, rowNames = F, detectDates = F)
  dim(pf)
  # [1] 519367      4
  
  ### 3.6读取富集的KOG（真核生物）/COG（原核生物）数据
  cogname <- list.files(path = "../2.background/COG", pattern = "*.COG.gene.anno.xls$")
  cogname
  cog <- read.csv(paste0("../2.background/COG/",cogname), sep = "\t", header = T)
  dim(cog)
  colnames(cog)
  colnames(cog) <- c("Entry", "Portein_name_in_KOG", "E.value", "Identity", "Score", "Organism", "COG_id", "COG_description", "COG_abbreviation", "Functional.categories", "COG_function_class")
  
  ### 3.7读取eggNOG数据
  # pro_eggNOG <- read.xlsx("/public/hstore5/proteome/pipeline/script/project_result_system/eggNOG_new.xlsx", sheet = "原核", startRow = 1, colNames = T, rowNames = F, detectDates = F)
  pro_eggNOG <- read.xlsx("../../eggNOG_new.xlsx", sheet = "原核", startRow = 1, colNames = T, rowNames = F, detectDates = F)
  dim(pro_eggNOG)
  head(pro_eggNOG)
  # nog_anno <- read.table("/public/hstore5/proteome/pipeline/script/project_result_system/NOG.annotations.txt", sep = "\t", header = T, row.names = 1)
  nog_anno <- read.table("../../NOG.annotations.txt", sep = "\t", header = T, row.names = 1)
  dim(nog_anno)
  head(nog_anno)
  pro_anno <- merge.data.frame(pro_eggNOG, nog_anno, by.x = "eggNOG_id", by.y = "eggNOG_id", all.x = T, all = F)
  head(pro_anno)
  dim(pro_anno)
  # fun_clas <- read.xlsx("/public/hstore5/proteome/pipeline/script/project_result_system/eggNOG_new.xlsx", sheet = "function", startRow = 1, rowNames = F, colNames = T, detectDates = F)
  fun_clas <- read.xlsx("../../eggNOG_new.xlsx", sheet = "function", startRow = 1, rowNames = F, colNames = T, detectDates = F)
  dim(fun_clas)
  # [1] 25  2
  head(fun_clas)
  class(fun_clas)
  pro_eggNOG_new <- merge.data.frame(pro_anno, fun_clas, by.x = "eggNOG_abbreviation", by.y = "eggNOG_abbreviation", all.x = T)
  dim(pro_eggNOG_new)
  head(pro_eggNOG_new)
  
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
  length(test3)
  test3 <- as.data.frame(test3)
  dim(test3)
  colnames(test3) <- c("Swissprot_ID")
  head(test3)
  st_data_new <- cbind.data.frame(st_data, test3)
  dim(st_data_new)
  st_data_new <- as.data.frame(st_data_new)
  
  ## 4.数据处理（根据可信蛋白ID或名称合并Merge各个含富集信息的数据框）
  
  ### 4.1 GO和KEGG数据合并
  GK <- merge.data.frame(gobg, keggbg, by.x = "Accession", by.y = "Accession", all = T)
  dim(GK)
  
  ### 4.2 GK和pfam数据合并
  GKP <- merge.data.frame(GK, st_data_new, by.x = "Accession", by.y = "Accession", all = T)
  dim(GKP)
  
  ### 4.3 原始蛋白Accession和GKP合并
  annotation <- merge.data.frame(dep_acc_all, GKP, by.x = "Accession", by.y = "Accession", all.x = T)
  dim(annotation)
  colnames(annotation)
  
  annotation_new <- merge.data.frame(annotation, kog, by.x = "Accession", by.y = "Entry", all.x = T)
  dim(annotation_new)
  colnames(annotation_new)
  
  annotation_new2 <- merge.data.frame(annotation_new, eu_eggNOG_new, by.x = "Swissprot_ID", by.y = "Entry", all.x = T)
  
  dim(annotation_new2)
  
  colnames(annotation_new2)
  # [1] "Swissprot_ID"          "Accession"             "GO_id"                 "GO_annotation"         "e_value"               "identity"             
  # [7] "Database_GeneID"       "KO"                    "gene_name"             "Description"           "Pathway"               "Pathway_definition"   
  # [13] "Swissprot_id"          "E_value"               "Identity.x"            "Score.x"               "Swissprot_annotation"  "Portein_name_in_KOG"  
  # [19] "E.value"               "Identity.y"            "Score.y"               "Organism"              "KOG_id"                "KOG_description"      
  # [25] "KOG_abbreviation"      "Functional.categories" "KOG_function_class"    "eggNOG_abbreviation"   "eggNOG_id"             "eggNOG_description"   
  # [31] "eggNOG_function_class"
  
  
  # colnames(annotation_new2) <- c("Accession", "GO_id", "GO_annotation", "Pathway", "Pathway_definition", "pfam", "PFAM_Name", "PFAM_description", "Portein_name_in_KOG", "E.value", "Identity", "Score", "Organism", "KOG_id", "KOG_description", "KOG_abbreviation", "KOG_Functional.categories", "KOG_function_class", "eggNOG_abbreviation", "eggNOG_id", "eggNOG_description", "eggNOG_function_class")
  colnames(annotation_new2) <- c("Swissprot_ID", "Accession", "GO_id", "GO_annotation", "e_value", "identity", "Database_GeneID", "KO", "gene_name", "Description", "Pathway", "Pathway_definition", "Swissprot_id", "E_value", "Identity.x", "Score.x", "Swissprot_annotation", "Portein_name_in_KOG",  "E.value", "Identity.y", "Score.y", "Organism", "COG_id", "COG_description", "COG_abbreviation", "Functional.categories", "COG_function_class", "eggNOG_abbreviation", "eggNOG_id", "eggNOG_description", "eggNOG_function_class")
  # "pfam", "PFAM_Name", "PFAM_description", "Portein_name_in_KOG", "E.value", "Identity", "Score", "Organism", "KOG_id", "KOG_description", "KOG_abbreviation", "KOG_Functional.categories", "KOG_function_class", "eggNOG_abbreviation", "eggNOG_id", "eggNOG_description", "eggNOG_function_class")
  
  annotation_new3 <- merge.data.frame(annotation_new2, pf, by.x = "Swissprot_ID", by.y = "Entry", all.x = T)
  dim(annotation_new3)
  colnames(annotation_new3)
  ## 自定义匹配数据的列名
  anno_col <- c("Accession", "Swissprot_ID",	"Swissprot_annotation", "GO_annotation",	"Pathway",	"Pathway_definition",	"COG_id",	"COG_abbreviation",	"COG_description", "COG_function_class",	"eggNOG_id",	"eggNOG_abbreviation",	"eggNOG_description",	"eggNOG_function_class",	"pfam",	"PFAM_Name",	"PFAM_desc")
  
  annoma <- match(anno_col, colnames(annotation_new3))
  annoma
  annotation_NEW <- annotation_new3[,annoma]
  dim(annotation_NEW)
  colnames(annotation_NEW)
  # [1] "Accession"             "Swissprot_ID"          "Swissprot_annotation"  "GO_annotation"         "Pathway"               "Pathway_definition"   
  # [7] "KOG_id"                "KOG_abbreviation"      "KOG_description"       "KOG_function_class"    "eggNOG_id"             "eggNOG_abbreviation"  
  # [13] "eggNOG_description"    "eggNOG_function_class" "pfam"                  "PFAM_Name"             "PFAM_desc"
  colnames(annotation_NEW)[17] <- "PFAM_description"
  ## 5.保存数据
  # annotation_NEW <- annotation_NEW[!duplicated(annotation_NEW$Entry),]
  write.xlsx(annotation_NEW, file = "annotation.xlsx")
  print("-------------------------------------------------------")
  
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
