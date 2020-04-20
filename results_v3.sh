#########################################################################################################
### <Shell script>: 本脚本的作用是整理项目分析结果文件，并且生成result目录中的子目录和对应的文件
### <Date>: 2019/09/09
### <Author>: jingxinxing
### <Version>: v3
### <News>:
### <Usage>:
### 
#########################################################################################################
#!/usr/bin/bash
## 显示时间 
date

## 1.进入目录：5.result 
cd ./5.result

## 2.新建子目录：1.Project_information
### 1.Project_information ###
mkdir -p 1.Project_information

## 3.复制项目信息文件到5.result/1.Project_information目录中，此时还在5.result目录，所以进行以下操作
cp ../rawdata/'样品登记单.pdf' ./1.Project_information
cp ../rawdata/'样品登记单.xlsx' ./1.Project_information
cp ../rawdata/样品编号标记对照表*xlsx ./1.Project_information/样品编号标记对照表.xlsx
cp ../rawdata/鹿明蛋白*xlsx ./1.Project_information/鹿明蛋白组分析确认单.xlsx

pwd # 查看当前的路径
ls -RF # 查看当前路径下的所有子目录和文件

## 4.新建子目录：2.Qualitative-Quantitative，依然在5.result目录中
mkdir -p 2.Qualitative-Quantitative

## 5.根据项目类型进行不同的文件整理
### 5.1 对于iTRAQ多标的项目，iTRAQ_multi_mark ###
cd ../rawdata # 切换工作目录到目录rawdata中
if find 'iTRAQ results 1'
then
	cp -r 'iTRAQ results 1' ../5.result/2.Qualitative-Quantitative
	cp -r 'iTRAQ results 2' ../5.result/2.Qualitative-Quantitative	
	cp -r 'iTRAQ results 3' ../5.result/2.Qualitative-Quantitative
	cp *fasta ../5.result/2.Qualitative-Quantitative
else
	cp Peptide*xlsx ../5.result/2.Qualitative-Quantitative ### 5.2对于iTRAQ单标的项目，single_mark ###
	cp Protein*xlsx ../5.result/2.Qualitative-Quantitative
	cp *fasta ../5.result/2.Qualitative-Quantitative
fi

cd ../5.result/2.Qualitative-Quantitative # 此时的工作路径在./5.result/2.Qualitative-Quantitative中
pwd # 查看当前的路径
ls -RF # 查看当前路径下的所有子目录和文件
cd ../../rawdata # 继续切换到rawdata工作目录中

### 5.3 对于TMT多标的项目，TMT_multi_mark ###
if find 'TMT results 1'
then
	cp -r 'TMT results 1' ../5.result/2.Qualitative-Quantitative
	cp -r 'TMT results 2' ../5.result/2.Qualitative-Quantitative
	cp -r 'TMT results 3' ../5.result/2.Qualitative-Quantitative
	cp *fasta ../5.result/2.Qualitative-Quantitative
fi

cd ../5.result/2.Qualitative-Quantitative # 此时的工作路径在./5.result/2.Qualitative-Quantitative中
pwd # 查看当前的路径
ls -RF # 查看当前路径下的所有子目录和文件
cd ../../rawdata # 继续切换到rawdata工作目录中

### 5.4 对于Label_free项目 ###
if find '数据矩阵.xlsx'
then
	cp '附件1  蛋白鉴定定量总表.xlsx' ../5.result/2.Qualitative-Quantitative/'Protein quantitation.xlsx'
	cp '附件2  肽段鉴定表.xlsx' ../5.result/2.Qualitative-Quantitative/'Peptide groups.xlsx'
	cp *fasta ../5.result/2.Qualitative-Quantitative
fi

cd ../5.result/2.Qualitative-Quantitative # 此时的工作路径在./5.result/2.Qualitative-Quantitative中
pwd # 查看当前的路径
ls -RF # 查看当前路径下的所有子目录和文件
cd ../../rawdata # 继续切换到rawdata工作目录中

