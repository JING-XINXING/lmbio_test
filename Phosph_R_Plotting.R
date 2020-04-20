########################################################################################################
# /Rscript function: Phosph_project R analysis and plotting/
# /Author: jingxinxing, geshuting, tianquan
# /Date: 2020/03/31
# /Version: v3.8
# /New: 1.本脚本专门用于磷酸化标记项目数据分析和可视化绘图；

#       2.所绘制的图表有：（按照生成的目录分）
#       （1）目录一：Statistics
#        中文：1.磷酸化蛋白组鉴定结果统计柱状图
#        英文：1.Statistical_histogram_of_phosphorylation_protein_group.p*

#        中文：2.磷酸化蛋白分子质量分布图
#        英文：2.Molecular_weight_distribution_of_phosphorylation_protein.p*

#        中文：3.磷酸化蛋白位点数量分布图
#        英文：3. Quantitative_distribution_of_phosphorylation_protein_sites.p*

#        中文：4.磷酸化肽段位点数量分布图
#        英文：4.Quantitative_distribution_of_phosphorylation_peptide_sites.p*

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
#	（2）在比较组差异位点序列上寻找磷酸化Motif：S（serine,Ser，丝氨酸）、T（threonine,Thr，苏氨酸）和Y（tyrosine,Tyr，酪氨酸）
#       4.Motif分析采用软件MEME进行，所以本脚本中的Motif分析的功能注释掉，不使用了

# /Usage: runphosp
########################################################################################################
#
## 脚本运行计时开始
pt=proc.time()

## 项目分析日期
print("磷酸化蛋白标记项目分析及绘图日志开始时间：")
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
# analysis_need_packages <- c("ggplot2", "plotrix", "openxlsx","pcaMethods", "readxl", "plot3D", "ggrepel", "corrplot", "motifStack", "rmotifx", "argparse", "progress", "ggrepel")
analysis_need_packages <- c("ggplot2", "plotrix", "openxlsx", "readxl", "ggrepel", "corrplot", "argparse", "progress", "ggrepel")
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

## 3.读取数据及数据处理
### 3.3 磷酸化蛋白组鉴定结果统计柱状图("Phospho Proteins", "Phospho Peptides", "Phospho Sites")
p3_data <- read.table("./stats_data/ppp.txt", sep = "\t")
N <- p3_data$V2
ymax <- max(N)
# par(mgp=c(1.6,0.6,0),mar=c(rep(5,4)))# mgp指坐标轴与图之前的距离，mar指整个图的边界距离

### 新建一个Statistics目录
dir()
if (dir.exists("Statistics")){
  list.dirs("./Statistics")
  list.files("./Statistics")
}else{
  dir.create("./Statistics")
  dir.exists("Statistics")
}

setwd("./Statistics")

### plotting
png("3.Phosphorylated_protein-peptide-site_statistics_barplot.png", type = "cairo-png", width = 1000, height = 1000)
# par(mgp=c(3,0.8,0),mar=c(7,18,10,18), mai=c(2,1.8,2,1.8))
par(mai=c(2,1.8,0.8,1.8))
bp <- barplot(N, width = 3, col = c("blue", "orangered", "darkgreen"), names.arg = c("Proteins", "Peptides", "Sites"), legend = c("Phospho Proteins", "Phospho Peptides", "Phospho Sites"), xlab = NULL, ylab = c("Number"), ylim = c(0, ymax + ymax/3), axes = T, xpd = F, axisnames = TRUE, horiz = F, space= 1.5, beside = TRUE, cex.names = 1.8, cex.axis = 1.8, cex.lab = 2, args.legend = list(x = "top"))
N2 <- N + 100
text(bp, N2, format(N), xpd = TRUE, col = "black", cex = 1.8)
dev.off()

pdf("3.Phosphorylated_protein-peptide-site_statistics_barplot.pdf", width = 10, height = 10)
# par(mgp=c(3,0.8,0),mar=c(7,18,9,18), mai=c(2,1.8,2,1.8))
par(mai=c(2,1.8,0.8,1.8))
bp <- barplot(N, width = 3, col = c("blue", "orangered", "darkgreen"), names.arg = c("Proteins", "Peptides", "Sites"), legend = c("Phospho Proteins", "Phospho Peptides", "Phospho Sites"), xlab = NULL, ylab = c("Number"), ylim = c(0, ymax + ymax/3), axes = T, xpd = F, axisnames = TRUE, horiz = F, space= 1.5, beside = TRUE, cex.names = 1.5, cex.axis = 1.5, cex.lab = 1.5, args.legend = list(x = "top"))
N2 <- N + 100
text(bp, N2, format(N), xpd = TRUE, col = "black", cex = 1.8)
dev.off()

