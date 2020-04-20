########################################################################################################################################
# Rscript function: 绘图脚本升级，绘制2D和3D的PCA图
# Author: jingxinxing
# Date: 2019/08/23
# Version: 7
# New: 1.对于PCA 2D部分，增加对样品数量的判断，从而决定绘制2D的PCA图的样本点大小以及是否填加stat_ellipse；
#      2.对于PCA 3D部分，对图例进行了美化，指定样品的颜色块，而不是渐变颜色条；同样也增加了样品数据判断，从而决定图例的大小和颜色。
#      3.修改样品数据抓取方式，之前是删除可信蛋白（sheet）固定11列的无用信息，现在是用样品Sample_info.csv中的Sample_abc这一列进行匹（match()）配数据，
#	匹配到就把后面分析用的数据提取出来了
#      4.修复3D的PCA图无法保存为pdf格式问题
#      5.不需要手动再配置一个Sample_info.csv文件了，直接用项目分析时配置的“sample_information.xlsx”文件和“差异蛋白筛选结果.xlsx”文件
#      6.对2D的点大小和文件标签做了调整
#      7.DIA项目样品PCA降维展示
#      8.PCA数据保存在一个Excel表格中：PCA_Data.xlsx
#      9.新建PCA目录，数据保存在PCA目录中：PCA
#########################################################################################################################################
#Usage: You need to prepare "差异蛋白筛选结果.xlsx" file and sample information file: sample_info.csv(two column: one is "Sample", other is "Sample_abc");
#1. Use R packages: "openxlsx","pcaMethods","ggplot2","readxl","plot3D"
#2. Build data or vector of name and description:
#(1) trusted_prot, trusted peoteins data, if has combine trusted proteins data, it is combines;
#(2) trusted_prot_new, the clean of row is samples and column is preteins matrix data;
#(3) trusted_prot_pca, pca() compute and build the pca data object;
#(4) trusted_prot_pca_socr, the trusted_prot_new and trusted_prot_pca combine data;
#(5) trusted_prot_pca_plot, cbine() the trusted_prot_pca_socr and Sample_info;
#(6) pc1_sdev, pc1_percent_variance and pc2_sdev, pc2_percent_variance, in order to calcuate PCA explain variance or PCA variance percent;
#(7) percentVar2D, save PC1 and PC2 of variance percent data;
#(9) percentVar3D, save PC1 PC2 and PC3 of variance percent data;
#(10) sn, samples of number.
pt=proc.time()
print("蛋白DIA项目PCA分析及绘图日志开始时间：")
# d <- date()
d <- Sys.Date()
print(d)
print("当前日期是：")
weekdays(d)
months(d)
quarters(d)
julian(d)
print("国际标准时间是：")
d2 <- date()
print(d2)
print("分析开始：Start")
print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>processing>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")

## 1.修改当前的工作目录
setwd("./")
getwd()
# setwd("D:/工作空间/鹿明生物蛋白质组学信息分析/研发/R_projects/PCA-DIA绘图脚本v1")
## 2.批量导入R包
anal.needs.pacg <- c("openxlsx","pcaMethods","ggplot2","readxl","plot3D","ggrepel")
sapply(anal.needs.pacg, library, character.only = T)

## 3.读取测试数据：项目的差异蛋白筛选结果文件（格式为.xlsx）
### 3.1判断差异蛋白筛选结果文件中的是否有“可信蛋白”，还是有“合并可信蛋白”，对应导入数据
if ("合并可信蛋白" %in% readxl::excel_sheets("./差异蛋白筛选结果.xlsx") == TRUE){
  trusted_prot <- read.xlsx("./差异蛋白筛选结果.xlsx", sheet = "合并可信蛋白", startRow = 1, colNames = TRUE, rowNames = FALSE, detectDates = FALSE)
  print("合并可信蛋白原始数据大小为：")
  dim(trusted_prot)
}else if ("合并可信蛋白" %in% readxl::excel_sheets("./差异蛋白筛选结果.xlsx") == FALSE){
  trusted_prot <- read.xlsx("./差异蛋白筛选结果.xlsx", sheet = "可信蛋白", startRow = 1, colNames = TRUE, rowNames = FALSE, detectDates = FALSE)
  print("可信蛋白原始数据大小为：")
  dim(trusted_prot)
}
## 4.数据处理：对可信蛋白数据进行提取和处理
if ("MIX" %in% colnames(trusted_prot) == TRUE){
  trusted_prot$MIX <- NULL
}else if ("Mix" %in% colnames(trusted_prot) == TRUE){
  trusted_prot$Mix <- NULL
}else if (length(colnames(trusted_prot)) != 0){
  print("查看处理过MIX/Mix问题后的可信蛋白数据大小：")
  dim(trusted_prot)
}
# head(rownames(trusted_prot))
# [1] "1" "2" "3" "4" "5" "6"
print("查看trusted_prot的列名：")
colnames(trusted_prot)
head(trusted_prot[,1])
colnames(trusted_prot)[1]
# [1] "Accession"
colnames(trusted_prot)[1] <- ""
colnames(trusted_prot)[1]
# [1] ""
row.names(trusted_prot) <- trusted_prot[,1]
head(rownames(trusted_prot))
### 4.1 去掉数据中无用的内容
# trusted_prot[,1:11] <- NULL

### 4.1 样品数据匹配
# Sample_info <- read.table("Sample_info.csv", sep = ',', header = TRUE)
Sample_info <- read.xlsx("sample_information.xlsx", sheet = "样品信息", startRow = 1, colNames = TRUE, rowNames = FALSE, detectDates = FALSE)
print("查看读取的Sample_info的数据中的样品信息")
Sample_info

Sample_info$作图编号 <- NULL
colnames(Sample_info) <- c("Sample", "Sample_abc")
sama <- match(Sample_info$Sample_abc, colnames(trusted_prot))
print("查看Sample_abc在trusted_prot中匹配到的位置信息")
sama

