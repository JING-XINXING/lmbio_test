########################################################################################################
# /Rscript function: Acetylation_Labelfree_project R analysis and plotting/
# /Author: jingxinxing, tianquan
# /Date: 2020/03/31
# /Version: v1.2
# /New: 1.本脚本专门用于乙酰化DIA项目数据分析和可视化绘图；

#       2.所绘制的图表有：（按照生成的目录分）
#       （1）目录一：Statistics
#        中文：1.乙酰化蛋白组鉴定结果统计柱状图
#        英文：1.Statistical_histogram_of_acetylation_protein_group.p*

#        中文：2.乙酰化蛋白分子质量分布图
#        英文：2.Molecular_weight_distribution_of_acetylation_protein.p*

#        中文：3.乙酰化蛋白位点数量分布图
#        英文：3. Quantitative_distribution_of_acetylation_protein_sites.p*

#        中文：4.乙酰化肽段位点数量分布图
#        英文：4.Quantitative_distribution_of_acetylation_peptide_sites.p*

#        中文：5.STY位点分布图
#        英文：5.STY_locus_distribution.p*

#       （2）目录二：PCA
#        PCA_2D.p*

#        PCA_3D.p*

#        PCA_Data.xlsx

#       （3）目录三：Motif
#        ?.*_Motif
#        ?.*_motif.xlsx

#       （4）目录四：Abundance_distribution_map
#        ?.Phosphorylated_Sites_Abundance_distribution_*_data.csv
#        ?.Phosphorylated_Sites_Abundance_distribution_*.p*
#
#       3.Motif分析（geshuting）/
#	（1）参数根据经验值定为：minseq=5,pvalue=0.01
#	（2）在比较组差异位点序列上寻找乙酰化Motif：S（serine,Ser，丝氨酸）、T（threonine,Thr，苏氨酸）和Y（tyrosine,Tyr，酪氨酸）

# /Usage: 执行命令 runacetlf
########################################################################################################
#
## 脚本运行计时开始
pt=proc.time()

## 项目分析日期
print("蛋白项目分析及绘图日志开始时间：")
d <- Sys.Date()
print("当前日期是：")
print(d)
weekdays(d)
months(d)
quarters(d)
print("国际标准时间是：")
d2 <- date()
print(d2)

## 1.设置当前工作目录
setwd("./")
dir()

## 2.导入R包
analysis_need_packages <- c("ggplot2", "plotrix", "openxlsx","pcaMethods", "readxl", "plot3D", "ggrepel", "corrplot", "motifStack", "rmotifx", "argparse", "progress", "ggrepel")
sapply(analysis_need_packages, library, character.only = T)

## 脚本执行进度条
print("分析开始：Start")
ppbb <- progress_bar$new(total = 1000)
for (i in 1:1000) {
   ppbb$tick()
   Sys.sleep(1 / 1000)
}

# ### 传参
# parser = ArgumentParser()
# parser$add_argument("--minseq", help="NULL", required = TRUE)
# parser$add_argument("--pvalue", help = "pvalue", required = TRUE)
# args <- parser$parse_args()
# str(args)
#
# minseq = args$minseq
# pvalue = args$pvalue
#
# minseq <- as.numeric(minseq)
# pvalue <- as.numeric(pvalue)
#
# fg<-read.xlsx("差异位点筛选结果.xlsx",sheet=3)
# bg<-read.xlsx("差异位点筛选结果.xlsx",sheet="Phospho (STY)Sites")
# source("/public/hstore5/proteome/pipeline/script/project_r_plotting/Motif.R")
# Motif(fg,bg,minseq,pvalue)

## 3.读取数据及数据处理 ##
### 新建一个Statistics目录
dir()
if (dir.exists("Statistics")){
  list.dirs("./Statistics")
  list.files("./Statistics")
}else{
  dir.create("./Statistics")
  dir.exists("Statistics")
}

### 3.1分子质量分布图 ###
mw_data <- read.table("./stats_data/mw.txt", sep = "\t", header = T)
dim(mw_data)
class(mw_data)
colnames(mw_data) <- c("Accession", "Mol..weight..kDa.")
# [1] "Accession"         "Mol..weight..kDa."

