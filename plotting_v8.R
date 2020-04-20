########################################################################################################
# Rscript: Proteomics Project of Total R-Script for Data Analysis and Visualization
# Author: jingxinxing
# Date: 2020年02月12日
# Version: v8.4
# New: 1.支持对于多批次标记实验的原始数据的分析及可视化，例如："iTRAQ results 1", "iTRAQ results 2", "iTRAQ results 3"和"TMT results 1", "TMT results 2", "TMT results 3"
#      2.对生成的结果图的名称进行了修改
#      3.支持对Label free项目数据的分析和出图的支持
#      4.PCA值计算方式改为：scale="uv"
#      5.R总绘图脚本plotting_v8.R所生成的图片文件和数据被分门别类的整理到对应的目录里，方便查找文件和后面的数据清理工作；
#      6.增加motif分析模块
# 
# Usage: 1.首先建立项目路径；
#        2.上传原始数据，如果只有单次标记实验的数据，
#          则上传到项目路径两个原始数据文件：（1）Peptide groups.xlsx，（2）Protein quantitation（红发夫酵母）.xlsx
#          和差异蛋白筛选分析所需的文件：（3）sample_information.xlsx文件，（4）样品编号标记对照表（红发夫酵母）.xlsx；
#        3.如果是多批次标记实验的原始数据，则直接上传文件夹，例如："iTRAQ results 1", "iTRAQ results 2", "iTRAQ results 3"，每个文件夹中
#          包括两个文件：例如：（1）Peptide groups 1.xlsx，（2）Protein quantitation 1（人骨骼肌细胞）.xlsx；
#        4.准备好需要分析的数据后，就可以开始做差异蛋白筛选分析了；
#        5.差异蛋白筛选分析完成之后，得到了“差异蛋白筛选结果.xlsx”文件，就可以使用本脚本进行数据统计分析及可视化绘图了。
#        6.复制本脚本：plotting_v6.R和命令投递脚本：runplotting.sh到项目路径下；
#        7.执行分析命令：nohup sh runplotting.sh &
#        8.配置环境变量后（在个人的.bashrc文件加入下面的信息：export PATH=/public/hstore5/proteome/pipeline/script/project_r_plotting:$PATH，然后source保存），直接执行runplo即可
#
#
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
# print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>/*Processing*/>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")

## 设置当前工作目录
setwd("./")

## 导入R包
analysis_need_packages <- c("ggplot2", "plotrix", "openxlsx","pcaMethods", "readxl", "plot3D", "ggrepel", "corrplot", "progress", "ggrepel")
sapply(analysis_need_packages, library, character.only = T)

## 脚本执行进度条
print("分析开始：Start")
ppbb <- progress_bar$new(total = 1000)
for (i in 1:1000) {
   ppbb$tick()
   Sys.sleep(1 / 1000)
}

####################*****************\\\\\\\//////\\\\\\\*********************#############################
#
########################################################################################################
# 第一部分：原始数据统计分析及可视化——分布直方图(histogram)					       #
########################################################################################################
# res_dir <- dir(path="./",pattern="^iTRAQ results")
res_dir <- dir(path="./",pattern="* results*", ignore.case = F)
res_dir

