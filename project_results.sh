#########################################################################################################
# Shell script: 本脚本的作用是整理项目分析结果文件，并且生成网页版报告
# Date: 2019/09/04
# Author: jingxinxing
# Version: v3
#########################################################################################################
#!/usr/bin/bash
date
## result
mkdir -p result
cd ./result

## 1.Project_information
mkdir -p 1.Project_information
cd ../;
cp '样品登记单.pdf' ./result/1.Project_information
cp '样品登记单.xlsx' ./result/1.Project_information
cp 样品编号标记对照表*.xlsx ./result/1.Project_information/样品编号标记对照表.xlsx
cp 鹿明蛋白*xlsx ./result/1.Project_information/鹿明蛋白组分析确认单.xlsx

## 2.Qualitative-Quantitative
cd ./result
mkdir -p 2.Qualitative-Quantitative
cd ../;

### iTRAQ_multi_mark
# if ll | grep 'iTRAQ results 1'
if find 'iTRAQ results 1'
then
	cp -r 'iTRAQ results 1' ./result/2.Qualitative-Quantitative
	cp -r 'iTRAQ results 2' ./result/2.Qualitative-Quantitative	
	cp -r 'iTRAQ results 3' ./result/2.Qualitative-Quantitative
	cp *.fasta ./result/2.Qualitative-Quantitative
else
	cp Peptide*.xlsx ./result/2.Qualitative-Quantitative ### single_mark
	cp Protein*.xlsx ./result/2.Qualitative-Quantitative
	cp *.fasta ./result/2.Qualitative-Quantitative
fi
### TMT_multi_mark	
if find 'TMT results 1'
then
	cp -r 'TMT results 1' ./result/2.Qualitative-Quantitative
	cp -r 'TMT results 2' ./result/2.Qualitative-Quantitative
	cp -r 'TMT results 3' ./result/2.Qualitative-Quantitative
	cp *.fasta ./result/2.Qualitative-Quantitative
fi

### Label_free
if find '数据矩阵.xlsx'
then
	cp '附件1  蛋白鉴定定量总表.xlsx' ./result/2.Qualitative-Quantitative/'Protein quantitation.xlsx'
	cp '附件2  肽段鉴定表.xlsx' ./result/2.Qualitative-Quantitative/'Peptide groups.xlsx'
	cp *.fasta ./result/2.Qualitative-Quantitative
fi

cd ./result/2.Qualitative-Quantitative/
### Statistics
mkdir -p Statistics
cd ../;cd ../;