# 跳入Statistics目录
setwd("./Statistics")

#### plotting
ggplot(mw_data, aes(mw_data$Mol..weight..kDa.)) +
  geom_histogram(binwidth = 50, fill = "brown1", col = "black") +
  theme_bw() +
  theme(panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), axis.line = element_line(colour = "black")) +
  theme(plot.margin = unit(rep(2,4),'lines'), aspect.ratio = .6) +
  theme(legend.text = element_text(size = 15, colour = "black")) +
  theme(legend.title = element_text(face = "bold", size = 20)) +
  theme(axis.title.x = element_text(size=16), axis.title.y=element_text(size=16)) +
  xlab("Molecular weight(kDa)") +
  ylab("Number of identified proteins")
ggsave("1.Molecular_weight_distribution_of_acetylation_protein.pdf", width = 12, height = 7.5, units = "in")
ggsave("1.Molecular_weight_distribution_of_acetylation_protein.png", width = 12, height = 7.5, units = "in")

# 再次跳出
dir()
setwd("../")
dir()

### 3.2蛋白被乙酰化修饰的次数分布图
nump_data <- read.table("./stats_data/pro-n.txt", sep = "\t", header = F)
dim(nump_data)

colnames(nump_data) <- c("Counts", "Freq")
nump_data

# 切换工作目录
setwd("./Statistics/")

#### plotting
ggplot(nump_data, aes(x = Counts, y = Freq)) +
  geom_histogram(stat = "identity", col = "Black", fill = "dodgerblue", col = "black") +
  xlab(label = "Number of Acetylated Sites in a Protein") +
  ylab(label = "Acetylated Protein Numbers") +
  theme_bw() +
  theme(panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), axis.line = element_line(colour = "black")) +
  geom_text(aes(label = Freq, vjust = -0.8, hjust = 0.5), size = 3) +
  theme(plot.margin = unit(rep(2,4),'lines'), aspect.ratio = 0.5) +
  theme(axis.title.x = element_text(size=16), axis.title.y=element_text(size=16))
ggsave("2.Quantitative_distribution_of_acetylation_protein_sites.pdf", width = 12, height = 7.5, units = "in")
ggsave("2.Quantitative_distribution_of_acetylation_protein_sites.png", width = 12, height = 7.5, units = "in")

# 再次跳出Statistics
dir()
setwd("../")
dir()

### 3.3 乙酰化的蛋白、肽段、位点统计图（读取数据：ppp.txt）
p3_data <- read.table("./stats_data/ppp.txt", sep = "\t", quote = "\"'")
print(p3_data)
colnames(p3_data) <- c("Object", "Number")
N <- p3_data$Number
ymax <- max(N)

setwd("./Statistics")

### plotting
#### 保存PDF图片
op <- par(no.readonly = TRUE)
pdf("3.Acetylated_protein-peptide-site_statistics_barplot.pdf", width = 10, height = 10)
par(mai=c(2,1.5,0.8,1.5))
# bp <- barplot(N, width = 3, col = c("darkturquoise", "lightgreen", "lightcoral"), names.arg = c("Proteins", "Peptides", "Sites"), legend = c("AcetylatedProteins", "AcetylatedPeptides", "AcetylatedSites"), xlab = NULL, ylab = c("Number"), ylim = c(0, ymax + 2000), axes = T, xpd = F, axisnames = TRUE, horiz = F, space= 1.5, beside = TRUE, cex.names = 1.8, cex.axis = 1.1, cex.lab = 1.8, args.legend = list(x = "top"))
bp <- barplot(N, width = 3, col = c("blue", "orangered", "darkgreen"), names.arg = c("Proteins", "Peptides", "Sites"), legend = c("Acetylated Proteins", "Acetylated Peptides", "Acetylated Sites"), xlab = NULL, ylab = c("Number"), ylim = c(0, ymax + ymax/3), axes = T, xpd = F, axisnames = TRUE, horiz = F, space= 1.5, beside = TRUE, cex.names = 1.8, cex.axis = 1.1, cex.lab = 1.8, args.legend = list(x = "top"))
N2 <- N + ymax/10.0
text(bp, N2, format(N), xpd = TRUE, col = "blue", cex = 2)
par(op)
dev.off()

