########################################################################################################
## R script function: Plotting Sample of PCA
## Author: jingxinxing
## Version: v8.0
## New:
## Usage: runpca
########################################################################################################
#
## 脚本运行计时开始
pt=proc.time()
#
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
print("分析开始：Start")
## 设置当前工作目录
setwd("./")

## 导入R包
analysis_need_packages <- c("ggplot2", "plotrix", "openxlsx","pcaMethods", "readxl", "plot3D", "ggrepel", "corrplot", "progress")
sapply(analysis_need_packages, library, character.only = T)

## 脚本执行进度条
print("分析开始：Start")
ppbb <- progress_bar$new(total = 1000)
for (i in 1:1000) {
   ppbb$tick()
   Sys.sleep(1 / 1000)
}

#
## 3.读取测试数据：项目的差异蛋白筛选结果文件（格式为.xlsx）
### 3.1判断差异蛋白筛选结果文件中的是否有“可信蛋白”，还是有“合并可信蛋白”，对应导入数据
if ("合并可信蛋白" %in% readxl::excel_sheets("./差异蛋白筛选结果.xlsx") == TRUE){
  trusted_prot <- read.xlsx("./差异蛋白筛选结果.xlsx", sheet = "合并可信蛋白", startRow = 1, colNames = TRUE, rowNames = FALSE, detectDates = FALSE)
  print("合并可信蛋白原始数据大小为：")
  dim(trusted_prot)
}else if ("可信蛋白" %in% readxl::excel_sheets("./差异蛋白筛选结果.xlsx") == TRUE){
  trusted_prot <- read.xlsx("./差异蛋白筛选结果.xlsx", sheet = "可信蛋白", startRow = 1, colNames = TRUE, rowNames = FALSE, detectDates = FALSE)
  print("可信蛋白原始数据大小为：")
  dim(trusted_prot)
}else if ("总可信蛋白" %in% readxl::excel_sheets("./差异蛋白筛选结果.xlsx") == TRUE){
  trusted_prot <- read.xlsx("./差异蛋白筛选结果.xlsx", sheet = "总可信蛋白", startRow = 1, colNames = TRUE, rowNames = FALSE, detectDates = FALSE)
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

### 4.1 样品数据匹配
Sample_info <- read.xlsx("sample_information.xlsx", sheet = "样品信息", startRow = 1, colNames = TRUE, rowNames = FALSE, detectDates = FALSE) # 读取sample_information.xlsx表格中的信息
print("查看读取的Sample_info的数据中的样品信息：")
Sample_info

Sample_info$作图编号 <- NULL
colnames(Sample_info) <- c("Sample", "Sample_abc")
Sample_info$Sample_abc <- gsub(" ", ".", Sample_info$Sample_abc) # 替换字符串
sama <- match(Sample_info$Sample_abc, colnames(trusted_prot))
print("查看Sample_abc在trusted_prot中匹配到的位置信息")
sama

#### 根据样品位置信息进行数据重组
trusted_prot_new <- trusted_prot[,sama]
print("查看样品匹配后的数据大小：")
dim(trusted_prot_new)

# 保存处理好的未进行行列转置的数据
## Create a new workbook
wb <- createWorkbook("PCA_Data")

## 在当前目录里创建一个PCA目录
dir()
if (dir.exists("PCA")){
  list.dirs("./PCA")
  list.files("./PCA")
}else{
  dir.create("./PCA")
  dir.exists("PCA")
}
# [1] TRUE
setwd("./PCA")
#### 写入trusted_prot_new数据
addWorksheet(wb, "1.trusted_proteins_new_data", tabColour = "red")
writeData(wb, sheet = "1.trusted_proteins_new_data", trusted_prot_new)
saveWorkbook(wb, "PCA_Data.xlsx", overwrite = TRUE)

# 数据框转换为矩阵，行列转置
trusted_prot_new <- t(as.matrix(trusted_prot_new))
# print("查看去掉无用信息后，行列转置后的数据行名、列名和大小：")
dim(trusted_prot_new)
row.names(trusted_prot_new)
head(colnames(trusted_prot_new))
class(trusted_prot_new)
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
### 4.4 保存PCA计算后合并的新数据
dir()

#### 写入trusted_prot_pca_plot数据
addWorksheet(wb, "2.trusted_prot_pca_socr", tabColour = "orange")
writeData(wb, sheet = "2.trusted_prot_pca_socr", trusted_prot_pca_socr)
saveWorkbook(wb, "PCA_Data.xlsx", overwrite = TRUE)

### 4.5 读取Sample_info文件，构建绘图数据
# print("查看读取的Sample_info的数据中的样品信息")
head(Sample_info)
class(Sample_info)
dim(Sample_info)
sn <- length(unique(Sample_info$Sample))
print(paste0("样品数量为：",sn,"个"))
class(trusted_prot_pca_socr)
dim(trusted_prot_pca_socr)
trusted_prot_pca_plot <- cbind(trusted_prot_pca_socr, Sample_info)
dim(trusted_prot_pca_plot)

## 5.绘制PCA 2D图和保存图片、数据

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
#### 写入PCA 2D和3D的主成分占比（解释率）
addWorksheet(wb, "3.percentVar2D", tabColour = "yellow")
writeData(wb, sheet = "3.percentVar2D", percentVar2D)
saveWorkbook(wb, "PCA_Data.xlsx", overwrite = TRUE)

### 5.3 绘制二维PCA图
# 保存pdf格式
# 增加对样品数量的判断，从而可以自适应图片中样品点的大小和是否做stat_ellipse()统计
if (sn >= 3){
    ggplot(trusted_prot_pca_plot, aes(trusted_prot_pca_plot$PC1,trusted_prot_pca_plot$PC2, colour = Sample)) +
      geom_point(size = 8) +
      geom_text(label = trusted_prot_pca_plot$Sample_abc, size = 3, check_overlap = F, col = "black", hjust = "center", vjust = "middle") +
      xlab(paste0("PC1 ", round(percentVar2D$pc1_percent_variance,2), "% variance")) +
      ylab(paste0("PC2 ", round(percentVar2D$pc2_percent_variance,2), "% variance")) +
      theme_bw() +
      theme(panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), axis.line = element_line(colour = "black")) +
      theme(plot.margin = unit(rep(7,4),'lines'), aspect.ratio = 1.0) +
      theme(legend.text = element_text(size = 15, colour = "black")) +
      theme(legend.title = element_text(face = "bold", size = 20)) +
      theme(axis.title.x =element_text(size=16), axis.title.y=element_text(size=16)) +
      stat_ellipse()
    ggsave("PCA_2D.pdf", width = 12, height = 7.5, units = "in")
    ggsave("PCA_2D.png", width = 12, height = 7.5, units = "in")
} else if (sn < 3){
    ggplot(trusted_prot_pca_plot,aes(trusted_prot_pca_plot$PC1,trusted_prot_pca_plot$PC2, colour = Sample)) +
      geom_point(size = 10) +
      geom_text(label = trusted_prot_pca_plot$Sample_abc, size = 4, check_overlap = F, col = "black", hjust = "center", vjust = "middle") +
      xlab(paste0("PC1 ", round(percentVar2D$pc1_percent_variance,2), "% variance")) +
      ylab(paste0("PC2 ", round(percentVar2D$pc2_percent_variance,2), "% variance")) +
      theme_bw() +
      theme(panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), axis.line = element_line(colour = "black")) +
      theme(plot.margin = unit(rep(7,4),'lines'), aspect.ratio = 1.0) +
      theme(legend.text = element_text(size = 15, colour = "black")) +
      theme(legend.title = element_text(size = 20, face = "bold")) +
      theme(axis.title.x =element_text(size=16), axis.title.y=element_text(size=16)) +
      stat_ellipse()
    ggsave("PCA_2D.pdf", width = 12, height = 7.5, units = "in")
    ggsave("PCA_2D.png", width = 12, height = 7.5, units = "in")

}
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
addWorksheet(wb, "4.percentVar3D", tabColour = "green")
writeData(wb, sheet = "4.percentVar3D", percentVar3D)
saveWorkbook(wb, "PCA_Data.xlsx", overwrite = TRUE)
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
#############################################################################
### 7.1根据样品数量决定样品颜色和图例的格式大小 ##
# col <- c("orange", "green", "magenta","red","pink","blue","darkgreen","yellow", "brown", "turquoise","cyan","gold","aquamarine","tomato","tan","lawngreen","cornflowerblue","hotpink","firebrick","darkviolet")
col <- c("orange", "green", "magenta","red","pink","blue","darkgreen","yellow", "brown", "turquoise","cyan","gold","aquamarine","tomato","tan","lawngreen","cornflowerblue","hotpink","firebrick","darkviolet","orangered", "orchid","darkmagenta","snow4","slateblue","rosybrown","deepskyblue","lightseagreen","darkviolet","azure4")
sacol <- sample(col,sn)
sl <- sn/10.0
pdf("PCA_3D.pdf", width = 12, height = 7.5)
scatter3D(x = trusted_prot_pca_plot$PC1, y = trusted_prot_pca_plot$PC2, z = trusted_prot_pca_plot$PC3, xlab = paste0("PC1 ", round(percentVar3D$PC1_percent_variance,2), "% variance"), ylab = paste0("PC2 ", round(percentVar3D$PC2_percent_variance,2), "% variance"), zlab = paste0("PC3 ", round(percentVar3D$PC3_percent_variance,2), "% variance"), labels = trusted_prot_pca_plot$Sample_abc, col = sacol, phi = 5, theta = 32, bty = 'b2', pch = 20, cex = 5, ticktype = "detailed", plot = TRUE, adj = 0.5, font = 2, colkey = list(at = spos, side = 4, addlines = FALSE, length = sl, width = 0.6, labels = unique(trusted_prot_pca_plot$Sample), cex.clab = 1.5), clab = "Sample", colvar = as.integer(trusted_prot_pca_plot$Sample))
dev.off()