# 根据样品位置信息进行数据重组
trusted_prot_new <- trusted_prot[,sama]
print("查看样品匹配后的数据大小：")
dim(trusted_prot_new)

# 保存处理好的未进行行列转置的数据
## Create a new workbook
wb <- createWorkbook("PCA_Data")

## 在当前目录里创建一个PCA目录
dir()
dir.create("./PCA")
dir.exists("PCA")
# [1] TRUE
setwd("./PCA")

#### 写入trusted_prot_new数据
addWorksheet(wb, "1.trusted_proteins_new_data", tabColour = "red")
writeData(wb, sheet = "1.trusted_proteins_new_data", trusted_prot_new)
saveWorkbook(wb, "PCA_Data.xlsx", overwrite = TRUE)

# ## 写入trusted_prot_pca_plot数据
# addWorksheet(wb, "2.trusted_prot_pca_socr", tabColour = "orange")
# writeData(wb, sheet = "2.trusted_prot_pca_socr", trusted_prot_pca_socr)
# saveWorkbook(wb, "PCA_Data.xlsx", overwrite = TRUE)
# 
# ## 写入PCA 2D和3D的主成分占比（解释率）
# addWorksheet(wb, "3.percentVar2D", tabColour = "yellow")
# writeData(wb, sheet = "3.percentVar2D", percentVar2D)
# saveWorkbook(wb, "PCA_Data.xlsx", overwrite = TRUE)
# 
# addWorksheet(wb, "4.percentVar3D", tabColour = "green")
# writeData(wb, sheet = "4.percentVar3D", percentVar3D)
# saveWorkbook(wb, "PCA_Data.xlsx", overwrite = TRUE)
# 
# ## 写入trusted_prot_pca_plot数据
# addWorksheet(wb, "5.trusted_proteins_plot_data", tabColour = "blue")
# writeData(wb, sheet = "5.trusted_proteins_plot_data", trusted_prot_pca_plot)
# saveWorkbook(wb, "PCA_Data.xlsx", overwrite = TRUE)
# 
# ## 写入Sample_info数据
# addWorksheet(wb, "6.Sample_info", tabColour = "purple")
# writeData(wb, sheet = "6.Sample_info", Sample_info)
# saveWorkbook(wb, "PCA_Data.xlsx", overwrite = TRUE)
# 
# # write.xlsx(trusted_prot_new, file = "PCA_Data.xlsx", sheetName = "trusted_proteins_new_data", colNames = TRUE, rowNames = TRUE, firstRow = TRUE, overwrite = TRUE)

# write.csv(trusted_prot_new, file = "trusted_proteins_new_data.csv")

# 数据框转换为矩阵，行列转置
trusted_prot_new <- t(as.matrix(trusted_prot_new))
# print("查看去掉无用信息后，行列转置后的数据行名、列名和大小：")
dim(trusted_prot_new)
row.names(trusted_prot_new)
head(colnames(trusted_prot_new))
class(trusted_prot_new)
# print("查看trusted_prot_new的前1:5行和前1:5列的数据，如下：")
# trusted_prot_new[1:5,1:5]
#          Q9UQ35 P19338 A9Z1X7 Q13428 Q02880
#Aucan-1     97.3   99.1  102.5   87.7   99.3
#Aucan-2     98.4   99.1  100.0   87.9   98.3
#Aucan-3     97.1   98.3  103.7   87.0  101.2
#Aucan-4     97.4  100.1  100.6   87.7   99.7
#Control-1  104.6  112.0  100.1  110.0  100.7

### 4.2 计算PCA值：PC1、PC2和PC3，构建PCA对象
trusted_prot_pca <- pca(trusted_prot_new, scale = "uv", nPcs = 3)
print("查看PCA对象的数据类型：")
class(trusted_prot_pca)
# [1] "pcaRes"
# attr(,"package")
# [1] "pcaMethods"
print("查看数据的PCA主成分数值，如下：")
trusted_prot_pca@scores

### 4.3 合并PCA数据
trusted_prot_pca_socr <- merge(trusted_prot_new, scores(trusted_prot_pca), by = 0)
print("查看合并后的数据大小为：")
dim(trusted_prot_pca_socr)
# trusted_prot_pca_socr[1:5,1434:1437]
#  P11274       PC1       PC2        PC3
#1   81.0 -407.6388  66.79403  133.90762
#2   95.2 -342.8274  39.09280 -173.06715
#3  104.2 -420.2093  32.24630  126.22277
#4  101.7 -343.6204  28.30890 -130.38132
#5  119.5  264.3882 192.69146  -61.40081

### 4.4 保存PCA计算后合并的新数据
# write.csv(trusted_prot_pca_socr, file = "trusted_proteins_pca_socre.csv")
# write.xlsx(trusted_prot_pca_socr, file = "PCA_Data.xlsx", sheetName = "trusted_prot_pca_socr", colNames = TRUE, rowNames = TRUE, firstRow = TRUE, overwrite = F)
dir()

#### 写入trusted_prot_pca_plot数据
addWorksheet(wb, "2.trusted_prot_pca_socr", tabColour = "orange")
writeData(wb, sheet = "2.trusted_prot_pca_socr", trusted_prot_pca_socr)
saveWorkbook(wb, "PCA_Data.xlsx", overwrite = TRUE)

### 4.5 读取Sample_info文件，构建绘图数据
# Sample_info <- read.table("Sample_info.csv", sep = ',', header = TRUE)
# print("查看读取的Sample_info的数据中的样品信息")
head(Sample_info)
class(Sample_info)
dim(Sample_info)
sn <- length(unique(Sample_info$Sample))
print(paste0("样品数量为：",sn,"个"))

# [1] 12  2
class(trusted_prot_pca_socr)
dim(trusted_prot_pca_socr)
# [1]   12 1437