#### 保存PNG图片
png("3.Acetylated_protein-peptide-site_statistics_barplot.png", width = 1000, height = 1000)
par(mai=c(2,1.5,0.8,1.5))
# bp <- barplot(N, width = 3, col = c("darkturquoise", "lightgreen", "lightcoral"), names.arg = c("Proteins", "Peptides", "Sites"), legend = c("AcetylatedProteins", "AcetylatedPeptides", "AcetylatedSites"), xlab = NULL, ylab = c("Number"), ylim = c(0, ymax + 2000), axes = T, xpd = F, axisnames = TRUE, horiz = F, space= 1.5, beside = TRUE, cex.names = 1.8, cex.axis = 1.1, cex.lab = 1.8, args.legend = list(x = "top"))
bp <- barplot(N, width = 3, col = c("blue", "orangered", "darkgreen"), names.arg = c("Proteins", "Peptides", "Sites"), legend = c("Acetylated Proteins", "Acetylated Peptides", "Acetylated Sites"), xlab = NULL, ylab = c("Number"), ylim = c(0, ymax + ymax/3), axes = T, xpd = F, axisnames = TRUE, horiz = F, space= 1.5, beside = TRUE, cex.names = 1.8, cex.axis = 1.1, cex.lab = 1.8, args.legend = list(x = "top"))
N2 <- N + ymax/10.0
text(bp, N2, format(N), xpd = TRUE, col = "blue", cex = 2)
par(op)
dev.off()

# 跳出Statistics目录
dir()
setwd("../")
dir()

### 3.4 乙酰化肽段位点数量分布饼图
pep_n_data <- read.table("./stats_data/pep-n.txt", sep = "\t", quote = "\"'")
print(pep_n_data)
colnames(pep_n_data) <- c("Acetyla_Sites_N", "Counts")
head(pep_n_data)

# 再跳入Statistics目录
setwd("./Statistics")

A <- pep_n_data$Counts[1]
print(A)
B <- pep_n_data$Counts[2]
print(B)
x <- c(A, B)
print(x)

A_lab1 <- A /sum(A + B)
print(A_lab1)
A_Lab_OK <- paste(A, ";", paste("Percentage:", sprintf("%.2f",A_lab1*100), "%"))
A_Lab_OK

B_lab1 <- B / sum(A + B)
B_lab1
B_Lab_OK <- paste(B, ";", paste("Percentage:", sprintf("%.2f",B_lab1*100), "%"))
B_Lab_OK

#### 设置饼图的标记labels
labels <- c(paste("Acetylationsites 1, Peptides_number", A_Lab_OK), paste("Acetylationsites 2, Peptides_number", B_Lab_OK))

pdf("4.Quantitative_distribution_of_acetylation_peptide_sites_pie.pdf", width = 15, height = 8.5)
pie(x, labels = labels, lwd = 15, col = c("orangered", "lightseagreen", "cornflowerblue", "brown"), border = FALSE)
dev.off()

png("4.Quantitative_distribution_of_acetylation_peptide_sites_pie.png", width = 1500, height = 850)
pie(x, labels = labels, lwd = 15, col = c("orangered", "lightseagreen", "cornflowerblue", "orange"), border = FALSE)
dev.off()

# 再跳出
dir()
setwd("../")
dir()