if (length(res_dir)!=0){
  ## 遍历文件夹
  for (i in res_dir) {
    setwd(i)
    pro_dataname <- dir(path="./",pattern="^Protein quantitation.*.xlsx$")
    data_pro <- read.xlsx(pro_dataname, sheet = 1, startRow = 2, colNames = T, rowNames = F, detectDates = F)
    pep_dataname <- dir(path = "./",pattern = "^Peptide groups*")
    data_pep <- read.xlsx(pep_dataname, sheet = 1, startRow = 2, colNames = T, rowNames = F, detectDates = F)

    ### 4.1 第一种数据：分子质量
    dim(data_pro)
    head(data_pro)
    rownames(data_pro) <- data_pro[,1]
    head(rownames(data_pro))
    data_pro_new <- data.frame(row.names(data_pro), data_pro$Accession, data_pro$`MW.[kDa]`)
    colnames(data_pro_new) <- c("row.names", "Accession", "MW.[kDa]")
    dim(data_pro_new)
    head(data_pro_new, n = 10)

    ### 4.2 第二种数据：肽段数
    dim(data_pep)
    data_pep_new <- data.frame(data_pep$Annotated.Sequence,data_pep$Master.Protein.Accessions)
    head(data_pep_new, n = 10)
    colnames(data_pep_new) <- c("Annotated.Sequence","Master.Protein.Accessions")
    pep <- unlist(table(data_pep_new$Master.Protein.Accessions))
    class(pep)
    pep <- as.data.frame(pep)
    head(pep, n = 10)
    colnames(pep) <- c("Master.Protein.Accessions", "Freq")
    pep <- pep[order(pep$Freq), ] # 按照Freq列由小到大对数据框进行排序

    ## 5.绘图
    ## 新建一个histogram目录
    setwd("../")
    dir()
    if (dir.exists("histogram")){
      list.files("histogram")
    } else {
      dir.create("histogram")
      dir.exists("histogram")
    }
    setwd("./histogram")
    
    ### 5.1 第一种图：蛋白分子质量分布直方图
    abc <- gsub(" ", "_", i) ## 命名方法
    ggplot(data_pro_new, aes(data_pro_new$`MW.[kDa]`)) +
      geom_histogram(binwidth = 50, fill = "brown1", col = "black") +
      theme_bw() +
      theme(panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), axis.line = element_line(colour = "black")) +
      theme(plot.margin = unit(rep(2,4),'lines'), aspect.ratio = .6) +
      theme(legend.text = element_text(size = 15, colour = "black")) +
      theme(legend.title = element_text(face = "bold", size = 20)) +
      theme(axis.title.x = element_text(size=16), axis.title.y=element_text(size=16)) +
      xlab("Molecular weight(kDa)") +
      ylab("Number of identified proteins")
    ggsave(paste0(abc,"_Molecular_weight_distribution.pdf"), width = 12, height = 7.5, units = "in")
    ggsave(paste0(abc,"_Molecular_weight_distribution.png"), width = 12, height = 7.5, units = "in")
    dir("./histogram")
    
    ### 5.2 第二种图：肽段数分布直方图
    ggplot(pep, aes(pep$Freq)) +
      geom_histogram(binwidth = 5, fill = "dodgerblue", col = "black") +
      theme_bw() +
      theme(panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), axis.line = element_line(colour = "black")) +
      theme(plot.margin = unit(rep(2,4),'lines'), aspect.ratio = .6) +
      theme(legend.text = element_text(size = 15, colour = "black")) +
      theme(legend.title = element_text(face = "bold", size = 20)) +
      theme(axis.title.x = element_text(size=16), axis.title.y=element_text(size=16)) +
      xlab("Peptide number") +
      ylab("Number of identified proteins")
    ggsave(paste0(abc,"_Peptide_number-proteins.pdf"), width = 12, height = 7.5, units = "in")
    ggsave(paste0(abc,"_Peptide_number-proteins.png"), width = 12, height = 7.5, units = "in")
    dir("./histogram")
    setwd("../")
    setwd(i)
    
    ### 5.3 饼图
    #### 5.3.1.读取原始蛋白质谱搜库数据：Protein quantitation*.xlsx
    pro_dataname <- dir(path="./",pattern="^Protein quantitation.*.xlsx$")
    data_pro <- read.xlsx(pro_dataname, sheet = 1, startRow = 2, colNames = T, rowNames = F, detectDates = F)
    dim(data_pro)
    
    #### 5.3.2.数据处理
    rownames(data_pro) <- data_pro$Accession
    data_pie_new <- data.frame(rownames(data_pro), data_pro$`Coverage.[%]`)
    head(data_pie_new)
    colnames(data_pie_new) <- c("Accession", "Coverage")
    head(data_pie_new)
    dim(data_pie_new)
    max(data_pie_new$Coverage)
    min(data_pie_new$Coverage)
    A <- NROW(data_pie_new[data_pie_new$Coverage <= 10,])
    B <- NROW(data_pie_new[data_pie_new$Coverage > 10 & data_pie_new$Coverage <= 20,])
    C <- NROW(data_pie_new[data_pie_new$Coverage > 20 & data_pie_new$Coverage <= 30,])
    D <- NROW(data_pie_new[data_pie_new$Coverage > 30 & data_pie_new$Coverage <= 40,])
    E <- NROW(data_pie_new[data_pie_new$Coverage > 40,])
    
    setwd("../")
    #### 5.3.3 绘图
    ## 新建一个pie目录 ##
    if (dir.exists("pie")){
      list.dirs("pie")
      list.files("pie")
    }else{
      dir.create("pie")
      dir.exists("pie")
    }
    
    setwd("./pie")

    ##### 2D饼图
    x <- c(A, B, C, D, E)
    labels <- c("0-10%", "10-20%", "20-30%", "30-40%",">40%")
    pdf(paste0(abc,"_Peptide_coverage_2D.pdf"), width = 12, height = 7.5)
    pie(x, labels = labels, col = rainbow(length(x)), main = "The rate of peptide coverage(%)")
    dev.off()
    png(paste0(abc,"_Peptide_coverage_2D.png"), type = "cairo", width = 1200, height = 750)
    pie(x, labels = labels, col = rainbow(length(x)), main = "The rate of peptide coverage(%)")
    dev.off()

    ##### 3D饼图
    pdf(paste0(abc,"_Peptide_coverage_3D.pdf"), width = 12, height = 7.5)
    pie3D(x, labels = labels, explode = 0.1, height = 0.25, main = "The rate of peptide coverage(%)")
    dev.off()
    png(paste0(abc,"_Peptide_coverage_3D.png"), type = "cairo", width = 1200, height = 750)
    pie3D(x, labels = labels, explode = 0.1, height = 0.25, main = "The rate of peptide coverage(%)")
    dev.off()
    setwd("../")
    print("肽段覆盖度饼图已经绘制完成，请查看目录pie")
    list.files("./pie")
  }
} else if (length(res_dir)==0){
  ## 3.读取数据
  ### 3.1两种数据，两种直方图，第一种图：分子质量分布直方图；第二种图：肽段数分布直方图
  ### 读取Label free的原始数据：附件1（蛋白鉴定定量总表.xlsx）和附件2（肽段鉴定表）进行判断，如果有则按照Label free的数据类型分析流程进行分析及作图，如果没有则按照标记的项目数据进行分析及出图
  labefree_pro <- dir(path = './', pattern = "^附件1  蛋白鉴定定量总表.xlsx$")
  labefree_pep <- dir(path = './', pattern = "^附件2  肽段鉴定表.xlsx$")
  if (length(labefree_pro) == 1) {
    ### 第一种图蛋白分子质量分布直方图
    data_pro_lf <- read.xlsx(paste0('./',labefree_pro), sheet = "proteinGroups", startRow = 1, colNames = T, rowNames = F, detectDates = F) # sheetname如果不是：proteinGroups时就匹配不上，就会报错
    dim(data_pro_lf)
    colnames(data_pro_lf)
    head(rownames(data_pro_lf))
    rownames(data_pro_lf) <- data_pro_lf[,1]
    print("修改过后的行名：")
    head(rownames(data_pro_lf))
    data_pro_lf_new <- data.frame(data_pro_lf$Protein.IDs, data_pro_lf$`Mol..weight.[kDa]`) # Protein.IDs 与Accession在这里是相同的意思
    print("重组后的数据大小为：")
    dim(data_pro_lf_new)
    head(data_pro_lf_new)
    colnames(data_pro_lf_new) <- c("Accession", "MW.[kDa]") # 改变列名
    
    ## 新建一个histogram目录 ##
    dir()
    if (dir.exists("histogram")){
      list.files("histogram")
    }else{
      dir.create("histogram")
      dir.exists("histogram")
    }
    setwd("./histogram")
    
    ## plotting ##
    ggplot(data_pro_lf_new, aes(data_pro_lf_new$`MW.[kDa]`)) +
      geom_histogram(binwidth = 50, fill = "brown1", col = "black") +
      theme_bw() +
      theme(panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), axis.line = element_line(colour = "black")) +
      theme(plot.margin = unit(rep(2,4),'lines'), aspect.ratio = .6) +
      theme(legend.text = element_text(size = 15, colour = "black")) +
      theme(legend.title = element_text(face = "bold", size = 20)) +
      theme(axis.title.x = element_text(size=16), axis.title.y=element_text(size=16)) +
      xlab("Molecular weight(kDa)") +
      ylab("Number of identified proteins")
    ggsave("1.Molecular_weight_distribution.pdf", width = 12, height = 7.5, units = "in")
    ggsave("1.Molecular_weight_distribution.png", width = 12, height = 7.5, units = "in")

    ## 退出histogram目录 ##
    setwd("../")

    ### 第二种图肽段数分布直方图
    data_pep_lf <- read.xlsx(paste0('./',labefree_pep), startRow = 1, sheet = "peptides", colNames = T, rowNames = F, detectDates = F)
    dim(data_pep_lf)
    colnames(data_pep_lf)
    head(row.names(data_pep_lf))
    data_pep_lf_new <- data.frame(data_pep_lf$Sequence, data_pep_lf$Proteins)
    dim(data_pep_lf_new)
    head(data_pep_lf_new)
    colnames(data_pep_lf_new) <- c("Sequence", "Proteins")
    head(data_pep_lf_new)
    pep_lf <- unlist(table(data_pep_lf_new$Proteins))
    class(pep_lf)
    pep_lf <- as.data.frame(pep_lf)
    head(pep_lf, n = 10)
    colnames(pep_lf) <- c("Master.Protein.Accessions", "Freq")
    head(pep_lf)
    
    ## 新建一个histogram目录 ##
    dir()
    if (dir.exists("histogram")){
      list.files("histogram")
    }else{
      dir.create("histogram")
      dir.exists("histogram")
    }
    setwd("./histogram")
    
    ## plotting ##
    ggplot(pep_lf, aes(pep_lf$Freq)) +
      geom_histogram(binwidth = 5, fill = "dodgerblue", col = "black") + 
      theme_bw() +
      theme(panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), axis.line = element_line(colour = "black")) +
      theme(plot.margin = unit(rep(2,4),'lines'), aspect.ratio = .6) +
      theme(legend.text = element_text(size = 15, colour = "black")) +
      theme(legend.title = element_text(face = "bold", size = 20)) +
      theme(axis.title.x = element_text(size=16), axis.title.y=element_text(size=16)) +
      xlab("Peptide number") +
      ylab("Number of identified proteins")
    ggsave("2.Peptide_number-proteins.pdf", width = 12, height = 7.5, units = "in")
    ggsave("2.Peptide_number-proteins.png", width = 12, height = 7.5, units = "in")

    ## 退出histogram目录 ##
    setwd("../")
    print("蛋白分子分布直方图和肽段数分布直方图已经绘制完成，请查看目录histogram")
    list.files("./histogram")
    
    ### 第三种图肽段序列覆盖度饼图
    ## 新建一个pie目录 ##
    dir()
    if (dir.exists("pie")){
      list.files("pie")
    }else{
      dir.create("pie")
      dir.exists("pie")
    }
    setwd("./pie")
    
    data_pie_lf <- data.frame(rownames(data_pro_lf), data_pro_lf$`Sequence.coverage.[%]`)
    dim(data_pie_lf)
    head(data_pie_lf)
    colnames(data_pie_lf) <- c("Accession", "Coverage")
    head(data_pie_lf)
    dim(data_pie_lf)
    max(data_pie_lf$Coverage)
    min(data_pie_lf$Coverage)

    A <- NROW(data_pie_lf[data_pie_lf$Coverage <= 10,])
    B <- NROW(data_pie_lf[data_pie_lf$Coverage > 10 & data_pie_lf$Coverage <= 20,])
    C <- NROW(data_pie_lf[data_pie_lf$Coverage > 20 & data_pie_lf$Coverage <= 30,])
    D <- NROW(data_pie_lf[data_pie_lf$Coverage > 30 & data_pie_lf$Coverage <= 40,])
    E <- NROW(data_pie_lf[data_pie_lf$Coverage > 40,])

    x <- c(A, B, C, D, E)
    labels <- c("0-10%", "10-20%", "20-30%", "30-40%",">40%")
    pdf("3.Peptide_coverage_2D.pdf", width = 12, height = 7.5)
    pie(x, labels = labels, col = rainbow(length(x)), main = "The rate of peptide coverage(%)")
    dev.off()
    png("3.Peptide_coverage_2D.png", type = "cairo", width = 1200, height = 750)
    pie(x, labels = labels, col = rainbow(length(x)), main = "The rate of peptide coverage(%)")
    dev.off()

    pdf("3.Peptide_coverage_3D.pdf", width = 12, height = 7.5)
    pie3D(x, labels = labels, explode = 0.1, height = 0.25, main = "The rate of peptide coverage(%)")
    dev.off()
    png("3.Peptide_coverage_3D.png", type = "cairo", width = 1200, height = 750)
    pie3D(x, labels = labels, explode = 0.1, height = 0.25, main = "The rate of peptide coverage(%)")
    dev.off()
    setwd("../")
    print("肽段覆盖度饼图已经绘制完成，请查看目录pie")
    list.files("./pie")
    
  } else if (length(labefree_pro) != 1){

    ### data_pro-蛋白分子质量
    pro_dataname <- dir(path="./",pattern="^Protein quantitation.*.xlsx$")
    data_pro <- read.xlsx(pro_dataname, sheet = 1, startRow = 2, colNames = T, rowNames = F, detectDates = F)

    ### 3.2 data_pep-肽段数
    pep_dataname <- dir(path="./",pattern="^Peptide groups.xlsx$")
    data_pep <- read.xlsx(pep_dataname, sheet = 1, startRow = 2, colNames = T, rowNames = F, detectDates = F)

    ## 4.数据处理
    ### 4.1 第一种数据：分子质量
    dim(data_pro)
    head(data_pro)
    rownames(data_pro) <- data_pro[,1]
    head(rownames(data_pro))
    data_pro_new <- data.frame(row.names(data_pro), data_pro$Accession, data_pro$`MW.[kDa]`)
    colnames(data_pro_new) <- c("row.names", "Accession", "MW.[kDa]")
    dim(data_pro_new)
    head(data_pro_new, n = 10)

    ### 4.2 第二种数据：肽段数
    dim(data_pep)
    data_pep_new <- data.frame(data_pep$Annotated.Sequence,data_pep$Master.Protein.Accessions)
    head(data_pep_new, n = 10)
    colnames(data_pep_new) <- c("Annotated.Sequence","Master.Protein.Accessions")
    pep <- unlist(table(data_pep_new$Master.Protein.Accessions))
    class(pep)
    pep <- as.data.frame(pep)
    head(pep, n = 10)
    colnames(pep) <- c("Master.Protein.Accessions", "Freq")
    pep <- pep[order(pep$Freq), ] # 按照Freq列由小到大对数据框进行排序

    ## 5.绘图
    ### 5.1 第一种图：蛋白分子质量分布直方图
    dir()
    if (dir.exists("histogram")){
      list.dirs("histogram")
      list.files("histogram")
    }else{
      dir.create("histogram")
      dir.exists("histogram")
    }
    # [1] TRUE
    setwd("./histogram") # 设置当前的工作目录为histogram，后面分析绘制直方图完成后记得退出来当前工作目录
    getwd()

    ## ggplot绘图
    ggplot(data_pro_new, aes(data_pro_new$`MW.[kDa]`)) +
      geom_histogram(binwidth = 50, fill = "brown1", col = "black") + 
      theme_bw() +
      theme(panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), axis.line = element_line(colour = "black")) +
      theme(plot.margin = unit(rep(2,4),'lines'), aspect.ratio = .6) +
      theme(legend.text = element_text(size = 15, colour = "black")) +
      theme(legend.title = element_text(face = "bold", size = 20)) +
      theme(axis.title.x = element_text(size=16), axis.title.y=element_text(size=16)) +
      xlab("Molecular weight(kDa)") +
      ylab("Number of identified proteins")
    ggsave("1.Molecular_weight_distribution.pdf", width = 12, height = 7.5, units = "in")
    ggsave("1.Molecular_weight_distribution.png", width = 12, height = 7.5, units = "in")

    ### 5.2 第二种图：肽段数分布直方图
    ## ggplot绘图
    ggplot(pep, aes(pep$Freq)) +
      geom_histogram(binwidth = 5, fill = "dodgerblue", col = "black") +
      theme_bw() +
      theme(panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), axis.line = element_line(colour = "black")) +
      theme(plot.margin = unit(rep(2,4),'lines'), aspect.ratio = .6) +
      theme(legend.text = element_text(size = 15, colour = "black")) +
      theme(legend.title = element_text(face = "bold", size = 20)) +
      theme(axis.title.x = element_text(size=16), axis.title.y=element_text(size=16)) +
      xlab("Peptide number") +
      ylab("Number of identified proteins")
    ggsave("2.Peptide_number-proteins.pdf", width = 12, height = 7.5, units = "in")
    ggsave("2.Peptide_number-proteins.png", width = 12, height = 7.5, units = "in")
    setwd("../")
    print("蛋白分子质量和肽段数分布直方图已经绘制完成，请查看目录histogram！")
    list.files("./histogram")

    ########################################################################################################
    ## 第二部分：原始数据统计分析及可视化——肽段序列覆盖度饼图(pie)					  ##
    ########################################################################################################
    dir()
    getwd() ## 查看当前工作目录

    ## 新建一个pie目录 ##
    if (dir.exists("pie")){
      list.dirs("pie")
      list.files("pie")
    }else{
      dir.create("pie")
      dir.exists("pie")
    }
    # [1] TRUE

    ## 1.读取原始蛋白质谱搜库数据：Protein quantitation*.xlsx
    pro_dataname <- dir(path="./",pattern="^Protein quantitation.*.xlsx$")
    data_pro <- read.xlsx(pro_dataname, sheet = 1, startRow = 2, colNames = T, rowNames = F, detectDates = F)
    dim(data_pro)

    ## 2.数据处理
    rownames(data_pro) <- data_pro$Accession
    data_pie_new <- data.frame(rownames(data_pro), data_pro$`Coverage.[%]`)
    head(data_pie_new)
    colnames(data_pie_new) <- c("Accession", "Coverage")
    head(data_pie_new)
    dim(data_pie_new)
    max(data_pie_new$Coverage)
    min(data_pie_new$Coverage)
    A <- NROW(data_pie_new[data_pie_new$Coverage <= 10,])
    B <- NROW(data_pie_new[data_pie_new$Coverage > 10 & data_pie_new$Coverage <= 20,])
    C <- NROW(data_pie_new[data_pie_new$Coverage > 20 & data_pie_new$Coverage <= 30,])
    D <- NROW(data_pie_new[data_pie_new$Coverage > 30 & data_pie_new$Coverage <= 40,])
    E <- NROW(data_pie_new[data_pie_new$Coverage > 40,])

    ## 3.绘图
    setwd("./pie") ## 将当前的工作目录切换到pie

    ### 3.1 2D饼图
    x <- c(A, B, C, D, E)
    labels <- c("0-10%", "10-20%", "20-30%", "30-40%",">40%")
    pdf("3.Peptide_coverage_2D.pdf", width = 12, height = 7.5)
    pie(x, labels = labels, col = rainbow(length(x)), main = "The rate of peptide coverage(%)")
    dev.off()
    png("3.Peptide_coverage_2D.png", type = "cairo", width = 1200, height = 750)
    pie(x, labels = labels, col = rainbow(length(x)), main = "The rate of peptide coverage(%)")
    dev.off()

    ### 3.2 3D饼图
    pdf("3.Peptide_coverage_3D.pdf", width = 12, height = 7.5)
    pie3D(x, labels = labels, explode = 0.1, height = 0.25, main = "The rate of peptide coverage(%)")
    dev.off()
    png("3.Peptide_coverage_3D.png", type = "cairo", width = 1200, height = 750)
    pie3D(x, labels = labels, explode = 0.1, height = 0.25, main = "The rate of peptide coverage(%)")
    dev.off()
    setwd("../")
    print("肽段序列覆盖度饼图已经绘制完成，请查看目录pie中的文件！")
    list.files("./pie")
  }
}
#
# ########################################################################################################
# ### 第三部分：可信蛋白的样品PCA图(2D&3D)                                                             ###
# ########################################################################################################
# #
# ## 3.读取测试数据：项目的差异蛋白筛选结果文件（格式为.xlsx）
# ### 3.1判断差异蛋白筛选结果文件中的是否有“可信蛋白”，还是有“合并可信蛋白”，对应导入数据
# if ("合并可信蛋白" %in% readxl::excel_sheets("./差异蛋白筛选结果.xlsx") == TRUE){
#   trusted_prot <- read.xlsx("./差异蛋白筛选结果.xlsx", sheet = "合并可信蛋白", startRow = 1, colNames = TRUE, rowNames = FALSE, detectDates = FALSE)
#   print("合并可信蛋白原始数据大小为：")
#   dim(trusted_prot)
# }else if ("可信蛋白" %in% readxl::excel_sheets("./差异蛋白筛选结果.xlsx") == TRUE){
#   trusted_prot <- read.xlsx("./差异蛋白筛选结果.xlsx", sheet = "可信蛋白", startRow = 1, colNames = TRUE, rowNames = FALSE, detectDates = FALSE)
#   print("可信蛋白原始数据大小为：")
#   dim(trusted_prot)
# }else if ("总可信蛋白" %in% readxl::excel_sheets("./差异蛋白筛选结果.xlsx") == TRUE){
#   trusted_prot <- read.xlsx("./差异蛋白筛选结果.xlsx", sheet = "总可信蛋白", startRow = 1, colNames = TRUE, rowNames = FALSE, detectDates = FALSE)
#   print("可信蛋白原始数据大小为：")
#   dim(trusted_prot)
# }
# 
# ## 4.数据处理：对可信蛋白数据进行提取和处理
# if ("MIX" %in% colnames(trusted_prot) == TRUE){
#   trusted_prot$MIX <- NULL
# }else if ("Mix" %in% colnames(trusted_prot) == TRUE){
#   trusted_prot$Mix <- NULL
# }else if (length(colnames(trusted_prot)) != 0){
#   print("查看处理过MIX/Mix问题后的可信蛋白数据大小：")
#   dim(trusted_prot)
# }
# 
# print("查看trusted_prot的列名：")
# colnames(trusted_prot)
# head(trusted_prot[,1])
# colnames(trusted_prot)[1]
# # [1] "Accession"
# colnames(trusted_prot)[1] <- ""
# colnames(trusted_prot)[1]
# # [1] ""
# row.names(trusted_prot) <- trusted_prot[,1]
# head(rownames(trusted_prot))
# 
# ### 4.1 样品数据匹配
# Sample_info <- read.xlsx("sample_information.xlsx", sheet = "样品信息", startRow = 1, colNames = TRUE, rowNames = FALSE, detectDates = FALSE) # 读取sample_information.xlsx表格中的信息
# rownames(Sample_info) <- Sample_info$作图编号
# print("查看读取的Sample_info的数据中的样品信息：")
# #### 去掉sample_information.xlsx样品信息表格文件中的MIX/Mix/mix行，后面分析不需要
# # if (which(Sample_info == "MIX") != 0){
# #         Sample_info <- Sample_info[-which(Sample_info == "MIX"),]
# # } else if (which(Sample_info == "Mix") != 0) {
# # 	Sample_info <- Sample_info[-which(Sample_info == "Mix"),]
# # } else if (which(sample_info_1 == "mix") != 0) {
# # 	Sample_info <- Sample_info[-which(Sample_info == "mix"),]
# # }
# # 
# # Sample_info <- Sample_info[-which(Sample_info == "MIX"),]
# # Sample_info <- Sample_info[-which(Sample_info == "Mix"),]
# # Sample_info <- Sample_info[-which(Sample_info == "mix"),]
# if ("MIX" %in% rownames(Sample_info) == TRUE){
#   Sample_info <- Sample_info[-which(Sample_info == "MIX"),]
#   dim(Sample_info)
#   Sample_info
# }else if ("Mix" %in% rownames(Sample_info) == TRUE){
#   Sample_info <- Sample_info[-which(Sample_info == "Mix"),]
#   dim(Sample_info)
#   Sample_info
# }else if ("mix" %in% rownames(Sample_info) == TRUE){
#   Sample_info <- Sample_info[-which(Sample_info == "mix"),]
#   dim(Sample_info)
#   Sample_info
# }
# 
# Sample_info$作图编号 <- NULL
# colnames(Sample_info) <- c("Sample", "Sample_abc")
# Sample_info$Sample_abc <- gsub(" ", ".", Sample_info$Sample_abc) # 替换字符串
# sama <- match(Sample_info$Sample_abc, colnames(trusted_prot))
# print("查看Sample_abc在trusted_prot中匹配到的位置信息")
# sama[!is.na(sama)]
# sama
# 
# #### 根据样品位置信息进行数据重组
# trusted_prot_new <- trusted_prot[,sama]
# print("查看样品匹配后的数据大小：")
# dim(trusted_prot_new)
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
# addWorksheet(wb, "1.trusted_proteins_new_data", tabColour = "red")
# writeData(wb, sheet = "1.trusted_proteins_new_data", trusted_prot_new)
# saveWorkbook(wb, "PCA_Data.xlsx", overwrite = TRUE)
# 
# # 数据框转换为矩阵，行列转置
# trusted_prot_new <- t(as.matrix(trusted_prot_new))
# # print("查看去掉无用信息后，行列转置后的数据行名、列名和大小：")
# dim(trusted_prot_new)
# row.names(trusted_prot_new)
# head(colnames(trusted_prot_new))
# class(trusted_prot_new)
# 
# ### 4.2 计算PCA值：PC1、PC2和PC3，构建PCA对象
# trusted_prot_pca <- pca(trusted_prot_new, scale = "uv", nPcs = 3)
# print("查看PCA对象的数据类型：")
# class(trusted_prot_pca)
# # [1] "pcaRes"
# # attr(,"package")
# # [1] "pcaMethods"
# print("查看数据的PCA主成分数值，如下：")
# trusted_prot_pca@scores
# 
# ### 4.3 合并PCA数据
# trusted_prot_pca_socr <- merge(trusted_prot_new, scores(trusted_prot_pca), by = 0)
# print("查看合并后的数据大小为：")
# dim(trusted_prot_pca_socr)
# ### 4.4 保存PCA计算后合并的新数据
# dir()
# 
# #### 写入trusted_prot_pca_plot数据
# addWorksheet(wb, "2.trusted_prot_pca_socr", tabColour = "orange")
# writeData(wb, sheet = "2.trusted_prot_pca_socr", trusted_prot_pca_socr)
# saveWorkbook(wb, "PCA_Data.xlsx", overwrite = TRUE)
# 
# ### 4.5 读取Sample_info文件，构建绘图数据
# # print("查看读取的Sample_info的数据中的样品信息")
# head(Sample_info)
# class(Sample_info)
# dim(Sample_info)
# sn <- length(unique(Sample_info$Sample))
# print(paste0("样品数量为：",sn,"个"))
# class(trusted_prot_pca_socr)
# dim(trusted_prot_pca_socr)
# trusted_prot_pca_plot <- cbind(trusted_prot_pca_socr, Sample_info)
# dim(trusted_prot_pca_plot)
# 
# ## 5.绘制PCA 2D图和保存图片、数据
# 
# #### 写入trusted_prot_pca_plot数据
# addWorksheet(wb, "5.trusted_proteins_plot_data", tabColour = "blue")
# writeData(wb, sheet = "5.trusted_proteins_plot_data", trusted_prot_pca_plot)
# saveWorkbook(wb, "PCA_Data.xlsx", overwrite = TRUE)
# 
# ### 5.1 计算PCA方差占比（解释率）
# pc1_sdev <- sd(trusted_prot_pca_socr$PC1)
# pc2_sdev <- sd(trusted_prot_pca_socr$PC2)
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
#     ggplot(trusted_prot_pca_plot, aes(trusted_prot_pca_plot$PC1,trusted_prot_pca_plot$PC2, colour = Sample)) +
#       geom_point(size = 5) +
#       geom_text_repel(aes(label = trusted_prot_pca_plot$Sample_abc)) +
#       # geom_text(label = trusted_prot_pca_plot$Sample_abc, size = 3, check_overlap = F, col = "black", hjust = "center", vjust = "middle") +
#       # geom_text(label = trusted_prot_pca_plot$Sample_abc, size = 3, check_overlap = F, col = "black", hjust = "inward", vjust = "inward") +
#       xlab(paste0("PC1 ", round(percentVar2D$pc1_percent_variance,2), "% variance")) +
#       ylab(paste0("PC2 ", round(percentVar2D$pc2_percent_variance,2), "% variance")) +
#       theme_bw() +
#       theme(panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), axis.line = element_line(colour = "black")) +
#       theme(plot.margin = unit(rep(7,4),'lines'), aspect.ratio = 1.0) +
#       theme(legend.text = element_text(size = 15, colour = "black")) +
#       theme(legend.title = element_text(face = "bold", size = 20)) +
#       theme(axis.title.x =element_text(size=16), axis.title.y=element_text(size=16)) +
#       stat_ellipse()
#     ggsave("PCA_2D.pdf", width = 12, height = 7.5, units = "in")
#     ggsave("PCA_2D.png", width = 12, height = 7.5, units = "in")
# } else if (sn < 3){
#     ggplot(trusted_prot_pca_plot,aes(trusted_prot_pca_plot$PC1,trusted_prot_pca_plot$PC2, colour = Sample)) +
#       geom_point(size = 5) + 
#       geom_text_repel(aes(label = trusted_prot_pca_plot$Sample_abc)) +
#       # geom_text(label = trusted_prot_pca_plot$Sample_abc, size = 3, check_overlap = F, col = "black", hjust = "inward", vjust = "inward") +
#       xlab(paste0("PC1 ", round(percentVar2D$pc1_percent_variance,2), "% variance")) +
#       ylab(paste0("PC2 ", round(percentVar2D$pc2_percent_variance,2), "% variance")) +
#       theme_bw() +
#       theme(panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), axis.line = element_line(colour = "black")) +
#       theme(plot.margin = unit(rep(7,4),'lines'), aspect.ratio = 1.0) +
#       theme(legend.text = element_text(size = 15, colour = "black")) +
#       theme(legend.title = element_text(size = 20, face = "bold")) +
#       theme(axis.title.x =element_text(size=16), axis.title.y=element_text(size=16)) + 
#       stat_ellipse()
#     ggsave("PCA_2D.pdf", width = 12, height = 7.5, units = "in")                                    
#     ggsave("PCA_2D.png", width = 12, height = 7.5, units = "in")
# 
# }
# 
# ## 6.计算PCA三个主成分的方差占比
# pc1_sdev <- sd(trusted_prot_pca_socr$PC1)
# pc2_sdev <- sd(trusted_prot_pca_socr$PC2)
# pc3_sdev <- sd(trusted_prot_pca_socr$PC3)
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
# trusted_prot_pca_plot <- cbind(trusted_prot_pca_socr, Sample_info)
# dim(trusted_prot_pca_plot)
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
# scatter3D(x = trusted_prot_pca_plot$PC1, y = trusted_prot_pca_plot$PC2, z = trusted_prot_pca_plot$PC3, xlab = paste0("PC1 ", round(percentVar3D$PC1_percent_variance,2), "% variance"), ylab = paste0("PC2 ", round(percentVar3D$PC2_percent_variance,2), "% variance"), zlab = paste0("PC3 ", round(percentVar3D$PC3_percent_variance,2), "% variance"), labels = trusted_prot_pca_plot$Sample_abc, col = sacol, phi = 5, theta = 32, bty = 'b2', pch = 20, cex = 5, ticktype = "detailed", plot = TRUE, adj = 0.5, font = 2, colkey = list(at = spos, side = 4, addlines = FALSE, length = sl, width = 0.6, labels = unique(trusted_prot_pca_plot$Sample), cex.clab = 1.5), clab = "Sample", colvar = as.integer(trusted_prot_pca_plot$Sample))
# dev.off()
# 
# png("PCA_3D.png", width = 1200, height = 750)
# scatter3D(x = trusted_prot_pca_plot$PC1, y = trusted_prot_pca_plot$PC2, z = trusted_prot_pca_plot$PC3, xlab = paste0("PC1 ", round(percentVar3D$PC1_percent_variance,2), "% variance"), ylab = paste0("PC2 ", round(percentVar3D$PC2_percent_variance,2), "% variance"), zlab = paste0("PC3 ", round(percentVar3D$PC3_percent_variance,2), "% variance"), labels = trusted_prot_pca_plot$Sample_abc, col = sacol, phi = 5, theta = 32, bty = 'b2', pch = 20, cex = 5, ticktype = "detailed", plot = TRUE, adj = 0.5, font = 2, colkey = list(at = spos, side = 4, addlines = FALSE, length = sl, width = 0.6, labels = unique(trusted_prot_pca_plot$Sample), cex.clab = 1.5), clab = "Sample", colvar = as.integer(trusted_prot_pca_plot$Sample))
# dev.off()
# 
# dir()
# list.files()
# setwd("../")
# dir()
# print("PCA分析及绘图完成！请查看PCA目录中的图片和数据文件PCA_Data.xlsx。")
# list.files("./PCA")