png("PCA_3D.png", width = 1200, height = 750)
scatter3D(x = trusted_prot_pca_plot$PC1, y = trusted_prot_pca_plot$PC2, z = trusted_prot_pca_plot$PC3, xlab = paste0("PC1 ", round(percentVar3D$PC1_percent_variance,2), "% variance"), ylab = paste0("PC2 ", round(percentVar3D$PC2_percent_variance,2), "% variance"), zlab = paste0("PC3 ", round(percentVar3D$PC3_percent_variance,2), "% variance"), labels = trusted_prot_pca_plot$Sample_abc, col = sacol, phi = 5, theta = 32, bty = 'b2', pch = 20, cex = 5, ticktype = "detailed", plot = TRUE, adj = 0.5, font = 2, colkey = list(at = spos, side = 4, addlines = FALSE, length = sl, width = 0.6, labels = unique(trusted_prot_pca_plot$Sample), cex.clab = 1.5), clab = "Sample", colvar = as.integer(trusted_prot_pca_plot$Sample))
dev.off()

dir()
list.files()
setwd("../")
dir()
print("PCA分析及绘图完成！请查看PCA目录中的图片和数据文件PCA_Data.xlsx。")
list.files("./PCA")

### END!
print("输入R包和环境信息：")
sessionInfo()
print("恭喜，样品PCA绘图任务完成!!!")
print("祝工作顺利，开心每一天！")

### 完成进度条 
ppbb <- progress_bar$new(
  format = "  完成百分比 [:bar] :percent",
  total = 1000, clear = FALSE, width= 100)
for (i in 1:1000) {
  ppbb$tick()
  Sys.sleep(1 / 1000)
}

### 脚本耗时
print("脚本运行时间为：")
proc.time()-pt