# 跳出Statistics目录
dir()
setwd("../")
dir()

### 3.2 磷酸化蛋白位点数量分布图
pro_sites_n <- read.table("./stats_data/pro-n.txt", sep = "\t", header = F)
dim(pro_sites_n)
colnames(pro_sites_n) <- c("Sites", "Freq")

# 跳入Statistics目录
setwd("./Statistics")

#### plotting
ggplot(pro_sites_n, aes(x = Sites, y = Freq)) +
  geom_histogram(stat = "identity", binwidth = 3, col = "Black", fill = "dodgerblue") +
  xlab(label = "Number of Phosphorylated Sites in a protein") +
  ylab(label = "Phosphorylated Protein numbers") +
  theme_bw() +
  theme(panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), axis.line = element_line(colour = "black")) +
  geom_text(aes(label = Freq, vjust = -0.8, hjust = 0.5), size = 2) +
  theme(plot.margin = unit(rep(4,4),'lines'), aspect.ratio = 0.5)
ggsave("2.Quantitative_distribution_of_phosphorylated_protein_sites.pdf", width = 12, height = 7.5, units = "in")
ggsave("2.Quantitative_distribution_of_phosphorylated_protein_sites.png", width = 12, height = 7.5, units = "in")

# 再跳出Statistics目录
dir()
setwd("../")
dir()

### 3.1 磷酸化蛋白分子质量分布图
mw_data <- read.table("./stats_data/mw.txt", sep = "\t", header = T)
dim(mw_data)
class(mw_data)
colnames(mw_data)
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
ggsave("1.Molecular_weight_distribution_of_phosphorylated_protein.pdf", width = 12, height = 7.5, units = "in")
ggsave("1.Molecular_weight_distribution_of_phosphorylated_protein.png", width = 12, height = 7.5, units = "in")

# 再跳出
dir()
setwd("../")
dir()

### 3.4磷酸化肽段位点数量分布图
pep_n_data <- read.table("./stats_data/pep-n.txt", sep = "\t")
colnames(pep_n_data) <- c("Phoph_Sites_N", "Counts")
head(pep_n_data)

# 再跳入Statistics目录
setwd("./Statistics")

A <- pep_n_data$Counts[1]
B <- pep_n_data$Counts[2]
C <- pep_n_data$Counts[3]
D <- sum(pep_n_data$Counts[pep_n_data$Phoph_Sites_N>3])

# test <- sum(pep_n_data$Counts[pep_n_data$Phoph_Sites_N>1])
# test
x <- c(A, B, C, D)
x

# A
A_lab1 <- A /sum(A + B + C + D)
print(A_lab1)
A_Lab_OK <- paste(A, ";", paste("Percentage:", sprintf("%.2f",A_lab1*100), "%"))
A_Lab_OK

# B
B_lab1 <- B / sum(A + B + C + D)
B_lab1
B_Lab_OK <- paste(B, ";", paste("Percentage:", sprintf("%.2f",B_lab1*100), "%"))
B_Lab_OK

# C
C_lab1 <- C / sum(A + B + C + D)
C_lab1
C_Lab_OK <- paste(C, ";", paste("Percentage:", sprintf("%.2f",C_lab1*100), "%"))
C_Lab_OK

# D
D_lab1 <- D / sum(A + B + C + D)
D_lab1
D_Lab_OK <- paste(D, ";", paste("Percentage:", sprintf("%.2f",D_lab1*100), "%"))
D_Lab_OK

labels <- c(paste("Phosphosites 1, Peptides_number", A_Lab_OK), paste("Phosphosites 2, Peptides_number", B_Lab_OK), paste("Phosphosites 3, Peptides_number", C_Lab_OK), paste("Phosphosites >3, Peptides_number", D_Lab_OK))
pdf("4.Quantitative_distribution_of_phosphorylated_peptide_sites.pdf", width = 15, height = 8.5)
# pie(x, labels = labels, col = c("lightseagreen", "dodgerblue", "gold", "darkviolet"), main = "Peptide_number-proteins", border = FALSE)
# pie(x, labels = labels, col = c("purple", "yellow2", "red2", "green3"), main = "Peptide_number-proteins", border = FALSE)
pie(x, labels = labels, lwd = 15, col = c("purple", "yellow2", "red2", "green3"), border = FALSE)
dev.off()