# ### 3.5 乙酰化位点丰度比分布图
# #############################################################################
# #### 3.5.1 sample_information
# sample_info_1 <- read.xlsx("sample_information.xlsx", sheet = "样品信息", startRow = 1, colNames = TRUE, rowNames = FALSE, detectDates = FALSE)
# sample_info_2 <- read.xlsx("sample_information.xlsx", sheet = "比较组信息", startRow = 1, colNames = TRUE, rowNames = FALSE, detectDates = FALSE)
# #
# if (which(sample_info_1 == "MIX") != 0){
#   sample_info_1 <- sample_info_1[-which(sample_info_1 == "MIX"),]
# } else if (which(sample_info_1 == "Mix") != 0) {
#   sample_info_1 <- sample_info_1[-which(sample_info_1 == "Mix"),]
# } else if (which(sample_info_1 == "mix") != 0) {
#   sample_info_1 <- sample_info_1[-which(sample_info_1 == "mix"),]
# }
# #
# class(sample_info_1)
# class(sample_info_2)
# dim(sample_info_1)
# dim(sample_info_2)
# sample_info_1
# class(sample_info_1$样品编号)
# samp_numb <- sample_info_1$样品编号
# sample_info_2
# compa_groups <- 1:length(sample_info_2$比较组)
# compa_groups
# 
# for (i in compa_groups) {
#   class(gsub("/","_",sample_info_2[i,1]))
#   new_compa_groups <- gsub("/","_",sample_info_2[i,1])
#   class(new_compa_groups)
#   print(new_compa_groups)
#   data <- read.xlsx("预处理数据.xlsx", sheet = new_compa_groups, startRow = 1, colNames = TRUE, rowNames = FALSE, detectDates = FALSE)
#   dim(data)
#   class(data)
#   rownames(data)
#   #### 3.5.2 新建一个Abundance_distribution_map目录
#   dir()
#   if (dir.exists("Abundance_distribution_map ")){
#     list.dirs("./Abundance_distribution_map")
#     list.files("./Abundance_distribution_map")
#   }else{
#     dir.create("./Abundance_distribution_map")
#     dir.exists("Abundance_distribution_map")
#   }
#   # [1] TRUE
#   setwd("./Abundance_distribution_map")
#   dir()
#   if (length(data$`log2(FC)`) == 0 ) {
#     print("样品没有重复，没有log2(FC)值，不绘制相关性图")
#   } else {
#     data_new <- data.frame(row.names(data), data$`log2(FC)`)
# 
#     pdf(paste0(i,".Acetylated_Peptides_Abundance_distribution_",new_compa_groups,".pdf"), width = 12, height = 7.5)
#     # hist(data_new[,2],col="greenyellow",freq=FALSE,breaks=30,
#     hist(data_new[,2],col="limegreen",freq=FALSE,breaks=30,
#          main="Acetylated Peptides Ratio Distribution",
#          xlab="log2(FC)",ylab="Number of Acetylated Peptides")
#     dev.off()
#     png(paste0(i,".Acetylated_Peptides_Abundance_distribution_",new_compa_groups,".png"), width = 1200, height = 750)
#     hist(data_new[,2],col="limegreen",freq=FALSE,breaks=30,
#          main="Acetylated Peptides Ratio Distribution",
#          xlab="log2(FC)",ylab="Number of Acetylated Peptides")
#     dev.off()
#     write.csv(data, file = paste0(i,".Acetylated_Peptides_Abundance_distribution_",new_compa_groups,"_data.csv"))
#     dir()
#   }
#   setwd("../")
#   dir()
# }
# 
# if (dir.exists("Abundance_distribution_map")){
#   print("比较组差异乙酰化位点丰度比分布图已经绘制完成，请查看目录Abundance_distribution_map")
#   list.files("./Abundance_distribution_map")
# }else{
#   print("注意：本项目样本数据不适合绘制比较组差异乙酰化位点丰度比分布图，所以不绘制比较组差异乙酰化位点丰度比分布图！")
# }
# 
# if (length(list.files("./Abundance_distribution_map")) == 0){
#   unlink("Abundance_distribution_map", recursive = TRUE, force = FALSE)
# } # 判断Abundance_distribution_map目录是否是空目录，如果是空目录就删掉