########################################################################################################
#### 第四部分：比较组差异蛋白相关性热图(correlation heatmap)					    ####
#######################################################################################################
#
## 3.读取数据
#############################################################################
### 3.1 sample_information
sample_info_1 <- read.xlsx("sample_information.xlsx", sheet = "样品信息", startRow = 1, colNames = TRUE, rowNames = FALSE, detectDates = FALSE)
sample_info_2 <- read.xlsx("sample_information.xlsx", sheet = "比较组信息", startRow = 1, colNames = TRUE, rowNames = FALSE, detectDates = FALSE)
class(sample_info_1)
class(sample_info_2)
#### 去掉对象sample_info_1中的MIX/Mix/mix行信息
# if (which(sample_info_1 == "MIX") != 0){
# 	sample_info_1 <- sample_info_1[-which(sample_info_1 == "MIX"),]
# } else if (which(sample_info_1 == "Mix") != 0) {
# 	sample_info_1 <- sample_info_1[-which(sample_info_1 == "Mix"),]
# } else if (which(sample_info_1 == "mix") != 0) {
# 	sample_info_1 <- sample_info_1[-which(sample_info_1 == "mix"),]
# }
# sample_info_1 <- sample_info_1[-which(sample_info_1 == "Mix"),]
# sample_info_1 <- sample_info_1[-which(sample_info_1 == "mix"),]
rownames(sample_info_1) <- sample_info_1$作图编号
#
if ("MIX" %in% rownames(sample_info_1) == TRUE){
  sample_info_1 <- sample_info_1[-which(sample_info_1 == "MIX"),]
  dim(sample_info_1)
  sample_info_1
}else if ("Mix" %in% rownames(sample_info_1) == TRUE){
  sample_info_1 <- sample_info_1[-which(sample_info_1 == "Mix"),]
  dim(sample_info_1)
  sample_info_1
}else if ("mix" %in% rownames(sample_info_1) == TRUE){
  sample_info_1 <- sample_info_1[-which(sample_info_1 == "mix"),]
  dim(sample_info_1)
  sample_info_1
}
#
dim(sample_info_2)
sample_info_1
class(sample_info_1$样品编号)
samp_numb <- sample_info_1$样品编号
sample_info_2
compa_groups <- 1:length(sample_info_2$比较组)
compa_groups