### 1.Molecular_weight_distribution
if find histogram
then
	cp histogram/* ./result/2.Qualitative-Quantitative/Statistics
# else
#	mv ./result/2.Qualitative-Quantitative/'iTRAQ results 1'/*results_1_Molecular_weight_distribution.* ./result/2.Qualitative-Quantitative/Statistics/
#	mv ./result/2.Qualitative-Quantitative/'iTRAQ results 2'/*results_2_Molecular_weight_distribution.* ./result/2.Qualitative-Quantitative/Statistics/
#	mv ./result/2.Qualitative-Quantitative/'iTRAQ results 3'/*results_3_Molecular_weight_distribution.* ./result/2.Qualitative-Quantitative/Statisti
#if find 'TMT results 1'
#	mv ./result/2.Qualitative-Quantitative/'TMT results 1'/*results_1_Molecular_weight_distribution.* ./result/2.Qualitative-Quantitative/Statistics/
#	mv ./result/2.Qualitative-Quantitative/'TMT results 2'/*results_2_Molecular_weight_distribution.* ./result/2.Qualitative-Quantitative/Statistics/
#	mv ./result/2.Qualitative-Quantitative/'TMT results 3'/*results_3_Molecular_weight_distribution.* ./result/2.Qualitative-Quantitative/Statistics/	
fi

### 2.Peptide_number-proteins
# if find 2.Peptide_number-proteins*
# then
# 	cp 2.Peptide_number-proteins* ./result/2.Qualitative-Quantitative/Statistics
# else
# 	mv ./result/2.Qualitative-Quantitative/'iTRAQ results 1'/*results_1_Peptide_number-proteins.* ./result/2.Qualitative-Quantitative/Statistics
# 	mv ./result/2.Qualitative-Quantitative/'iTRAQ results 2'/*results_2_Peptide_number-proteins.* ./result/2.Qualitative-Quantitative/Statistics
# 	mv ./result/2.Qualitative-Quantitative/'iTRAQ results 3'/*results_3_Peptide_number-proteins.* ./result/2.Qualitative-Quantitative/Statistics
# # if ll | grep 'TMT results 1'
# 	mv ./result/2.Qualitative-Quantitative/'TMT results 1'/*results_1_Peptide_number-proteins.* ./result/2.Qualitative-Quantitative/Statistics
# 	mv ./result/2.Qualitative-Quantitative/'TMT results 2'/*results_2_Peptide_number-proteins.* ./result/2.Qualitative-Quantitative/Statistics
# 	mv ./result/2.Qualitative-Quantitative/'TMT results 3'/*results_3_Peptide_number-proteins.* ./result/2.Qualitative-Quantitative/Statistics
# fi

### 3.Peptide_coverage
if find pie
then
	cp pie/* ./result/2.Qualitative-Quantitative/Statistics
# else
# 	mv ./result/2.Qualitative-Quantitative/'iTRAQ results 1'/*results_1_Peptide_coverage_?D.* ./result/2.Qualitative-Quantitative/Statistics
# 	mv ./result/2.Qualitative-Quantitative/'iTRAQ results 2'/*results_2_Peptide_coverage_?D.* ./result/2.Qualitative-Quantitative/Statistics
# 	mv ./result/2.Qualitative-Quantitative/'iTRAQ results 3'/*results_3_Peptide_coverage_?D.* ./result/2.Qualitative-Quantitative/Statistics
# 
# # if ll | grep 'TMT results 1'
# 	mv ./result/2.Qualitative-Quantitative/'TMT results 1'/*results_1_Peptide_coverage_?D.* ./result/2.Qualitative-Quantitative/Statistics
# 	mv ./result/2.Qualitative-Quantitative/'TMT results 2'/*results_2_Peptide_coverage_?D.* ./result/2.Qualitative-Quantitative/Statistics
# 	mv ./result/2.Qualitative-Quantitative/'TMT results 3'/*results_3_Peptide_coverage_?D.* ./result/2.Qualitative-Quantitative/Statistics
fi

### PCA
if find PCA
then
	cp PCA/* ./result/2.Qualitative-Quantitative/Statistics
fi
	
## 3.Different_expressed_protein
cd ./result
mkdir -p 3.Different_expressed_protein
cd ../;
cp 差异蛋白筛选结果.xlsx ./result/3.Different_expressed_protein
cp foldchange_bar* ./result/3.Different_expressed_protein

### correlations
if find corrplot
then 
	cd ./result/3.Different_expressed_protein
	mkdir -p correlations
	cd ../;cd ../;
	cp corrplot/* ./result/3.Different_expressed_protein/correlations
fi

### heatmap
if find heatmap
then
	cd ./result/3.Different_expressed_protein
	mkdir -p heatmap
	cd ../;cd ../;
	cp ./heatmap/* ./result/3.Different_expressed_protein/heatmap
	cp 聚类热图数据.xlsx ./result/3.Different_expressed_protein/heatmap	
fi

### venn
if find venn
then
	cd ./result/3.Different_expressed_protein
	mkdir -p venn
	cd ../;cd ../;
	cp venn/* ./result/3.Different_expressed_protein/venn
fi

### volcano
if find volcano*
then
	cd ./result/3.Different_expressed_protein
	mkdir -p volcano
	cd ../;cd ../;
	cp ./volcano/* ./result/3.Different_expressed_protein/volcano
	cp volcano* ./result/3.Different_expressed_protein/volcano
fi
	
#cd ./result/3.Different_expressed_protein
#### correlations heatmap venn volcano
#mkdir -p correlations heatmap venn volcano
#cd ../;cd ../;
#cp ?.correlation* ./result/3.Different_expressed_protein/correlations
#cp ?.heatmap* ./result/3.Different_expressed_protein/heatmap
#cp 聚类热图数据.xlsx ./result/3.Different_expressed_protein/heatmap
#cp venn* ./result/3.Different_expressed_protein/venn
#cp ?.volcano* ./result/3.Different_expressed_protein/volcano

## 4.Enrichment-PPI_network
cd ./result;
mkdir -p 4.Enrichment-PPI_network/annotation
cd ../;

### gene_annotation.xls >> annotation.xls
if find 'gene_annotation.xls'
then
	cp gene_annotation.xls ./result/4.Enrichment-PPI_network/annotation/annotation.xls
fi

if find 'annotation.xlsx'
then
	cp annotation.xlsx ./result/4.Enrichment-PPI_network/annotation/annotation.xlsx
fi

### enrich
if find 'enrich'
then
	cp -r enrich ./result/4.Enrichment-PPI_network
	ls -F
	#### enrichment_go.xls
	cd ./result/4.Enrichment-PPI_network/enrich/GO_enrichment/
	rm enrichment_go.xls
	ls -RF
	#### convert .pdf files
	cp /public/hstore5/proteome/pipeline/script/project_result_system/ppi_go_png_convert.sh ./
	ls -d * | while read i;do cd ${i} && cp ../ppi_go_png_convert.sh ./ && bash ppi_go_png_convert.sh;rm ppi_go_png_convert.sh && cd ../;done
	ls -RF
	##### GO.level2*
	rm ./*/GO.level2*
	#### enrichment_kegg.xls
	cd ../KEGG_enrichment
	rm enrichment_kegg.xls
	ls -RF
	##### diff-KEGG-Classification*
	rm ./*/diff-KEGG-Classification*
	cd ../../../../;ls
fi

### ppi
if find 'ppi'
then
	cp -r ppi ./result/4.Enrichment-PPI_network
	cp /public/hstore5/proteome/pipeline/report/templates/Cytoscape绘制PPI网络图.pdf ./result/4.Enrichment-PPI_network/ppi
	rm ./result/4.Enrichment-PPI_network/ppi/*detail.xls
	rm ./result/4.Enrichment-PPI_network/ppi/*res.xls
	ls
fi

## 5.Supplementary
cd ./result;ls -F
mkdir -p 5.Supplementary
# cp /public/hstore5/proteome/pipeline/report/templates/蛋白组英文报告-鹿明生物.pdf ./5.Supplementary/蛋白组英文报告-鹿明生物.pdf
cp /public/hstore5/proteome/pipeline/report/templates/'蛋白组实验常用仪器型号+试剂货号.xls' ./5.Supplementary/
cp /public/hstore5/proteome/pipeline/report/templates/'蛋白组英文报告-鹿明生物（2019）.pdf' ./5.Supplementary/
find ./ -maxdepth 10 -type d | while read dir; do count=$(find "$dir" -type f | wc -l); echo "$dir : $count"; done
cd ../;ls

## report
mkdir -p report
cd ./report
cp -r /public/hstore5/proteome/pipeline/report/templates/iTRAQ/* ./
cd ./templates
cp -r ../../result ./
cp -r ../../figs ./
cp -r ../../pic ./
cp ../../report.yaml ./
cp ../../init.txt ./init/ ## 用项目的表头文件init.txt代替模板里的init.txt文件
python ../jinja2_report_link.py -c report.yaml -d ./ ## 生成报告的关键语句
sleep 2
ls
sleep 1
find ./ -maxdepth 10 -type d | while read dir; do count=$(find "$dir" -type f | wc -l); echo "$dir : $count"; done
if find report.html
then
	sed -i 's/表1.1.项目概况//g' report.html
	sed -i 's/<p class="img-mark text-center small">图1.1 <\/p>//g' report.html
	sed -i 's/<p class="img-mark text-center small">图1.2 <\/p>//g' report.html
	sed -i 's/<p class="img-mark text-center small">图1.3 <\/p>//g' report.html
	sed -i 's/本分析使用的 STRING 库是homo sapiens物种库//g' report.html
	echo "The project analysis results document has been sorted out"
	tar -zcvf report.tar.gz result src report.html
	mv ./report.tar.gz ../../;ls
else
	echo "Your project report was not generated, please check the preparation file"
fi