trusted_prot_pca_plot <- cbind(trusted_prot_pca_socr, Sample_info)
dim(trusted_prot_pca_plot)
# [1]   12 1439
# trusted_prot_pca_plot[1:5,1435:1439]
#        PC1       PC2        PC3  Sample Sample_abc
#1 -407.6388  66.79403  133.90762   Aucan    Aucan-1
#2 -342.8274  39.09280 -173.06715   Aucan    Aucan-2
#3 -420.2093  32.24630  126.22277   Aucan    Aucan-3
#4 -343.6204  28.30890 -130.38132   Aucan    Aucan-4
#5  264.3882 192.69146  -61.40081 Control  Control-1

## 5.绘制PCA 2D图和保存图片、数据
# write.csv(trusted_prot_pca_plot, file = "trusted_proteins_pca_plotting_data.csv")

#### 写入trusted_prot_pca_plot数据
addWorksheet(wb, "5.trusted_proteins_plot_data", tabColour = "blue")
writeData(wb, sheet = "5.trusted_proteins_plot_data", trusted_prot_pca_plot)
saveWorkbook(wb, "PCA_Data.xlsx", overwrite = TRUE)

### 5.1 计算PCA方差占比（解释率）
pc1_sdev <- sd(trusted_prot_pca_socr$PC1)
pc2_sdev <- sd(trusted_prot_pca_socr$PC2)
pc1_percent_variance <- pc1_sdev^2/sum(pc1_sdev^2 + pc2_sdev^2) * 100
print(paste0("PC1的方差占比为：", pc1_percent_variance))
pc2_percent_variance <- pc2_sdev^2/sum(pc1_sdev^2 + pc2_sdev^2) * 100
print(paste0("PC2的方差占比为：", pc2_percent_variance))

pc1_percent_variance <- as.data.frame(pc1_percent_variance)
pc2_percent_variance <- as.data.frame(pc2_percent_variance)
percentVar2D <- cbind(pc1_percent_variance, pc2_percent_variance)

### 5.2 保存PC1和PC2主成分方差占比数据
# write.csv(percentVar2D, file = "percentVar2D.csv")

#### 写入PCA 2D和3D的主成分占比（解释率）
addWorksheet(wb, "3.percentVar2D", tabColour = "yellow")
writeData(wb, sheet = "3.percentVar2D", percentVar2D)
saveWorkbook(wb, "PCA_Data.xlsx", overwrite = TRUE)

### 5.3 绘制二维PCA图
# 保存pdf格式
# 增加对样品数量的判断，从而可以自适应图片中样品点的大小和是否做stat_ellipse()统计

if (sn >= 3){
  p <- ggplot(trusted_prot_pca_plot, aes(trusted_prot_pca_plot$PC1,trusted_prot_pca_plot$PC2, colour = Sample)) +
    geom_point(size = 8) +
    # geom_text(label = trusted_prot_pca_plot$Sample_abc, size = 3, check_overlap = T, position = "identity") +
    # ggtitle("Sample of 2D PCA plot") +
    geom_text(label = trusted_prot_pca_plot$Sample_abc, size = 4, check_overlap = F, col = "black", hjust = "center", vjust = "middle") +
    xlab(paste0("PC1 ", round(percentVar2D$pc1_percent_variance,2), "% variance")) +
    ylab(paste0("PC2 ", round(percentVar2D$pc2_percent_variance,2), "% variance")) +
    theme_bw() +
    theme(panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), axis.line = element_line(colour = "black")) +
    theme(plot.margin = unit(rep(7,4),'lines'), aspect.ratio = 1.0) +
    theme(legend.text = element_text(size = 15, colour = "black")) +
    theme(legend.title = element_text(face = "bold", size = 20)) +
    # geom_text_repel() +
    # labs(fill = "Sample") +
    # geom_label_repel() +
    # guide_legend(title = "Sample") +
    # theme(legend.title = element_blank()) +
    # labs(fill = "Sample") +
    theme(axis.title.x =element_text(size=16), axis.title.y=element_text(size=16)) +
    stat_ellipse()

}
pdf("PCA_2D.pdf", width = 12, height = 7.5)
p
dev.off()
# 保存为png格式
png("PCA_2D.png", type = "cairo", width = 1200, height = 750)
p
dev.off()

if (sn < 3){
  p <- ggplot(trusted_prot_pca_plot,aes(trusted_prot_pca_plot$PC1,trusted_prot_pca_plot$PC2, colour = Sample)) +
    geom_point(size = 12) +
    geom_text(label = trusted_prot_pca_plot$Sample_abc, size = 6, check_overlap = F, col = "black", hjust = "center", vjust = "middle") +
    xlab(paste0("PC1 ", round(percentVar2D$pc1_percent_variance,2), "% variance")) +
    ylab(paste0("PC2 ", round(percentVar2D$pc2_percent_variance,2), "% variance")) +
    theme_bw() +
    theme(panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), axis.line = element_line(colour = "black")) +
    theme(plot.margin = unit(rep(7,4),'lines'), aspect.ratio = 1.0) +
    theme(legend.text = element_text(size = 15, colour = "black")) +
    theme(legend.title = element_text(size = 20, face = "bold")) +
    # theme(legend.title = element_blank()) +
    # labs(fill = "Sample") +
    # guide_legend(title = "Sample") +
    theme(axis.title.x =element_text(size=16), axis.title.y=element_text(size=16))
    # ggsave(filename = "1.pdf",plot = p,width = 6,height =4 )
  }
pdf("PCA_2D.pdf", width = 12, height = 7.5)
p
dev.off()
# 保存为png格式
png("PCA_2D.png", type = "cairo", width = 1200, height = 750)
p
dev.off()

## 6.计算PCA三个主成分的方差占比
pc1_sdev <- sd(trusted_prot_pca_socr$PC1)
pc2_sdev <- sd(trusted_prot_pca_socr$PC2)
pc3_sdev <- sd(trusted_prot_pca_socr$PC3)

PC1_percent_variance <- pc1_sdev^2/sum(pc1_sdev^2 + pc2_sdev^2 + pc3_sdev^2) * 100
print(paste0("PC1方差占比为：", PC1_percent_variance))