### 5.5 对于DIA项目 ###
if find 'DDA_library.xlsx'
then
	cp DDA_library.xlsx ../5.result/2.Qualitative-Quantitative/
	cp 数据质控文件.docx ../5.result/2.Qualitative-Quantitative/
fi

cd ../5.result/2.Qualitative-Quantitative # 此时的工作路径在./5.result/2.Qualitative-Quantitative中
pwd # 查看当前的路径
ls -RF # 查看当前路径下的所有子目录和文件

## 6.新建./5.result/2.Qualitative-Quantitative内的子目录Statistics
### 6.1 Statistics ###
mkdir -p Statistics # 此时工作目录在./5.result/2.Qualitative-Quantitative内
cd ../../1.dep # 此时在1.dep内

### 6.2 histogram ###
#### 1.Molecular_weight_distribution
#### 2.Peptide_number-proteins
 
if find histogram
then
	cp histogram/* ../5.result/2.Qualitative-Quantitative/Statistics
fi

cd ../5.result/2.Qualitative-Quantitative/
pwd
ls -RF Statistics # 查看Statistics目录文件
cd ../../1.dep # 切换到1.dep目录内

### 6.3 pie ###
#### Peptide_coverage
if find pie
then
	cp pie/* ../5.result/2.Qualitative-Quantitative/Statistics
fi

### 6.4 PCA ###
if find PCA
then
	cp PCA/* ../5.result/2.Qualitative-Quantitative/Statistics
fi

### 6.5 磷酸化项目中的分析结果需要放在Statistics中的
if find Statistics
then
	cp Statistics/* ../5.result/2.Qualitative-Quantitative/Statistics
	cp PCA/* ../5.result/2.Qualitative-Quantitative/Statistics
	cp Motif/* ../5.result/2.Qualitative-Quantitative/Statistics
fi

cd ../5.result/2.Qualitative-Quantitative/Statistics # 切换工作目录到./5.result/2.Qualitative-Quantitative/Statistics
pwd # 查看路径
ls -RF # 查看文件
cd ../../;ls # 切换工作目录到5.result中

## 7.Different_expressed_protein
mkdir -p 3.Different_expressed_protein

### 7.1 复制iTRAQ/TMT/Label_free/DIA项目的"差异蛋白筛选结果.xlsx"文件到5.result/3.Different_expressed_protein中 ###
cp ../1.dep/差异蛋白筛选结果.xlsx ./3.Different_expressed_protein
cp ../1.dep/foldchange_bar* ./3.Different_expressed_protein
ls -RF 3.Different_expressed_protein # 查看3.Different_expressed_protein目录中的文件
cd ../1.dep;ls # 查看1.dep目录中的目录和文件

### 7.2 correlations ###
if find corrplot
then
	cd ../5.result/3.Different_expressed_protein
	mkdir -p correlations
	cd ../../1.dep;
	cp ./corrplot/* ../5.result/3.Different_expressed_protein/correlations
fi

### 7.3 heatmap ###
if find heatmap
then
	cd ../5.result/3.Different_expressed_protein/
	mkdir -p heatmap
	cd ../../1.dep;
	cp ./heatmap/* ../5.result/3.Different_expressed_protein/heatmap
	cp 聚类热图数据.xlsx ../5.result/3.Different_expressed_protein/heatmap
fi

### 7.4 venn ###
if find venn
then
	cd ../5.result/3.Different_expressed_protein
	mkdir -p venn
	cd ../../1.dep;
	cp ./venn/* ../5.result/3.Different_expressed_protein/venn
fi

### 7.5 volcano ###
if find volcano
then
	cd ../5.result/3.Different_expressed_protein
	mkdir -p volcano
	cd ../../1.dep;
	cp ./volcano/* ../5.result/3.Different_expressed_protein/volcano
fi

### 7.6 磷酸化项目特有的Abundance_distribution_map ###
if find Abundance_distribution_map
then
	cp -r Abundance_distribution_map ../5.result/3.Different_expressed_protein/
	cp 差异位点筛选结果.xlsx ../5.result/3.Different_expressed_protein/ # 7.7 差异位点筛选结果.xlsx
fi

pwd # 此时，路径在./1.dep
cd ../3.enrichment # 切换工作目录，此时目录在./3.enrichment内
ls -F

# ## 8.注释文件annotation.xlsx
# cd ../5.result
# mkdir -p 4.Enrichment-PPI_network/annotation
# cd ../4.annotation
# if find 'annotation.xlsx'
# then
# 	cp annotation.xlsx ../5.result/4.Enrichment-PPI_network/annotation/
# fi

## 8.Enrichment-PPI_network
### 8.1 enrich
if find 'enrich'
then
	cp -r ./enrich ../5.result/4.Enrichment-PPI_network
	ls -RF enrich
	#### enrichment_go.xls
	rm ../5.result/4.Enrichment-PPI_network/enrich/GO_enrichment/enrichment_go.xls
	# ls -RF ../5.result/4.Enrichment-PPI_network/enrich/GO_enrichment/
	#### convert .pdf files
	cd ../5.result/4.Enrichment-PPI_network/enrich/GO_enrichment/
	# cp /public/hstore5/proteome/pipeline/script/project_result_system/ppi_go_png_convert.sh ./
	# ls -d * | while read i;do cd ${i} && cp ../ppi_go_png_convert.sh ./ && bash ppi_go_png_convert.sh;rm ppi_go_png_convert.sh && cd ../;done
	## pdf文件格式转换
        ls -d * | while read i;do cd ${i} && ls -1 *.pdf | xargs -n 1 bash -c 'convert "$0" "${0%.pdf}.png"' && cd ../;done
	pwd
	# ls -F *
	##### GO.level2*
	rm ./*/GO.level2* # 此时工作路径在./5.result/4.Enrichment-PPI_network/enrich/GO_enrichment内
	#### enrichment_kegg.xls
	cd ../KEGG_enrichment
	rm enrichment_kegg.xls # 此时工作路径在./5.result/4.Enrichment-PPI_network/enrich/KEGG_enrichment内
	pwd
	# ls -RF
	##### diff-KEGG-Classification*
	rm ./*/diff-KEGG-Classification*
	# cd ../;ls -RF *
	pwd
	cd ../../../../;pwd;ls # 此时工作路径在项目路径内
fi

cd ./3.enrichment # 此时路径在./项目路径/3.enrichment/内
pwd
# ls -RF ppi

### 8.2 ppi ###
if find 'ppi'
then
	cp -r ppi ../5.result/4.Enrichment-PPI_network
	cp /public/hstore5/proteome/pipeline/report/templates/Cytoscape绘制PPI网络图.pdf ../5.result/4.Enrichment-PPI_network/ppi
	rm ../5.result/4.Enrichment-PPI_network/ppi/*detail.xls
	rm ../5.result/4.Enrichment-PPI_network/ppi/*res.xls
	# ls -RF ../5.result/4.Enrichment-PPI_network/ppi/
fi

cd ..;ls # 此时路径在项目路径内
pwd

### 8.3.注释文件annotation.xlsx ###
cd ./5.result
mkdir -p 4.Enrichment-PPI_network/annotation
cd ../4.annotation
if find 'annotation.xlsx'
then
	cp annotation.xlsx ../5.result/4.Enrichment-PPI_network/annotation/
else
	echo "Can not find file annotation.xlsx, please according to 2.background of files to generate the annotation.xlsx"
fi

## 9.Supplementary
cd ../5.result;ls -F *
mkdir -p 5.Supplementary
cp /public/hstore5/proteome/pipeline/report/templates/'蛋白组实验常用仪器型号+试剂货号.xls' ./5.Supplementary/
cp /public/hstore5/proteome/pipeline/report/templates/'蛋白组英文报告-鹿明生物（2019）.pdf' ./5.Supplementary/
find ./ -maxdepth 10 -type d | while read dir; do count=$(find "$dir" -type f | wc -l); echo "$dir : $count"; done
pwd
ls -RF *
cd ../;ls # 此时工作目录在项目路径内
pwd

echo "Your project result was generated, please check the directory # 5.result #"
echo "Next, you can generate the project report"
date
