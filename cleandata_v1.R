########################################################################################################
# Rscript function: Automatically processes OMICS BEAN file formats and plotting KEGG pathway pbubble
# Author: jingxinxing
# Date: 2019/07/13
# Version: v1
# Usage: 1.copy script(tow script: cleandata_v1.R and runproces.sh) into currently directory and
#        2.sh or bash running runproces.sh
########################################################################################################
#
library(ggplot2)
library(openxlsx)
# library(argpase)

auto_bubble0 <- function(data = data){
  pp = ggplot2::ggplot(data, aes(RichFactor, PathwayTerm))
  pbubble = pp + ggplot2::geom_point(aes(size = Count,color = Pvalue)) +
    ggplot2::theme(axis.text = element_text(size = 10),axis.title = element_text(size = 10), legend.text = element_text(size = 10), legend.title = element_text(size= 10))
  pbubble + ggplot2::scale_colour_gradient(low = "green",high = "red") + guides(size = guide_legend(order = 1))
  ggsave("kegg气泡图.pdf",width = 7, height =5.5)
}

setwd("./生物信息学功能分析结果")

dir = dir()
i <- 1
while(i <= length(dir)){
  path_in <- paste0(dir[i], "/KEGG")
  setwd(path_in)
  getwd()
  if (file.exists("kegg气泡图数据.xlsx")){
    pathway <- openxlsx::read.xlsx("kegg气泡图数据.xlsx",check.names = FALSE)
    auto_bubble0(data=pathway)
  }
  i=i+1
  setwd("../../")
}
dir = dir()
i <- 1
while(i <= length(dir)){
  path_summ <- paste0(dir[i], "/summary")
  setwd(path_summ)
  getwd()
  if (file.exists("summary.xlsx")) {
    summ <- openxlsx::read.xlsx("summary.xlsx", check.names = FALSE)
    summ$Transcription.Factor <- NULL
    write.xlsx(summ, "summary.xlsx", sheetName = "summary", colNames = TRUE)
  }
  
  i=i+1
  setwd("../../")
}