PC2_percent_variance <- pc2_sdev^2/sum(pc1_sdev^2 + pc2_sdev^2 + pc3_sdev^2) * 100
print(paste0("PC2方差占比为：", PC2_percent_variance))

PC3_percent_variance <- pc3_sdev^2/sum(pc1_sdev^2 + pc2_sdev^2 + pc3_sdev^2) * 100
print(paste0("PC3方差占比为：", PC3_percent_variance))


PC1_percent_variance <- as.data.frame(PC1_percent_variance)
PC2_percent_variance <- as.data.frame(PC2_percent_variance)
PC3_percent_variance <- as.data.frame(PC3_percent_variance)
percentVar3D <- cbind(PC1_percent_variance, PC2_percent_variance, PC3_percent_variance)

print("查看PCA三个主成分的解释率为：")
percentVar3D

# write.csv(percentVar3D, file = "percentVar3D.csv")

addWorksheet(wb, "4.percentVar3D", tabColour = "green")
writeData(wb, sheet = "4.percentVar3D", percentVar3D)
saveWorkbook(wb, "PCA_Data.xlsx", overwrite = TRUE)

# sn <- length(unique(trusted_prot_pca_plot$Sample))
spos <- 1:sn
print(spos)

## 保存Sample_info数据
addWorksheet(wb, "6.Sample_info", tabColour = "purple")
writeData(wb, sheet = "6.Sample_info", Sample_info)
saveWorkbook(wb, "PCA_Data.xlsx", overwrite = TRUE)

write.csv(Sample_info, file = "Sample_info.csv")
Sample_info <- read.table("Sample_info.csv", sep = ',', header = TRUE)
trusted_prot_pca_plot <- cbind(trusted_prot_pca_socr, Sample_info)
dim(trusted_prot_pca_plot)
## 删除Sample_info.csv文件
unlink("Sample_info.csv", recursive = FALSE, force = FALSE)

## 7.绘制3D图
# ### v1
# pdf("PCA_3D_v1.pdf", width = 12, height = 7.5)
# scatter3D(x = trusted_prot_pca_plot$PC1, y = trusted_prot_pca_plot$PC2, z = trusted_prot_pca_plot$PC3, xlab = paste0("PC1 ", round(percentVar3D$PC1_percent_variance,2), "% variance"), ylab = paste0("PC2 ", round(percentVar3D$PC2_percent_variance,2), "% variance"), zlab = paste0("PC3 ", round(percentVar3D$PC3_percent_variance,2), "% variance"), labels = trusted_prot_pca_plot$Sample_abc, phi = 18, theta = 32, bty = 'b2', pch = 20, cex = 3, ticktype = "detailed", plot = TRUE, adj = 0.5, font = 2, colkey = list(at = spos, side = 4, addlines = FALSE, length = 0.8, width = 0.6, labels = unique(trusted_prot_pca_plot$Sample)), clab = "Sample", colvar = as.integer(trusted_prot_pca_plot$Sample))
# dev.off()
#
# png(file = "PCA_3D_v1.png", type = "cairo", width = 1200, height = 750)
# scatter3D(x = trusted_prot_pca_plot$PC1, y = trusted_prot_pca_plot$PC2, z = trusted_prot_pca_plot$PC3, xlab = paste0("PC1 ", round(percentVar3D$PC1_percent_variance,2), "% variance"), ylab = paste0("PC2 ", round(percentVar3D$PC2_percent_variance,2), "% variance"), zlab = paste0("PC3 ", round(percentVar3D$PC3_percent_variance,2), "% variance"), labels = trusted_prot_pca_plot$Sample_abc, phi = 18, theta = 32, bty = 'b2', pch = 20, cex = 3, ticktype = "detailed", plot = TRUE, adj = 0.5, font = 2, colkey = list(at = spos, side = 4, addlines = FALSE, length = 0.8, width = 0.6, labels = unique(trusted_prot_pca_plot$Sample)), clab = "Sample", colvar = as.integer(trusted_prot_pca_plot$Sample))
# dev.off()
#
# ### v3
# pdf("PCA_3D_v3.pdf", width = 12, height = 7.5)
# scatter3D(x = trusted_prot_pca_plot$PC1, y = trusted_prot_pca_plot$PC2, z = trusted_prot_pca_plot$PC3, xlab = paste0("PC1 ", round(percentVar3D$PC1_percent_variance,2), "% variance"), ylab = paste0("PC2 ", round(percentVar3D$PC2_percent_variance,2), "% variance"), zlab = paste0("PC3 ", round(percentVar3D$PC3_percent_variance,2), "% variance"), labels = trusted_prot_pca_plot$Sample_abc, phi = 5, theta = 32, bty = 'b2', pch = 20, cex = 3, ticktype = "detailed", plot = TRUE, adj = 0.5, font = 2, colkey = list(at = spos, side = 4, addlines = FALSE, length = 0.8, width = 0.6, labels = unique(trusted_prot_pca_plot$Sample)), clab = "Sample", colvar = as.integer(trusted_prot_pca_plot$Sample))
# dev.off()
#
# png(file = "PCA_3D_v3.png", type = "cairo", width = 1200, height = 750)
# scatter3D(x = trusted_prot_pca_plot$PC1, y = trusted_prot_pca_plot$PC2, z = trusted_prot_pca_plot$PC3, xlab = paste0("PC1 ", round(percentVar3D$PC1_percent_variance,2), "% variance"), ylab = paste0("PC2 ", round(percentVar3D$PC2_percent_variance,2), "% variance"), zlab = paste0("PC3 ", round(percentVar3D$PC3_percent_variance,2), "% variance"), labels = trusted_prot_pca_plot$Sample_abc, phi = 5, theta = 32, bty = 'b2', pch = 20, cex = 3, ticktype = "detailed", plot = TRUE, adj = 0.5, font = 2, colkey = list(at = spos, side = 4, addlines = FALSE, length = 0.8, width = 0.6, labels = unique(trusted_prot_pca_plot$Sample)), clab = "Sample", colvar = as.integer(trusted_prot_pca_plot$Sample))
# dev.off()