for (i in compa_groups){
  # print(sample_info[i,1])
  # print(gsub("/","_",sample_info[i,1]))
  class(gsub("/","_",sample_info_2[i,1]))
  new_compa_groups <- gsub("/","_",sample_info_2[i,1])
  class(new_compa_groups)
  print(new_compa_groups)
  data <- read.xlsx("差异蛋白筛选结果.xlsx", sheet = new_compa_groups, startRow = 1, colNames = TRUE, rowNames = FALSE, detectDates = FALSE)
  dim(data)
  class(data)
  rownames(data) <- data[,1]

  ## 新建一个corrplot目录
  dir()
  if (dir.exists("corrplot")){
    list.dirs("./corrplot")
    list.files("./corrplot")
  }else{
    dir.create("./corrplot")
    dir.exists("corrplot")
  }
  # [1] TRUE
  if (length(data$`P-value`) == 0 ) {
    print("样品没有重复，没有P_value值，不绘制相关性图")
  } else {
    samp_data_order_pv <- data[order(data$`P-value`),] # 按照p value值进行升序排序
    dim(samp_data_order_pv)
    head(colnames(samp_data_order_pv))
    head(rownames(samp_data_order_pv))
    samp_numb <- sample_info_1$样品编号
    sm <- match(samp_numb, colnames(samp_data_order_pv))
    class(sm)
    sm <- as.numeric(sm[!is.na(sm)])
    sm
    samp_data_order_pv_new <- samp_data_order_pv[,sm]
    head(samp_data_order_pv_new)

    if (NROW(samp_data_order_pv_new) >= 50) {
      setwd("./corrplot")
      top50_prot <- data.frame(samp_data_order_pv_new[1:50,]) # 提取样品的top50蛋白质谱数据
      dim(top50_prot)
      head(top50_prot)
      top50_prot_t <- t(top50_prot) # 数据框转置
      top50_prot_t_corr <- cor(top50_prot_t) # 计算top50蛋白的相关性系数
      top50_prot_t_corr[,1:5]
      ## 绘图及保存
      col <- colorRampPalette(c("blue","white", "red"))(1000) # 准备绘图颜色
      pdf(paste0(i,".correlation_",new_compa_groups,".pdf"), width = 10, height = 10)
      M <- corrplot(top50_prot_t_corr, method = "circle", type = "upper", tl.col = "black", tl.cex = 0.8, col = col, order = "hclust", diag = F)
      dev.off()
      png(paste0(i,".correlation_",new_compa_groups,".png"), width = 1000, height = 1000)
      corrplot(top50_prot_t_corr, method = "circle", type = "upper", tl.col = "black", tl.cex = 0.8, col = col, order = "hclust", diag = F)
      dev.off()
      ## 数据保存
      write.csv(M, file = paste0(i,".correlation_coefficients_matrix_",new_compa_groups,".csv"))
      setwd("../")
    } else if (NROW(samp_data_order_pv_new) >= 10 & NROW(samp_data_order_pv_new) < 50) {
      setwd("./corrplot")
      pn <- NROW(samp_data_order_pv_new)
      topless50 <- paste0("top",pn,"_prot") # topless50 代替paste0("top",pn,"_prot")
      topless50 <- as.data.frame(samp_data_order_pv_new) # 获取所有蛋白数据
      dim(topless50)
      head(topless50)
      topless50_t <- t(topless50) # 数据框转置
      topless50_t_corr <- cor(topless50_t) # 计算top蛋白的相关性系数
      topless50_t_corr[1:5,1:5]
      ## 绘图及保存
      col <- colorRampPalette(c("blue","white", "red"))(1000) # 准备绘图颜色
      pdf(paste0(i,".correlation_",new_compa_groups,".pdf"), width = 10, height = 10)
      M <- corrplot(topless50_t_corr, method = "circle", type = "upper", tl.col = "black", tl.cex = 0.8, col = col, order = "hclust", diag= F)
      dev.off()
      png(paste0(i,".correlation_",new_compa_groups,".png"), width = 1000, height = 1000)
      corrplot(topless50_t_corr, method = "circle", type = "upper", tl.col = "black", tl.cex = 0.8, col = col, order = "hclust", diag = F)
      dev.off()
      ## 数据保存
      write.csv(M, file = paste0(i,".correlation_coefficients_matrix_",new_compa_groups,".csv"))
      setwd("../")
    } else {
      setwd("./corrplot")
      print(paste0("注意：比较组",new_compa_groups,"的差异蛋白数太少，所以无法绘制蛋白相关性热图"))
      setwd("../")
    }
    dir()
  }
  dir()
}