png("4.Quantitative_distribution_of_phosphorylated_peptide_sites.png", width = 1500, height = 850)
# pie(x, labels = labels, col = c("lawngreen", "lightblue", "lightseagreen", "darkviolet"), main = "Peptide_number-proteins", border = FALSE)
# pie(x, labels = labels, col = c("purple", "yellow2", "red2", "green3"), main = "Peptide_number-proteins", border = FALSE)
pie(x, labels = labels, lwd = 30, col = c("purple", "yellow2", "red2", "green3"), border = FALSE)
dev.off()
# pdf(paste0(abc,"_Peptide_coverage_2D.pdf"), width = 12, height = 7.5)
# png(paste0(abc,"_Peptide_coverage_2D.png"), type = "cairo", width = 1200, height = 750)

# 再跳出
dir()
setwd("../")
dir()

### 3.5 STY位点分布图
sty_data <- read.table("./stats_data/STY.txt", sep = "\t")
print(sty_data)
colnames(sty_data) <- c("Site", "Number")

# 再次跳入Statistics目录
setwd("./Statistics")

Ss <- sty_data$Number[1]
Ss
Ts <- sty_data$Number[2]
Ts
Ys <- sty_data$Number[3]
Ys

y <- c(Ss, Ts, Ys)

Ss_lab <- Ss / sum(Ss + Ts + Ys)
Ts_lab <- Ts / sum(Ss + Ts + Ys)
Ys_lab <- Ys / sum(Ss + Ts + Ys)

Ss_Lab_OK <- paste("S; ", paste("Percentage:", sprintf("%.2f",Ss_lab*100), "%"))

Ts_Lab_OK <- paste("T; ", paste("Percentage:", sprintf("%.2f",Ts_lab*100), "%"))

Ys_Lab_OK <- paste("Y; ", paste("Percentage:", sprintf("%.2f",Ys_lab*100), "%"))

labels <- c(Ss_Lab_OK, Ts_Lab_OK, Ys_Lab_OK)

pdf("5.STY_locus_distribution.pdf", width = 12, height = 8.5)
pie(y, labels = labels, lwd = 20, col = c("deepskyblue", "tomato", "chartreuse"), main = "STY sites distribution", border = FALSE)
dev.off()

png("5.STY_locus_distribution.png", width = 1200, height = 850)
pie(y, labels = labels, lwd = 30, col = c("deepskyblue", "tomato", "chartreuse"), main = "STY sites distribution", border = FALSE)
dev.off()

# 再次跳出
dir()
setwd("../")
dir()

# ### 3.6磷酸化位点丰度比分布图
# ## 3.读取数据
# #############################################################################
# ### 3.1 sample_information
# sample_info_1 <- read.xlsx("sample_information.xlsx", sheet = "样品信息", startRow = 1, colNames = TRUE, rowNames = FALSE, detectDates = FALSE)
# sample_info_2 <- read.xlsx("sample_information.xlsx", sheet = "比较组信息", startRow = 1, colNames = TRUE, rowNames = FALSE, detectDates = FALSE)
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
#   # print(sample_info[i,1])
#   # print(gsub("/","_",sample_info[i,1]))
#   class(gsub("/","_",sample_info_2[i,1]))
#   new_compa_groups <- gsub("/","_",sample_info_2[i,1])
#   class(new_compa_groups)
#   # dim(new_compa_groups)
#   print(new_compa_groups)
#   data <- read.xlsx("预处理数据.xlsx", sheet = new_compa_groups, startRow = 1, colNames = TRUE, rowNames = FALSE, detectDates = FALSE)
#   dim(data)
#   class(data)
#   rownames(data)
#   ## 新建一个Abundance_distribution_map目录
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
#     pdf(paste0(i,".Phosphorylated_Sites_Abundance_distribution_",new_compa_groups,".pdf"), width = 12, height = 7.5)
#     # hist(data_new[,2],col="greenyellow",freq=FALSE,breaks=30,
#     hist(data_new[,2],col="limegreen",freq=FALSE,breaks=30,
#          main="Phosphorylated Sites Ratio Distribution",
#          xlab="log2(FC)",ylab="Number of Phosphorylated Sites")
#     dev.off()
#     png(paste0(i,".Phosphorylated_Sites_Abundance_distribution_",new_compa_groups,".png"), width = 1200, height = 750)
#     hist(data_new[,2],col="limegreen",freq=FALSE,breaks=30,
#          main="Phosphorylated Sites Ratio Distribution",
#          xlab="log2(FC)",ylab="Number of Phosphorylated Sites")
#     dev.off()
#     write.csv(data, file = paste0(i,".Phosphorylated_Sites_Abundance_distribution_",new_compa_groups,"_data.csv"))
#     dir()
#   }
#   setwd("../")
#   dir()
# }
# 
# if (dir.exists("Abundance_distribution_map")){
#   print("比较组差异磷酸化位点丰度比分布图已经绘制完成，请查看目录Abundance_distribution_map")
#   list.files("./Abundance_distribution_map")
# }else{
#   print("注意：本项目样本数据不适合绘制比较组差异磷酸化位点丰度比分布图，所以不绘制比较组差异磷酸化位点丰度比分布图！")
# }
# 
# if (length(list.files("./Abundance_distribution_map")) == 0){
#   unlink("Abundance_distribution_map", recursive = TRUE, force = FALSE)
# } # 判断Abundance_distribution_map目录是否是空目录，如果是空目录就删掉