## 7.绘制3D图
#############################################################################
### 7.1根据样品数量决定样品颜色和图例的格式大小 ##
col <- c("orange", "green", "magenta","red","pink","blue","darkgreen","yellow", "brown", "turquoise","cyan","gold","aquamarine","tomato","tan","lawngreen","cornflowerblue","hotpink","firebrick","darkviolet")
sacol <- sample(col,sn)
sl <- sn/10.0
pdf("PCA_3D.pdf", width = 12, height = 7.5)
scatter3D(x = trusted_prot_pca_plot$PC1, y = trusted_prot_pca_plot$PC2, z = trusted_prot_pca_plot$PC3, xlab = paste0("PC1 ", round(percentVar3D$PC1_percent_variance,2), "% variance"), ylab = paste0("PC2 ", round(percentVar3D$PC2_percent_variance,2), "% variance"), zlab = paste0("PC3 ", round(percentVar3D$PC3_percent_variance,2), "% variance"), labels = trusted_prot_pca_plot$Sample_abc, col = sacol, phi = 5, theta = 32, bty = 'b2', pch = 20, cex = 5, ticktype = "detailed", plot = TRUE, adj = 0.5, font = 2, colkey = list(at = spos, side = 4, addlines = FALSE, length = sl, width = 0.6, labels = unique(trusted_prot_pca_plot$Sample), cex.clab = 1.5), clab = "Sample", colvar = as.integer(trusted_prot_pca_plot$Sample))
dev.off()

png("PCA_3D.png", width = 1200, height = 750)
scatter3D(x = trusted_prot_pca_plot$PC1, y = trusted_prot_pca_plot$PC2, z = trusted_prot_pca_plot$PC3, xlab = paste0("PC1 ", round(percentVar3D$PC1_percent_variance,2), "% variance"), ylab = paste0("PC2 ", round(percentVar3D$PC2_percent_variance,2), "% variance"), zlab = paste0("PC3 ", round(percentVar3D$PC3_percent_variance,2), "% variance"), labels = trusted_prot_pca_plot$Sample_abc, col = sacol, phi = 5, theta = 32, bty = 'b2', pch = 20, cex = 5, ticktype = "detailed", plot = TRUE, adj = 0.5, font = 2, colkey = list(at = spos, side = 4, addlines = FALSE, length = sl, width = 0.6, labels = unique(trusted_prot_pca_plot$Sample), cex.clab = 1.5), clab = "Sample", colvar = as.integer(trusted_prot_pca_plot$Sample))
dev.off()