if (dir.exists("corrplot")){
  print("比较组差异蛋白相关性热图已经绘制完成，请查看目录corrplot")
  list.files("./corrplot")
}else{
  print("注意：本项目样本数据不适合绘制蛋白相关性热图，所以不绘制蛋白相关性图！")
}

if (length(list.files("./corrplot")) == 0){
  unlink("corrplot", recursive = TRUE, force = FALSE)
} # 判断corrplot目录是否是空目录，如果是空目录就删掉

###########################################################################

### END!
print("输入R包和环境信息：")
sessionInfo()
print("恭喜，本脚本绘图任务完成!!!")
print("祝工作顺利，开心每一天！")
# R version 3.6.1 (2019-07-05)
# Platform: x86_64-w64-mingw32/x64 (64-bit)
# Running under: Windows 10 x64 (build 18362)
# 
# Matrix products: default
# 
# locale:
#   [1] LC_COLLATE=Chinese (Simplified)_China.936  LC_CTYPE=Chinese (Simplified)_China.936    LC_MONETARY=Chinese (Simplified)_China.936
# [4] LC_NUMERIC=C                               LC_TIME=Chinese (Simplified)_China.936    
# 
# attached base packages:
#   [1] parallel  stats     graphics  grDevices utils     datasets  methods   base     
# 
# other attached packages:
#   [1] corrplot_0.84       ggrepel_0.8.1       plot3D_1.1.1        readxl_1.3.1        pcaMethods_1.76.0   Biobase_2.44.0      BiocGenerics_0.30.0
# [8] openxlsx_4.1.0.1    plotrix_3.7-6       ggplot2_3.2.1      
# 
# loaded via a namespace (and not attached):
#   [1] zip_2.0.3        Rcpp_1.0.2       pillar_1.4.2     compiler_3.6.1   cellranger_1.1.0 tools_3.6.1      digest_0.6.20    tibble_2.1.3     gtable_0.3.0    
# [10] pkgconfig_2.0.2  rlang_0.4.0      rstudioapi_0.10  withr_2.1.2      dplyr_0.8.3      grid_3.6.1       tidyselect_0.2.5 glue_1.3.1       R6_2.4.0        
# [19] purrr_0.3.2      magrittr_1.5     scales_1.0.0     assertthat_0.2.1 misc3d_0.8-4     colorspace_1.4-1 labeling_0.3     lazyeval_0.2.2   munsell_0.5.0   
# [28] crayon_1.3.4

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
