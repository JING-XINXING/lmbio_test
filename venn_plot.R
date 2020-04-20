###############################################
# script function: drawing sets of venn plot
# date: 2019/09/30
# author: jingxinxing
# mail: jingxx@lumingbio.com
# version: v2
###############################################
#
## 脚本运行计时开始
pt=proc.time()

## 1.导入R包
library("VennDiagram")
## 2.设置当前工作目录
setwd("./")
## 3.读取提前准备好的数据
venn_data <- read.table("venn_data.csv", header = T, sep = ',', stringsAsFactors = F, check.names = F)

## 4.韦恩图数据集大小判断及绘图
if (length(colnames(venn_data)) == 2){ # 1.two sets #
  venn_list <- list(venn_data[,1], venn_data[,2])
  names(venn_list) <- colnames(venn_data)
  venn.diagram(venn_list, filename = 'venn_two_sets_plot.png', imagetype = 'png', margin = 0.1, fill = c('red', 'blue'), alpha = 0.50, col = 'black', cex = 1, fontfamily = 'serif', cat.col = c('black', 'black'), cat.cex = 1, cat.fontfamily = 'serif', cat.default.pos = "outer")

}else if (length(colnames(venn_data)) == 3){ # 2.three sets #
  venn_list <- list(venn_data[,1], venn_data[,2], venn_data[,3])
  names(venn_list) <- colnames(venn_data)
  venn.diagram(venn_list, filename = 'venn_three_sets_plot.png', imagetype = 'png', margin = 0.1, fill = c('red', 'blue', 'green'), alpha = 0.50, col = 'black', cex = 1, fontfamily = 'serif', label.col = c("darkred", "white", "darkblue", "white", "white", "white", "darkgreen"), cat.cex = 1, cat.fontfamily = 'serif', cat.default.pos = "text", cat.pos = 0)
}else if (length(colnames(venn_data)) == 4){ # 3.four sets #
  venn_list <- list(venn_data[,1], venn_data[,2], venn_data[,3], venn_data[,4])
  names(venn_list) <- colnames(venn_data)
  venn.diagram(venn_list, filename = "Venn_four_sets_plot.png", col = "black", lty = "dotted", lwd = 3, fill = c("cornflowerblue", "green", "yellow", "darkorchid1"), alpha = 0.50, label.col = c("orange", "white", "darkorchid4", "white", "white", "white", "white", "white", "darkblue", "white", "white", "white", "white", "darkgreen", "white"), cex = 2.0, fontfamily = "serif", fontface = "bold", cat.col = c("darkblue", "darkgreen", "orange", "darkorchid4"), cat.cex = 1.8, cat.fontface = "bold", cat.fontfamily = "serif")
}else if (length(colnames(venn_data)) == 5){ # 4.five sets #
  venn_list <- list(venn_data[,1], venn_data[,2], venn_data[,3], venn_data[,4], venn_data[,5])
  names(venn_list) <- colnames(venn_data)
  venn.diagram(venn_list, filename = "venn_five_sets_plot.png", lty = "dotted", lwd = 2, col = "black", fill = c("dodgerblue", "goldenrod1", "darkorange1", "seagreen3", "orchid3"), alpha = 0.60, cat.col = c("dodgerblue", "goldenrod1", "darkorange1", "seagreen3", "orchid3"), cat.cex = 0.8, cat.fontface = "bold", margin = 0.07, cex = 0.8)
}

## 5.打印绘制韦恩图所需要的R包版本信息和环境变量
sessionInfo()

### 脚本耗时
print("脚本运行时间为：")
proc.time()-pt