# ########################################################################################################
# ### 3.5 PCA图 ###
# ########################################################################################################
# #### 3.5.1 读取测试数据：项目的差异位点筛选结果文件（格式为.xlsx）
# #### 判断差异位点筛选结果文件中的是否有“可信蛋白”，还是有“合并可信蛋白”，对应导入数据
# if ("可信肽段" %in% readxl::excel_sheets("./差异肽段筛选结果.xlsx") == TRUE){
#   trusted_peptides <- read.xlsx("./差异肽段筛选结果.xlsx", sheet = "可信肽段", startRow = 1, colNames = TRUE, rowNames = FALSE, detectDates = FALSE)
#   print("可信肽段原始数据大小为：")
#   dim(trusted_peptides)
# } else {
#   print("文件格式和内容错误：'差异肽段筛选结果.xlsx'文件中没有可信肽段")
# }
# 
# #### 3.5.2.数据处理：对可信肽段数据进行提取和处理，为了进行计算，空值填充零（0）
# print("查看trusted_peptides的列名：")
# colnames(trusted_peptides)
# head(trusted_peptides[,1])
# rownames(trusted_peptides) <- trusted_peptides$ModifiedSequence
# head(rownames(trusted_peptides))
# # [1] "_S[Phospho (STY)]WDGGDIAELR_"
# # [2] "_SLS[Phospho (STY)]ALDSRPGALSK_"
# # [3] "_TANINNDIS[Phospho (STY)]DSDVGHDLGK_"
# # [4] "_LLPGS[Phospho (STY)]VDG_"
# # [5] "_LVT[Phospho (STY)]ASSSASRT[Phospho (STY)]TTSR_"
# # [6] "_KLLPGS[Phospho (STY)]VDG_"
# 
# #### 3.5.3 样品数据匹配
# Sample_info <- read.xlsx("sample_information.xlsx", sheet = "样品信息", startRow = 1, colNames = TRUE, rowNames = FALSE, detectDates = FALSE) # 读取sample_information.xlsx>表格中的信息
# #
# if (which(Sample_info == "MIX") != 0){
#   Sample_info <- Sample_info[-which(Sample_info == "MIX"),]
# } else if (which(Sample_info == "Mix") != 0) {
#   Sample_info <- Sample_info[-which(Sample_info == "Mix"),]
# } else if (which(sample_info_1 == "mix") != 0) {
#   Sample_info <- Sample_info[-which(Sample_info == "mix"),]
# }
# #
# print("查看读取的Sample_info的数据中的样品信息：")
# Sample_info
# 
# Sample_info$作图编号 <- NULL
# colnames(Sample_info) <- c("Sample", "Sample_abc")
# Sample_info$Sample_abc <- gsub(" ", ".", Sample_info$Sample_abc) # 替换字符串
# sama <- match(Sample_info$Sample_abc, colnames(trusted_peptides))
# print("查看Sample_abc在trusted_prot中匹配到的位置信息")
# sama
# 
# #### 3.5.4 根据样品位置信息进行数据重组
# trusted_peptides_new <- trusted_peptides[,sama]
# print("查看样品匹配后的数据大小：")
# dim(trusted_peptides_new)
# # [1] 1339    6
# trusted_peptides_new[1:5,] # 查看前5行，所有列（样品）的数据
# 
# #### 3.5.5 空值NA补充为0
# trusted_peptides_new[is.na(trusted_peptides_new)] <- 0
# trusted_peptides_new[1:5,] # 替换之后的数据内容
# 
# #### 3.5.6保存处理好的未进行行列转置的数据
# ## Create a new workbook
# wb <- createWorkbook("PCA_Data")
# 
# #### 3.5.7 在当前目录里创建一个PCA目录
# dir()
# if (dir.exists("PCA")){
#   list.dirs("./PCA")
#   list.files("./PCA")
# }else{
#   dir.create("./PCA")
#   dir.exists("PCA")
# }
# # [1] TRUE
# setwd("./PCA")
# 
# #### 3.5.8 写入trusted_peptides_new数据
# addWorksheet(wb, "1.trusted_peptides_new_data", tabColour = "red")
# writeData(wb, sheet = "1.trusted_peptides_new_data", trusted_peptides_new)
# saveWorkbook(wb, "PCA_Data.xlsx", overwrite = TRUE)
# 
# #### 3.5.9 数据框转换为矩阵，行列转置
# trusted_peptides_new <- t(as.matrix(trusted_peptides_new))
# 
# #### 3.6.0 print("查看去掉无用信息后，行列转置后的数据行名、列名和大小：")
# dim(trusted_peptides_new)
# row.names(trusted_peptides_new)
# head(colnames(trusted_peptides_new))
# class(trusted_peptides_new)
# 
# #### 3.6.1 计算PCA值：PC1、PC2和PC3，构建PCA对象
# trusted_peptides_pca <- pca(trusted_peptides_new, scale = "uv", nPcs = 3)
# print("查看PCA对象的数据类型：")
# class(trusted_peptides_pca)
# # [1] "pcaRes"
# # attr(,"package")
# # [1] "pcaMethods"
# 
# print("查看数据的PCA主成分数值，如下：")
# trusted_peptides_pca@scores
# 
# #### 3.6.2 合并PCA数据
# trusted_peptides_pca_socr <- merge(trusted_peptides_new, scores(trusted_peptides_pca), by = 0)
# print("查看合并后的数据大小为：")
# dim(trusted_peptides_pca_socr)
# 
# #### 3.6.3 保存PCA计算后合并的新数据
# dir()
# 
# #### 3.6.4 写入trusted_prot_pca_plot数据
# addWorksheet(wb, "2.trusted_peptides_pca_socr", tabColour = "orange")
# writeData(wb, sheet = "2.trusted_peptides_pca_socr", trusted_peptides_pca_socr)
# saveWorkbook(wb, "PCA_Data.xlsx", overwrite = TRUE)
# 
# #### 3.6.5 读取Sample_info文件，构建绘图数据
# print("查看读取的Sample_info的数据中的样品信息")
# head(Sample_info)
# class(Sample_info)
# dim(Sample_info)
# sn <- length(unique(Sample_info$Sample))
# print(paste0("样品数量为：",sn,"个"))
# class(trusted_peptides_pca_socr)
# dim(trusted_peptides_pca_socr)
# trusted_peptides_pca_plot <- cbind(trusted_peptides_pca_socr, Sample_info)
# dim(trusted_peptides_pca_plot)
# 
# #### 3.6.6 绘制PCA 2D图和保存图片、数据
# # 写入trusted_peptides_pca_plot数据
# addWorksheet(wb, "5.trusted_peptides_plot_data", tabColour = "blue")
# writeData(wb, sheet = "5.trusted_peptides_plot_data", trusted_peptides_pca_plot)
# saveWorkbook(wb, "PCA_Data.xlsx", overwrite = TRUE)
# 
# #### 3.6.7 计算PCA方差占比（解释率）
# pc1_sdev <- sd(trusted_peptides_pca_socr$PC1)
# pc2_sdev <- sd(trusted_peptides_pca_socr$PC2)
# pc1_percent_variance <- pc1_sdev^2/sum(pc1_sdev^2 + pc2_sdev^2) * 100
# print(paste0("PC1的方差占比为：", pc1_percent_variance))
# pc2_percent_variance <- pc2_sdev^2/sum(pc1_sdev^2 + pc2_sdev^2) * 100
# print(paste0("PC2的方差占比为：", pc2_percent_variance))
# 
# pc1_percent_variance <- as.data.frame(pc1_percent_variance)
# pc2_percent_variance <- as.data.frame(pc2_percent_variance)
# percentVar2D <- cbind(pc1_percent_variance, pc2_percent_variance)
# 
# #### 3.6.8 保存PC1和PC2主成分方差占比数据
# # 写入PCA 2D和3D的主成分占比（解释率）
# addWorksheet(wb, "3.percentVar2D", tabColour = "yellow")
# writeData(wb, sheet = "3.percentVar2D", percentVar2D)
# saveWorkbook(wb, "PCA_Data.xlsx", overwrite = TRUE)
# 
# #### 3.6.9 绘制二维PCA图
# # 保存pdf格式
# # 增加对样品数量的判断，从而可以自适应图片中样品点的大小和是否做stat_ellipse()统计
# 
# if (sn >= 3){
#   ggplot(trusted_peptides_pca_plot, aes(trusted_peptides_pca_plot$PC1,trusted_peptides_pca_plot$PC2, colour = Sample)) +
#     geom_point(size = 5) +
#     geom_text_repel(aes(label = trusted_prot_pca_plot$Sample_abc)) +
#     # geom_text(label = trusted_peptides_pca_plot$Sample_abc, size = 3, check_overlap = F, col = "black", hjust = "center", vjust = "middle") +
#     # geom_text(label = trusted_peptides_pca_plot$Sample_abc, size = 3, check_overlap = F, col = "black", hjust = "inward", vjust = "inward") +
#     xlab(paste0("PC1 ", round(percentVar2D$pc1_percent_variance,2), "% variance")) +
#     ylab(paste0("PC2 ", round(percentVar2D$pc2_percent_variance,2), "% variance")) +
#     theme_bw() +
#     theme(panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), axis.line = element_line(colour = "black")) +
#     theme(plot.margin = unit(rep(7,4),'lines'), aspect.ratio = 1.0) +
#     theme(legend.text = element_text(size = 15, colour = "black")) +
#     theme(legend.title = element_text(face = "bold", size = 20)) +
#     theme(axis.title.x =element_text(size=16), axis.title.y=element_text(size=16)) +
#     stat_ellipse()
#   ggsave("PCA_2D.pdf", width = 12, height = 7.5, units = "in")
#   ggsave("PCA_2D.png", width = 12, height = 7.5, units = "in")
# } else if (sn < 3){
#   ggplot(trusted_peptides_pca_plot,aes(trusted_peptides_pca_plot$PC1,trusted_peptides_pca_plot$PC2, colour = Sample)) +
#     geom_point(size = 5) +
#     geom_text_repel(aes(label = trusted_prot_pca_plot$Sample_abc)) +
#     # geom_text(label = trusted_peptides_pca_plot$Sample_abc, size = 3, check_overlap = F, col = "black", hjust = "inward", vjust = "inward") +
#     xlab(paste0("PC1 ", round(percentVar2D$pc1_percent_variance,2), "% variance")) +
#     ylab(paste0("PC2 ", round(percentVar2D$pc2_percent_variance,2), "% variance")) +
#     theme_bw() +
#     theme(panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), axis.line = element_line(colour = "black")) +
#     theme(plot.margin = unit(rep(7,4),'lines'), aspect.ratio = 1.0) +
#     theme(legend.text = element_text(size = 15, colour = "black")) +
#     theme(legend.title = element_text(size = 20, face = "bold")) +
#     theme(axis.title.x =element_text(size=16), axis.title.y=element_text(size=16)) +
#   stat_ellipse()
#   ggsave("PCA_2D.pdf", width = 12, height = 7.5, units = "in")
#   ggsave("PCA_2D.png", width = 12, height = 7.5, units = "in")
# 
# }
# 
# #### 3.7.0 计算PCA三个主成分的方差占比
# pc1_sdev <- sd(trusted_peptides_pca_socr$PC1)
# pc2_sdev <- sd(trusted_peptides_pca_socr$PC2)
# pc3_sdev <- sd(trusted_peptides_pca_socr$PC3)
# 
# PC1_percent_variance <- pc1_sdev^2/sum(pc1_sdev^2 + pc2_sdev^2 + pc3_sdev^2) * 100
# print(paste0("PC1方差占比为：", PC1_percent_variance))
# 
# PC2_percent_variance <- pc2_sdev^2/sum(pc1_sdev^2 + pc2_sdev^2 + pc3_sdev^2) * 100
# print(paste0("PC2方差占比为：", PC2_percent_variance))
# PC3_percent_variance <- pc3_sdev^2/sum(pc1_sdev^2 + pc2_sdev^2 + pc3_sdev^2) * 100
# print(paste0("PC3方差占比为：", PC3_percent_variance))
# 
# PC1_percent_variance <- as.data.frame(PC1_percent_variance)
# PC2_percent_variance <- as.data.frame(PC2_percent_variance)
# PC3_percent_variance <- as.data.frame(PC3_percent_variance)
# percentVar3D <- cbind(PC1_percent_variance, PC2_percent_variance, PC3_percent_variance)
# 
# print("查看PCA三个主成分的解释率为：")
# percentVar3D
# addWorksheet(wb, "4.percentVar3D", tabColour = "green")
# writeData(wb, sheet = "4.percentVar3D", percentVar3D)
# saveWorkbook(wb, "PCA_Data.xlsx", overwrite = TRUE)
# spos <- 1:sn
# print(spos)
# 
# #### 3.7.1 保存Sample_info数据
# addWorksheet(wb, "6.Sample_info", tabColour = "purple")
# writeData(wb, sheet = "6.Sample_info", Sample_info)
# saveWorkbook(wb, "PCA_Data.xlsx", overwrite = TRUE)
# 
# write.csv(Sample_info, file = "Sample_info.csv")
# Sample_info <- read.table("Sample_info.csv", sep = ',', header = TRUE)
# trusted_peptides_pca_plot <- cbind(trusted_peptides_pca_socr, Sample_info)
# dim(trusted_peptides_pca_plot)
# 
# ## 删除Sample_info.csv文件
# unlink("Sample_info.csv", recursive = FALSE, force = FALSE)
# 
# #### 3.6.7 绘制3D图
# #############################################################################
# ### 根据样品数量决定样品颜色和图例的格式大小 ###
# col <- c("orange", "green", "magenta","red","pink","blue","darkgreen","yellow", "brown", "turquoise","cyan","gold","aquamarine","tomato","tan","lawngreen","cornflowerblue","hotpink","firebrick","darkviolet","orangered", "orchid","darkmagenta","snow4","slateblue","rosybrown","deepskyblue","lightseagreen","darkviolet","azure4")
# sacol <- sample(col,sn)
# sl <- sn/10.0
# pdf("PCA_3D.pdf", width = 12, height = 7.5)
# scatter3D(x = trusted_peptides_pca_plot$PC1, y = trusted_peptides_pca_plot$PC2, z = trusted_peptides_pca_plot$PC3, xlab = paste0("PC1 ", round(percentVar3D$PC1_percent_variance,2), "% variance"), ylab = paste0("PC2 ", round(percentVar3D$PC2_percent_variance,2), "% variance"), zlab = paste0("PC3 ", round(percentVar3D$PC3_percent_variance,2), "% variance"), labels = trusted_peptides_pca_plot$Sample_abc, col = sacol, phi = 5, theta = 32, bty = 'b2', pch = 20, cex = 5, ticktype = "detailed", plot = TRUE, adj = 0.5, font = 2, colkey = list(at = spos, side = 4, addlines = FALSE, length = sl, width = 0.6, labels = unique(trusted_peptides_pca_plot$Sample), cex.clab = 1.5), clab = "Sample", colvar = as.integer(trusted_peptides_pca_plot$Sample))
# dev.off()
# 
# png("PCA_3D.png", width = 1200, height = 750)
# scatter3D(x = trusted_peptides_pca_plot$PC1, y = trusted_peptides_pca_plot$PC2, z = trusted_peptides_pca_plot$PC3, xlab = paste0("PC1 ", round(percentVar3D$PC1_percent_variance,2), "% variance"), ylab = paste0("PC2 ", round(percentVar3D$PC2_percent_variance,2), "% variance"), zlab = paste0("PC3 ", round(percentVar3D$PC3_percent_variance,2), "% variance"), labels = trusted_peptides_pca_plot$Sample_abc, col = sacol, phi = 5, theta = 32, bty = 'b2', pch = 20, cex = 5, ticktype = "detailed", plot = TRUE, adj = 0.5, font = 2, colkey = list(at = spos, side = 4, addlines = FALSE, length = sl, width = 0.6, labels = unique(trusted_peptides_pca_plot$Sample), cex.clab = 1.5), clab = "Sample", colvar = as.integer(trusted_peptides_pca_plot$Sample))
# dev.off()
# 
# dir()
# list.files()
# setwd("../")
# dir()
# print("PCA分析及绘图完成！请查看PCA目录中的图片和数据文件PCA_Data.xlsx。")
# list.files("./PCA")

## 4.结束
print("输出R包和环境变量信息：")
sessionInfo()
print("乙酰化项目R绘图已经完成，请下载本地查看图片数据和文件")
print("祝工作顺利，开心每一天！")

## 分析完成进度条
ppbb <- progress_bar$new(
  format = "  完成百分比 [:bar] :percent",
  total = 1000, clear = FALSE, width= 100)
for (i in 1:1000) {
  ppbb$tick()
  Sys.sleep(1 / 1000)
}

## 5.脚本耗时
print("脚本运行时间为：")
proc.time()-pt