# ### 3.7PCA图
# ## 3.读取测试数据：项目的差异位点筛选结果文件（格式为.xlsx）
# ### 3.1判断差异位点筛选结果文件中的是否有“可信蛋白”，还是有“合并可信蛋白”，对应导入数据
# if ("合并可信位点" %in% readxl::excel_sheets("./差异位点筛选结果.xlsx") == TRUE){
#   trusted_sites <- read.xlsx("./差异位点筛选结果.xlsx", sheet = "合并可信位点", startRow = 1, colNames = TRUE, rowNames = FALSE, detectDates = FALSE)
#   print("合并可信位点原始数据大小为：")
#   dim(trusted_sites)
# }else if ("可信位点" %in% readxl::excel_sheets("./差异位点筛选结果.xlsx") == TRUE){
#   trusted_sites <- read.xlsx("./差异位点筛选结果.xlsx", sheet = "可信位点", startRow = 1, colNames = TRUE, rowNames = FALSE, detectDates = FALSE)
#   print("可信位点原始数据大小为：")
#   dim(trusted_sites)
# }else if ("总可信位点" %in% readxl::excel_sheets("./差异位点筛选结果.xlsx") == TRUE){
#   trusted_sites <- read.xlsx("./差异位点筛选结果.xlsx", sheet = "总可信位点", startRow = 1, colNames = TRUE, rowNames = FALSE, detectDates = FALSE)
#   print("可信位点原始数据大小为：")
#   dim(trusted_sites)
# }
# ## 4.数据处理：对可信蛋白数据进行提取和处理
# if ("MIX" %in% colnames(trusted_sites) == TRUE){
#   trusted_sites$MIX <- NULL
# }else if ("Mix" %in% colnames(trusted_sites) == TRUE){
#   trusted_sites$Mix <- NULL
# }else if (length(colnames(trusted_sites)) != 0){
#   print("查看处理过MIX/Mix问题后的可信位点数据大小：")
#   dim(trusted_sites)
# }
# print("查看trusted_sites的列名：")
# colnames(trusted_sites)
# head(trusted_sites[,1])
# colnames(trusted_sites)[1]
# # [1] "Proteins"
# # colnames(trusted_sites)[1] <- ""
# # colnames(trusted_sites)[1]
# # [1] ""
# head(row.names(trusted_sites))
# head(rownames(trusted_sites))
# 
# ### 4.1 样品数据匹配
# Sample_info <- read.xlsx("sample_information.xlsx", sheet = "样品信息", startRow = 1, colNames = TRUE, rowNames = FALSE, detectDates = FALSE) # 读取sample_information.xlsx>表格中的信息
# print("查看读取的Sample_info的数据中的样品信息：")
# Sample_info
# 
# Sample_info$作图编号 <- NULL
# colnames(Sample_info) <- c("Sample", "Sample_abc")
# Sample_info$Sample_abc <- gsub(" ", ".", Sample_info$Sample_abc) # 替换字符串
# sama <- match(Sample_info$Sample_abc, colnames(trusted_sites))
# print("查看Sample_abc在trusted_prot中匹配到的位置信息")
# sama
# 
# #### 根据样品位置信息进行数据重组
# trusted_sites_new <- trusted_sites[,sama]
# print("查看样品匹配后的数据大小：")
# dim(trusted_sites_new)
# 
# # 保存处理好的未进行行列转置的数据
# ## Create a new workbook
# wb <- createWorkbook("PCA_Data")
# 
# ## 在当前目录里创建一个PCA目录
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
# #### 写入trusted_prot_new数据
# addWorksheet(wb, "1.trusted_sites_new_data", tabColour = "red")
# writeData(wb, sheet = "1.trusted_sites_new_data", trusted_sites_new)
# saveWorkbook(wb, "PCA_Data.xlsx", overwrite = TRUE)
# # 数据框转换为矩阵，行列转置
# trusted_sites_new <- t(as.matrix(trusted_sites_new))
# # print("查看去掉无用信息后，行列转置后的数据行名、列名和大小：")
# dim(trusted_sites_new)
# row.names(trusted_sites_new)
# head(colnames(trusted_sites_new))
# class(trusted_sites_new)
# ### 4.2 计算PCA值：PC1、PC2和PC3，构建PCA对象
# trusted_sites_pca <- pca(trusted_sites_new, scale = "uv", nPcs = 3)
# print("查看PCA对象的数据类型：")
# class(trusted_sites_pca)
# # [1] "pcaRes"
# # attr(,"package")
# # [1] "pcaMethods"
# print("查看数据的PCA主成分数值，如下：")
# trusted_sites_pca@scores
# ### 4.3 合并PCA数据
# trusted_sites_pca_socr <- merge(trusted_sites_new, scores(trusted_sites_pca), by = 0)
# print("查看合并后的数据大小为：")
# dim(trusted_sites_pca_socr)
# ### 4.4 保存PCA计算后合并的新数据
# dir()
# 
# #### 写入trusted_prot_pca_plot数据
# addWorksheet(wb, "2.trusted_sites_pca_socr", tabColour = "orange")
# writeData(wb, sheet = "2.trusted_sites_pca_socr", trusted_sites_pca_socr)
# saveWorkbook(wb, "PCA_Data.xlsx", overwrite = TRUE)
# ### 4.5 读取Sample_info文件，构建绘图数据
# # print("查看读取的Sample_info的数据中的样品信息")
# head(Sample_info)
# class(Sample_info)
# dim(Sample_info)
# sn <- length(unique(Sample_info$Sample))
# print(paste0("样品数量为：",sn,"个"))
# class(trusted_sites_pca_socr)
# dim(trusted_sites_pca_socr)
# trusted_sites_pca_plot <- cbind(trusted_sites_pca_socr, Sample_info)
# dim(trusted_sites_pca_plot)
# 
# ## 5.绘制PCA 2D图和保存图片、数据
# #### 写入trusted_prot_pca_plot数据
# addWorksheet(wb, "5.trusted_proteins_plot_data", tabColour = "blue")
# writeData(wb, sheet = "5.trusted_proteins_plot_data", trusted_sites_pca_plot)
# saveWorkbook(wb, "PCA_Data.xlsx", overwrite = TRUE)
# 
# ### 5.1 计算PCA方差占比（解释率）
# pc1_sdev <- sd(trusted_sites_pca_socr$PC1)
# pc2_sdev <- sd(trusted_sites_pca_socr$PC2)
# pc1_percent_variance <- pc1_sdev^2/sum(pc1_sdev^2 + pc2_sdev^2) * 100
# print(paste0("PC1的方差占比为：", pc1_percent_variance))
# pc2_percent_variance <- pc2_sdev^2/sum(pc1_sdev^2 + pc2_sdev^2) * 100
# print(paste0("PC2的方差占比为：", pc2_percent_variance))
# 
# pc1_percent_variance <- as.data.frame(pc1_percent_variance)
# pc2_percent_variance <- as.data.frame(pc2_percent_variance)
# percentVar2D <- cbind(pc1_percent_variance, pc2_percent_variance)
# 
# ### 5.2 保存PC1和PC2主成分方差占比数据
# #### 写入PCA 2D和3D的主成分占比（解释率）
# addWorksheet(wb, "3.percentVar2D", tabColour = "yellow")
# writeData(wb, sheet = "3.percentVar2D", percentVar2D)
# saveWorkbook(wb, "PCA_Data.xlsx", overwrite = TRUE)
# 
# ### 5.3 绘制二维PCA图
# # 保存pdf格式
# # 增加对样品数量的判断，从而可以自适应图片中样品点的大小和是否做stat_ellipse()统计
# 
# if (sn >= 3){
#   ggplot(trusted_sites_pca_plot, aes(trusted_sites_pca_plot$PC1,trusted_sites_pca_plot$PC2, colour = Sample)) +
#     geom_point(size = 5) +
#     geom_text_repel(aes(label = trusted_prot_pca_plot$Sample_abc)) +
#     # geom_text(label = trusted_sites_pca_plot$Sample_abc, size = 3, check_overlap = F, col = "black", hjust = "center", vjust = "middle") +
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
#   ggplot(trusted_sites_pca_plot,aes(trusted_sites_pca_plot$PC1,trusted_sites_pca_plot$PC2, colour = Sample)) +
#     geom_point(size = 5) +
#     geom_text_repel(aes(label = trusted_prot_pca_plot$Sample_abc)) +
#     # geom_text(label = trusted_sites_pca_plot$Sample_abc, size = 3, check_overlap = F, col = "black", hjust = "center", vjust = "middle") +
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
# ## 6.计算PCA三个主成分的方差占比
# pc1_sdev <- sd(trusted_sites_pca_socr$PC1)
# pc2_sdev <- sd(trusted_sites_pca_socr$PC2)
# pc3_sdev <- sd(trusted_sites_pca_socr$PC3)
# 
# PC1_percent_variance <- pc1_sdev^2/sum(pc1_sdev^2 + pc2_sdev^2 + pc3_sdev^2) * 100
# print(paste0("PC1方差占比为：", PC1_percent_variance))
# 
# PC2_percent_variance <- pc2_sdev^2/sum(pc1_sdev^2 + pc2_sdev^2 + pc3_sdev^2) * 100
# print(paste0("PC2方差占比为：", PC2_percent_variance))
# PC3_percent_variance <- pc3_sdev^2/sum(pc1_sdev^2 + pc2_sdev^2 + pc3_sdev^2) * 100
# print(paste0("PC3方差占比为：", PC3_percent_variance))
# 
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
# ## 保存Sample_info数据
# addWorksheet(wb, "6.Sample_info", tabColour = "purple")
# writeData(wb, sheet = "6.Sample_info", Sample_info)
# saveWorkbook(wb, "PCA_Data.xlsx", overwrite = TRUE)
# 
# write.csv(Sample_info, file = "Sample_info.csv")
# Sample_info <- read.table("Sample_info.csv", sep = ',', header = TRUE)
# trusted_sites_pca_plot <- cbind(trusted_sites_pca_socr, Sample_info)
# dim(trusted_sites_pca_plot)
# 
# ## 删除Sample_info.csv文件
# unlink("Sample_info.csv", recursive = FALSE, force = FALSE)
# 
# ## 7.绘制3D图
# #############################################################################
# ### 7.1根据样品数量决定样品颜色和图例的格式大小 ##
# # col <- c("orange", "green", "magenta","red","pink","blue","darkgreen","yellow", "brown", "turquoise","cyan","gold","aquamarine","tomato","tan","lawngreen","cornflowerblue","hotpink","firebrick","darkviolet")
# col <- c("orange", "green", "magenta","red","pink","blue","darkgreen","yellow", "brown", "turquoise","cyan","gold","aquamarine","tomato","tan","lawngreen","cornflowerblue","hotpink","firebrick","darkviolet","orangered", "orchid","darkmagenta","snow4","slateblue","rosybrown","deepskyblue","lightseagreen","darkviolet","azure4")
# 
# sacol <- sample(col,sn)
# sl <- sn/10.0
# pdf("PCA_3D.pdf", width = 12, height = 7.5)
# scatter3D(x = trusted_sites_pca_plot$PC1, y = trusted_sites_pca_plot$PC2, z = trusted_sites_pca_plot$PC3, xlab = paste0("PC1 ", round(percentVar3D$PC1_percent_variance,2), "% variance"), ylab = paste0("PC2 ", round(percentVar3D$PC2_percent_variance,2), "% variance"), zlab = paste0("PC3 ", round(percentVar3D$PC3_percent_variance,2), "% variance"), labels = trusted_sites_pca_plot$Sample_abc, col = sacol, phi = 5, theta = 32, bty = 'b2', pch = 20, cex = 5, ticktype = "detailed", plot = TRUE, adj = 0.5, font = 2, colkey = list(at = spos, side = 4, addlines = FALSE, length = sl, width = 0.6, labels = unique(trusted_sites_pca_plot$Sample), cex.clab = 1.5), clab = "Sample", colvar = as.integer(trusted_sites_pca_plot$Sample))
# dev.off()
# 
# png("PCA_3D.png", width = 1200, height = 750)
# scatter3D(x = trusted_sites_pca_plot$PC1, y = trusted_sites_pca_plot$PC2, z = trusted_sites_pca_plot$PC3, xlab = paste0("PC1 ", round(percentVar3D$PC1_percent_variance,2), "% variance"), ylab = paste0("PC2 ", round(percentVar3D$PC2_percent_variance,2), "% variance"), zlab = paste0("PC3 ", round(percentVar3D$PC3_percent_variance,2), "% variance"), labels = trusted_sites_pca_plot$Sample_abc, col = sacol, phi = 5, theta = 32, bty = 'b2', pch = 20, cex = 5, ticktype = "detailed", plot = TRUE, adj = 0.5, font = 2, colkey = list(at = spos, side = 4, addlines = FALSE, length = sl, width = 0.6, labels = unique(trusted_sites_pca_plot$Sample), cex.clab = 1.5), clab = "Sample", colvar = as.integer(trusted_sites_pca_plot$Sample))
# dev.off()
# 
# dir()
# list.files()
# setwd("../")
# dir()
# print("PCA分析及绘图完成！请查看PCA目录中的图片和数据文件PCA_Data.xlsx。")
# list.files("./PCA")
# 
# ########################################################################################################
# #### 4.Motif分析 #########	##########S##########	#############T#########	#############Y##########
# ########################################################################################################
# ## 获得差异位点筛选结果的中sheet为Phospho (STY)Sites的数据
# bg<-read.xlsx("差异位点筛选结果.xlsx", sheet = "原始数据")
# ## 测试 ##
# # fg<-read.xlsx("foreground.xlsx",sheet=1)
# # bg<-read.xlsx("background.xlsx",sheet=1)
# ##      ##
# for (abc in compa_groups) {
#   class(gsub("/","_",sample_info_2[abc,1]))
#   new_compa_groups <- gsub("/","_",sample_info_2[abc,1])
#   class(new_compa_groups)
#   print(new_compa_groups)
#   fg <- read.xlsx("差异位点筛选结果.xlsx", sheet = new_compa_groups, startRow = 1, colNames = TRUE, rowNames = FALSE, detectDates = FALSE)
#   dim(fg)
#   class(fg)
#   rownames(fg)
#   ## 新建一个Motif目录
#   dir()
#   if (dir.exists("Motif")){
#     list.dirs("./Motif")
#     list.files("./Motif")
#   }else{
#     dir.create("./Motif")
#     dir.exists("Motif")
#   }
#   # [1] TRUE
#   setwd("./Motif")
#   dir()
#   
#   ## motif()函数
#   Motif<-function(fg,bg,minseq,pvalue){
# 	fg<-fg[,11]
# 	bg<-bg[,11]
# 	test<-fg
#   #将文件转换为相同长度
# 	min(nchar(test))->sl
# 	fgd<-c()
# 	for(i in 1:length(test)){
# 		(nchar(test[i])+1)/(sl+1)->tim
# 		if(tim>1){
# 			c(fgd,strsplit(test[i],";")[[1]])->fgd
# 			}else fgd<-c(fgd,test[i])
# 	}
# 	bgd<-c()
# 	bg<-na.omit(bg)
# 	for(i in 1:length(bg)){
# 		(nchar(bg[i])+1)/(sl+1)->tim
# 		if(tim>1){
# 			c(bgd,strsplit(bg[i],";")[[1]])->bgd
# 		}else bgd<-c(bgd,bg[i])
# 	}
# #motif analysis
# 	# mot = motifx(fgd,bgd,central.res = 'S', min.seqs = minseq, pval.cutoff = pvalue)
# 	cen<-c("S","T","Y")
# 	for(i in 1:3){
# 		mot = motifx(fgd,bgd,central.res = cen[i], min.seqs = minseq, pval.cutoff = pvalue)
#     		mot <- head(mot, n = 3)
# 		assign(paste("mot", i, sep=""), mot)
# 	}
# 	moot<-rbind(mot1,mot2,mot3)
# 	write.xlsx(moot, paste0(abc,".",new_compa_groups,"_motif.xlsx"))
# 
# #获取fg拆分矩阵 初始化mymat(motifStack频率矩阵)
# for(m in 1:3){
# 	if(length(get(paste("mot",m,sep="")))!=0){
# 	print(get(paste("mot",m,sep="")))
# 
# 	c()->sec
# 
# #	if(length(mot)!=0){
# #	print(mot)
# #	write.xlsx(mot, paste0(abc,".",new_compa_groups,"_motif.xlsx"))
# #	c()->sec		
# 	for(i in 1:length(fgd)){
# 		strsplit(fgd[i],"")[[1]]->fri
# 		rbind(sec,fri)->sec
# 	}
# 	mymat<-matrix(nrow=20,ncol=sl) 
# 	mymat<-as.data.frame(mymat)
# 	amino<-c("A","C","D","E","F","G","H","I","K","L","M","N","P","Q","R","S","T","V","W","Y")
# 	rownames(mymat)<-amino
# 	colnames(mymat)<-rep(1:sl)
# #分别获取motifs用于motifStack绘图数据
# #	for(k in 1:nrow(mot)){
# #	split<-strsplit(mot[k,1],"")[[1]]
# #	which(split!=".")->mos	#motif site
# #	split[mos]->moa		#motif amino
# #	if(length(mos)==2){
# #		sec[which(sec[,mos[1]]==moa[1] & sec[,mos[2]]==moa[2]),]->secs
# #	}else sec[which(sec[,mos[1]]==moa[1] & sec[,mos[2]]==moa[2] & sec[,mos[3]]==moa[3]),]->secs
# 	for(k in 1:nrow(get(paste("mot",m,sep="")))){
# 	split<-strsplit(get(paste("mot",m,sep=""))[k,1],"")[[1]]
# 	which(split!=".")->mos	#motif site
# 	split[mos]->moa		#motif amino
# 	if(length(mos)==2){
# 		sec[which(sec[,mos[1]]==moa[1] & sec[,mos[2]]==moa[2]),]->secs
# 	}else sec[which(sec[,mos[1]]==moa[1] & sec[,mos[2]]==moa[2] & sec[,mos[3]]==moa[3]),]->secs
# #统计个数
# 	for(j in 1:sl){
# 		table(secs[,j])->mt
# 		names(mt)->nmt
# 		for(i in 1:20){
# 			if(amino[i] %in% nmt){
# 				mt[[which(regexpr(amino[i],nmt)>0)]]->mymat[i,j]
# 			}else mymat[i,j]<-0
# 		}
# 	}
# 	assign(paste("mmm",k,sep=""),mymat)
# 	assign(paste("motif",k,sep=""),pcm2pfm(get(paste("mmm",k,sep=""))))
# 	assign(paste("momo",k,sep=""),new("pfm",mat=assign(paste("motif",k,sep=""),pcm2pfm(get(paste("mmm",k,sep="")))),name="",color=colorset(alphabet="AA",colorScheme="chemistry")))
# 	}
# #出图
# # 	pdf(paste0(abc, ".", new_compa_groups, "_Motif.pdf"), width=18, height=15)
# #         # png(paste0(abc, ".", new_compa_groups, "_Motif.png"), type = "cairo-png", units = "px", pointsize = 24, width=1800,height=1000)
# # 	par(mfrow=c(nrow(mot),1))
# # 	for(k in 1:nrow(mot)){	
# # 		if(k<nrow(mot))
# # 			plot(get(paste("momo",k,sep="")),xlab="",xaxis=FALSE)
# # 		else plot(get(paste("momo",k,sep="")),xlab="")		
# # 	}
# # 	dev.off()
# # 	png(paste0(abc, ".", new_compa_groups, "_Motif.png"), type = "cairo-png", units = "px", pointsize = 30, width=1800,height=1500)
# # 	par(mfrow=c(nrow(mot),1))
# #         for(k in 1:nrow(mot)){
# #                 if(k<nrow(mot))
# #                         plot(get(paste("momo",k,sep="")),xlab="",xaxis=FALSE)
# #                 else plot(get(paste("momo",k,sep="")),xlab="")
# #         }
# #         dev.off()
# 	if(nrow(get(paste("mot",m,sep=""))) >1){
# 	pdf(paste0(abc,".Motif_all_",new_compa_groups,"_",cen[m],".pdf"), width=18,height=12)
# 	par(mfrow=c(nrow(get(paste("mot",m,sep=""))),1))
# 	for(k in 1:nrow(get(paste("mot",m,sep="")))){
# 		if(k<nrow(get(paste("mot",m,sep=""))))
# 			plot(get(paste("momo",k,sep="")),xlab="",xaxis=FALSE)
# 		else plot(get(paste("momo",k,sep="")),xlab="")
# 	}
# 	dev.off()
# 	}
# # 绘制单独的motif图
# 	# for(k in 1:nrow(mot)){
# 	# 	pdf(paste0(abc, ".", new_compa_groups, "_Motif-",k,".pdf"), width=16, height=10)
# 		# png(paste0(abc, ".", new_compa_groups, "_Motif-",k,".png"), type = "cairo-png", units = "px", pointsize = 24, width=1600, height=1000)
# 	#	plot(get(paste("momo",k,sep="")),xlab="",xaxis=TRUE)
# 	#	dev.off()}
# 	# for(k in 1:nrow(mot)){
#         #        png(paste0(abc, ".", new_compa_groups, "_Motif-",k,".png"), type = "cairo-png", units = "px", pointsize = 30, width=1600, height=1000)
#         #        plot(get(paste("momo",k,sep="")),xlab="",xaxis=TRUE)
#         #        dev.off()}
# 	#}else
# 	#	print("NULL, please change your parameter!")
# #}
# 	for(k in 1:nrow(get(paste("mot",m,sep="")))){
# 		pdf(paste0(abc,".Motif_",new_compa_groups,"_",cen[m],"-",k,".pdf"), width=16, height=8)
# 		plot(get(paste("momo",k,sep="")),xlab="",xaxis=TRUE)
# 		dev.off()}
# 	}else
# 		print("NULL, please change your parameter!")
# 
# }
# setwd("../")
# }
#   ## 运行motif函数
#   Motif(fg,bg,minseq,pvalue)
#   dir()
#   setwd("../")
#   dir()
# }
# # source("/public/hstore5/proteome/pipeline/script/project_r_plotting/Motif.R")
 
## 4.结束
print("输出R包和环境变量信息：")
sessionInfo()
print("磷酸化标记项目R绘图已经完成，请下载本地查看图片数据和文件")
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