dir()
# 十个样品
##pdf("PCA_3D_v3.pdf", width = 12, height = 7.5)
##if (sn == 10){
##  scatter3D(x = trusted_prot_pca_plot$PC1, y = trusted_prot_pca_plot$PC2, z = trusted_prot_pca_plot$PC3, xlab = paste0("PC1 ", round(percentVar3D$PC1_percent_variance,2), "% variance"), ylab = paste0("PC2 ", round(percentVar3D$PC2_percent_variance,2), "% variance"), zlab = paste0("PC3 ", round(percentVar3D$PC3_percent_variance,2), "% variance"), labels = trusted_prot_pca_plot$Sample_abc, col = c("orange", "green", "magenta","red","pink","blue","darkgreen","yellow", "brown", "turquoise"), phi = 5, theta = 32, bty = 'b2', pch = 20, cex = 3, ticktype = "detailed", plot = TRUE, adj = 0.5, font = 2, colkey = list(at = spos, side = 4, addlines = FALSE, length = 1, width = 0.5, labels = unique(trusted_prot_pca_plot$Sample)), clab = "Sample", colvar = as.integer(trusted_prot_pca_plot$Sample))
##  }
##dev.off()
##png(file = "PCA_3D_v3.png", type = "cairo", width = 1200, height = 750)
##if (sn == 10){
##  scatter3D(x = trusted_prot_pca_plot$PC1, y = trusted_prot_pca_plot$PC2, z = trusted_prot_pca_plot$PC3, xlab = paste0("PC1 ", round(percentVar3D$PC1_percent_variance,2), "% variance"), ylab = paste0("PC2 ", round(percentVar3D$PC2_percent_variance,2), "% variance"), zlab = paste0("PC3 ", round(percentVar3D$PC3_percent_variance,2), "% variance"), labels = trusted_prot_pca_plot$Sample_abc, col = c("orange", "green", "magenta","red","pink","blue","darkgreen","yellow", "brown", "turquoise"), phi = 5, theta = 32, bty = 'b2', pch = 20, cex = 3, ticktype = "detailed", plot = TRUE, adj = 0.5, font = 2, colkey = list(at = spos, side = 4, addlines = FALSE, length = 1, width = 0.5, labels = unique(trusted_prot_pca_plot$Sample)), clab = "Sample", colvar = as.integer(trusted_prot_pca_plot$Sample))
##  }
##dev.off()
##
### 九个样品
##pdf("PCA_3D_v3.pdf", width = 12, height = 7.5)
##if (sn == 9){
##  scatter3D(x = trusted_prot_pca_plot$PC1, y = trusted_prot_pca_plot$PC2, z = trusted_prot_pca_plot$PC3, xlab = paste0("PC1 ", round(percentVar3D$PC1_percent_variance,2), "% variance"), ylab = paste0("PC2 ", round(percentVar3D$PC2_percent_variance,2), "% variance"), zlab = paste0("PC3 ", round(percentVar3D$PC3_percent_variance,2), "% variance"), labels = trusted_prot_pca_plot$Sample_abc, col = c("orange", "green", "magenta","red","pink","blue","darkgreen","yellow", "brown"), phi = 5, theta = 32, bty = 'b2', pch = 20, cex = 3, ticktype = "detailed", plot = TRUE, adj = 0.5, font = 2, colkey = list(at = spos, side = 4, addlines = FALSE, length = 0.9, width = 0.5, labels = unique(trusted_prot_pca_plot$Sample)), clab = "Sample", colvar = as.integer(trusted_prot_pca_plot$Sample))
##  }
##dev.off()
##png(file = "PCA_3D_v3.png", type = "cairo", width = 1200, height = 750)
##if (sn == 9){
##  scatter3D(x = trusted_prot_pca_plot$PC1, y = trusted_prot_pca_plot$PC2, z = trusted_prot_pca_plot$PC3, xlab = paste0("PC1 ", round(percentVar3D$PC1_percent_variance,2), "% variance"), ylab = paste0("PC2 ", round(percentVar3D$PC2_percent_variance,2), "% variance"), zlab = paste0("PC3 ", round(percentVar3D$PC3_percent_variance,2), "% variance"), labels = trusted_prot_pca_plot$Sample_abc, col = c("orange", "green", "magenta","red","pink","blue","darkgreen","yellow", "brown"), phi = 5, theta = 32, bty = 'b2', pch = 20, cex = 3, ticktype = "detailed", plot = TRUE, adj = 0.5, font = 2, colkey = list(at = spos, side = 4, addlines = FALSE, length = 0.9, width = 0.5, labels = unique(trusted_prot_pca_plot$Sample)), clab = "Sample", colvar = as.integer(trusted_prot_pca_plot$Sample))
##  }
##dev.off()
##
### 八个样品
##pdf("PCA_3D_v3.pdf", width = 12, height = 7.5)
##if (sn == 8){
##  scatter3D(x = trusted_prot_pca_plot$PC1, y = trusted_prot_pca_plot$PC2, z = trusted_prot_pca_plot$PC3, xlab = paste0("PC1 ", round(percentVar3D$PC1_percent_variance,2), "% variance"), ylab = paste0("PC2 ", round(percentVar3D$PC2_percent_variance,2), "% variance"), zlab = paste0("PC3 ", round(percentVar3D$PC3_percent_variance,2), "% variance"), labels = trusted_prot_pca_plot$Sample_abc, col = c("orange", "green", "magenta","red","pink","blue","darkgreen","yellow"), phi = 5, theta = 32, bty = 'b2', pch = 20, cex = 3, ticktype = "detailed", plot = TRUE, adj = 0.5, font = 2, colkey = list(at = spos, side = 4, addlines = FALSE, length = 0.8, width = 0.5, labels = unique(trusted_prot_pca_plot$Sample)), clab = "Sample", colvar = as.integer(trusted_prot_pca_plot$Sample))
##  }
##dev.off()
##png(file = "PCA_3D_v3.png", type = "cairo", width = 1200, height = 750)
##if (sn == 8){scatter3D(x = trusted_prot_pca_plot$PC1, y = trusted_prot_pca_plot$PC2, z = trusted_prot_pca_plot$PC3, xlab = paste0("PC1 ", round(percentVar3D$PC1_percent_variance,2), "% variance"), ylab = paste0("PC2 ", round(percentVar3D$PC2_percent_variance,2), "% variance"), zlab = paste0("PC3 ", round(percentVar3D$PC3_percent_variance,2), "% variance"), labels = trusted_prot_pca_plot$Sample_abc, col = c("orange", "green", "magenta","red","pink","blue","darkgreen","yellow"), phi = 5, theta = 32, bty = 'b2', pch = 20, cex = 3, ticktype = "detailed", plot = TRUE, adj = 0.5, font = 2, colkey = list(at = spos, side = 4, addlines = FALSE, length = 0.8, width = 0.5, labels = unique(trusted_prot_pca_plot$Sample)), clab = "Sample", colvar = as.integer(trusted_prot_pca_plot$Sample))
##  }
##dev.off()
##
### 七个样品
##pdf("PCA_3D_v3.pdf", width = 12, height = 7.5)
##if (sn == 7){
##  scatter3D(x = trusted_prot_pca_plot$PC1, y = trusted_prot_pca_plot$PC2, z = trusted_prot_pca_plot$PC3, xlab = paste0("PC1 ", round(percentVar3D$PC1_percent_variance,2), "% variance"), ylab = paste0("PC2 ", round(percentVar3D$PC2_percent_variance,2), "% variance"), zlab = paste0("PC3 ", round(percentVar3D$PC3_percent_variance,2), "% variance"), labels = trusted_prot_pca_plot$Sample_abc, col = c("orange", "green", "magenta","red","pink","blue","darkgreen"), phi = 5, theta = 32, bty = 'b2', pch = 20, cex = 3, ticktype = "detailed", plot = TRUE, adj = 0.5, font = 2, colkey = list(at = spos, side = 4, addlines = FALSE, length = 0.7, width = 0.5, labels = unique(trusted_prot_pca_plot$Sample)), clab = "Sample", colvar = as.integer(trusted_prot_pca_plot$Sample))
##  }
##dev.off()
##png(file = "PCA_3D_v3.png", type = "cairo", width = 1200, height = 750)
##if (sn == 7){
##  scatter3D(x = trusted_prot_pca_plot$PC1, y = trusted_prot_pca_plot$PC2, z = trusted_prot_pca_plot$PC3, xlab = paste0("PC1 ", round(percentVar3D$PC1_percent_variance,2), "% variance"), ylab = paste0("PC2 ", round(percentVar3D$PC2_percent_variance,2), "% variance"), zlab = paste0("PC3 ", round(percentVar3D$PC3_percent_variance,2), "% variance"), labels = trusted_prot_pca_plot$Sample_abc, col = c("orange", "green", "magenta","red","pink","blue","darkgreen"), phi = 5, theta = 32, bty = 'b2', pch = 20, cex = 3, ticktype = "detailed", plot = TRUE, adj = 0.5, font = 2, colkey = list(at = spos, side = 4, addlines = FALSE, length = 0.7, width = 0.5, labels = unique(trusted_prot_pca_plot$Sample)), clab = "Sample", colvar = as.integer(trusted_prot_pca_plot$Sample))
##  }
##dev.off()
##
### 六个样品
##pdf("PCA_3D_v3.pdf", width = 12, height = 7.5)
##if (sn == 6){
##  scatter3D(x = trusted_prot_pca_plot$PC1, y = trusted_prot_pca_plot$PC2, z = trusted_prot_pca_plot$PC3, xlab = paste0("PC1 ", round(percentVar3D$PC1_percent_variance,2), "% variance"), ylab = paste0("PC2 ", round(percentVar3D$PC2_percent_variance,2), "% variance"), zlab = paste0("PC3 ", round(percentVar3D$PC3_percent_variance,2), "% variance"), labels = trusted_prot_pca_plot$Sample_abc, col = c("orange", "green", "magenta","red","pink","blue"), phi = 5, theta = 32, bty = 'b2', pch = 20, cex = 3, ticktype = "detailed", plot = TRUE, adj = 0.5, font = 2, colkey = list(at = spos, side = 4, addlines = FALSE, length = 0.6, width = 0.5, labels = unique(trusted_prot_pca_plot$Sample)), clab = "Sample", colvar = as.integer(trusted_prot_pca_plot$Sample))
##  }
##dev.off()
##png(file = "PCA_3D_v3.png", type = "cairo", width = 1200, height = 750)
##if (sn == 6){
##  scatter3D(x = trusted_prot_pca_plot$PC1, y = trusted_prot_pca_plot$PC2, z = trusted_prot_pca_plot$PC3, xlab = paste0("PC1 ", round(percentVar3D$PC1_percent_variance,2), "% variance"), ylab = paste0("PC2 ", round(percentVar3D$PC2_percent_variance,2), "% variance"), zlab = paste0("PC3 ", round(percentVar3D$PC3_percent_variance,2), "% variance"), labels = trusted_prot_pca_plot$Sample_abc, col = c("orange", "green", "magenta","red","pink","blue"), phi = 5, theta = 32, bty = 'b2', pch = 20, cex = 3, ticktype = "detailed", plot = TRUE, adj = 0.5, font = 2, colkey = list(at = spos, side = 4, addlines = FALSE, length = 0.6, width = 0.5, labels = unique(trusted_prot_pca_plot$Sample)), clab = "Sample", colvar = as.integer(trusted_prot_pca_plot$Sample))
##  }
##dev.off()
##
### 五个样品
##pdf("PCA_3D_v3.pdf", width = 12, height = 7.5)
##if (sn == 5){
##  scatter3D(x = trusted_prot_pca_plot$PC1, y = trusted_prot_pca_plot$PC2, z = trusted_prot_pca_plot$PC3, xlab = paste0("PC1 ", round(percentVar3D$PC1_percent_variance,2), "% variance"), ylab = paste0("PC2 ", round(percentVar3D$PC2_percent_variance,2), "% variance"), zlab = paste0("PC3 ", round(percentVar3D$PC3_percent_variance,2), "% variance"), labels = trusted_prot_pca_plot$Sample_abc, col = c("orange", "green", "magenta","red","blue"), phi = 5, theta = 32, bty = 'b2', pch = 20, cex = 3, ticktype = "detailed", plot = TRUE, adj = 0.5, font = 2, colkey = list(at = spos, side = 4, addlines = FALSE, length = 0.5, width = 0.5, labels = unique(trusted_prot_pca_plot$Sample)), clab = "Sample", colvar = as.integer(trusted_prot_pca_plot$Sample))
##  }
##dev.off()
##png(file = "PCA_3D_v3.png", type = "cairo", width = 1200, height = 750)
##if (sn == 5){
##  scatter3D(x = trusted_prot_pca_plot$PC1, y = trusted_prot_pca_plot$PC2, z = trusted_prot_pca_plot$PC3, xlab = paste0("PC1 ", round(percentVar3D$PC1_percent_variance,2), "% variance"), ylab = paste0("PC2 ", round(percentVar3D$PC2_percent_variance,2), "% variance"), zlab = paste0("PC3 ", round(percentVar3D$PC3_percent_variance,2), "% variance"), labels = trusted_prot_pca_plot$Sample_abc, col = c("orange", "green", "magenta","red","blue"), phi = 5, theta = 32, bty = 'b2', pch = 20, cex = 3, ticktype = "detailed", plot = TRUE, adj = 0.5, font = 2, colkey = list(at = spos, side = 4, addlines = FALSE, length = 0.5, width = 0.5, labels = unique(trusted_prot_pca_plot$Sample)), clab = "Sample", colvar = as.integer(trusted_prot_pca_plot$Sample))
##  }
##dev.off()
##
### 四个样品
##pdf("PCA_3D_v3.pdf", width = 12, height = 7.5)
##if (sn == 4){
##  scatter3D(x = trusted_prot_pca_plot$PC1, y = trusted_prot_pca_plot$PC2, z = trusted_prot_pca_plot$PC3, xlab = paste0("PC1 ", round(percentVar3D$PC1_percent_variance,2), "% variance"), ylab = paste0("PC2 ", round(percentVar3D$PC2_percent_variance,2), "% variance"), zlab = paste0("PC3 ", round(percentVar3D$PC3_percent_variance,2), "% variance"), labels = trusted_prot_pca_plot$Sample_abc, col = c("orange", "green", "magenta", "red"), phi = 5, theta = 32, bty = 'b2', pch = 20, cex = 3, ticktype = "detailed", plot = TRUE, adj = 0.5, font = 2, colkey = list(at = spos, side = 4, addlines = FALSE, length = 0.4, width = 0.5, labels = unique(trusted_prot_pca_plot$Sample)), clab = "Sample", colvar = as.integer(trusted_prot_pca_plot$Sample))
##  }
##dev.off()
##png(file = "PCA_3D_v3.png", type = "cairo", width = 1200, height = 750)
##if (sn == 4){
##  scatter3D(x = trusted_prot_pca_plot$PC1, y = trusted_prot_pca_plot$PC2, z = trusted_prot_pca_plot$PC3, xlab = paste0("PC1 ", round(percentVar3D$PC1_percent_variance,2), "% variance"), ylab = paste0("PC2 ", round(percentVar3D$PC2_percent_variance,2), "% variance"), zlab = paste0("PC3 ", round(percentVar3D$PC3_percent_variance,2), "% variance"), labels = trusted_prot_pca_plot$Sample_abc, col = c("orange", "green", "magenta", "red"), phi = 5, theta = 32, bty = 'b2', pch = 20, cex = 3, ticktype = "detailed", plot = TRUE, adj = 0.5, font = 2, colkey = list(at = spos, side = 4, addlines = FALSE, length = 0.4, width = 0.5, labels = unique(trusted_prot_pca_plot$Sample)), clab = "Sample", colvar = as.integer(trusted_prot_pca_plot$Sample))
##  }
##dev.off()
##
### 三个样品
##pdf("PCA_3D_v3.pdf", width = 12, height = 7.5)
##if (sn == 3){
##  scatter3D(x = trusted_prot_pca_plot$PC1, y = trusted_prot_pca_plot$PC2, z = trusted_prot_pca_plot$PC3, xlab = paste0("PC1 ", round(percentVar3D$PC1_percent_variance,2), "% variance"), ylab = paste0("PC2 ", round(percentVar3D$PC2_percent_variance,2), "% variance"), zlab = paste0("PC3 ", round(percentVar3D$PC3_percent_variance,2), "% variance"), labels = trusted_prot_pca_plot$Sample_abc, col = c("orange", "green", "magenta"), phi = 5, theta = 32, bty = 'b2', pch = 20, cex = 3, ticktype = "detailed", plot = TRUE, adj = 0.5, font = 2, colkey = list(at = spos, side = 4, addlines = FALSE, length = 0.3, width = 0.5, labels = unique(trusted_prot_pca_plot$Sample)), clab = "Sample", colvar = as.integer(trusted_prot_pca_plot$Sample))
##}
##dev.off()
##png(file = "PCA_3D_v3.png", type = "cairo", width = 1200, height = 750)
##if (sn == 3){
##  scatter3D(x = trusted_prot_pca_plot$PC1, y = trusted_prot_pca_plot$PC2, z = trusted_prot_pca_plot$PC3, xlab = paste0("PC1 ", round(percentVar3D$PC1_percent_variance,2), "% variance"), ylab = paste0("PC2 ", round(percentVar3D$PC2_percent_variance,2), "% variance"), zlab = paste0("PC3 ", round(percentVar3D$PC3_percent_variance,2), "% variance"), labels = trusted_prot_pca_plot$Sample_abc, col = c("orange", "green", "magenta"), phi = 5, theta = 32, bty = 'b2', pch = 20, cex = 3, ticktype = "detailed", plot = TRUE, adj = 0.5, font = 2, colkey = list(at = spos, side = 4, addlines = FALSE, length = 0.3, width = 0.5, labels = unique(trusted_prot_pca_plot$Sample)), clab = "Sample", colvar = as.integer(trusted_prot_pca_plot$Sample))
##}
##dev.off()
##
### 两个样品
##pdf("PCA_3D_v3.pdf", width = 12, height = 7.5)
##if (sn == 2){
##  scatter3D(x = trusted_prot_pca_plot$PC1, y = trusted_prot_pca_plot$PC2, z = trusted_prot_pca_plot$PC3, xlab = paste0("PC1 ", round(percentVar3D$PC1_percent_variance,2), "% variance"), ylab = paste0("PC2 ", round(percentVar3D$PC2_percent_variance,2), "% variance"), zlab = paste0("PC3 ", round(percentVar3D$PC3_percent_variance,2), "% variance"), labels = trusted_prot_pca_plot$Sample_abc, col = c("orange", "green"), phi = 5, theta = 32, bty = 'b2', pch = 20, cex = 3, ticktype = "detailed", plot = TRUE, adj = 0.5, font = 2, colkey = list(at = spos, side = 4, addlines = FALSE, length = 0.2, width = 0.5, labels = unique(trusted_prot_pca_plot$Sample)), clab = "Sample", colvar = as.integer(trusted_prot_pca_plot$Sample))
##}
##dev.off()
##png(file = "PCA_3D_v3.png", type = "cairo", width = 1200, height = 750)
##if (sn ==2){
##  scatter3D(x = trusted_prot_pca_plot$PC1, y = trusted_prot_pca_plot$PC2, z = trusted_prot_pca_plot$PC3, xlab = paste0("PC1 ", round(percentVar3D$PC1_percent_variance,2), "% variance"), ylab = paste0("PC2 ", round(percentVar3D$PC2_percent_variance,2), "% variance"), zlab = paste0("PC3 ", round(percentVar3D$PC3_percent_variance,2), "% variance"), labels = trusted_prot_pca_plot$Sample_abc, col = c("orange", "green"), phi = 5, theta = 32, bty = 'b2', pch = 20, cex = 3, ticktype = "detailed", plot = TRUE, adj = 0.5, font = 2, colkey = list(at = spos, side = 4, addlines = FALSE, length = 0.2, width = 0.5, labels = unique(trusted_prot_pca_plot$Sample)), clab = "Sample", colvar = as.integer(trusted_prot_pca_plot$Sample))
##}
##dev.off()

#############################################################################
## 8.绘图完成
list.dirs()
list.files()
setwd("../")
dir()
print("输出数据处理和绘图所需R包名称、版本和环境变量信息：")
sessionInfo()
print("脚本运行时间为：")
proc.time()-pt
print("PCA分析及绘图完成，祝工作顺利，开心每一天！")
print("END!")
