#########################################################################################################
### <Shell script>: 本脚本的作用是整理项目分析结果文件，并且生成result目录中的子目录和对应的文件
### <Date>: 2019/10/09
### <Author>: jingxinxing
### <Version>: v3.1
### <News>:
### <Usage>:
### 
#########################################################################################################
#!/usr/bin/bash
#
################################
exec 0> result_stdin.log
exec 1> result_stdout.log
exec 2> result_stderr.log
################################
#
## 显示时间 
date
project_pwd=`pwd`
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
	cp -r 'iTRAQ results 1' ../5.result/2.Qualitative-Quantitative # 原始数据
	cp -r 'iTRAQ results 2' ../5.result/2.Qualitative-Quantitative	
	cp -r 'iTRAQ results 3' ../5.result/2.Qualitative-Quantitative
	cp *fasta ../5.result/2.Qualitative-Quantitative # 搜库fasta序列
else ### 5.2对于iTRAQ单标的项目，single_mark ###
	cp Peptide*xlsx ../5.result/2.Qualitative-Quantitative # 蛋白表
	cp Protein*xlsx ../5.result/2.Qualitative-Quantitative # 肽段表
	cp *fasta ../5.result/2.Qualitative-Quantitative # 搜库fasta序列
fi

cd ../5.result/2.Qualitative-Quantitative # 此时的工作路径在./5.result/2.Qualitative-Quantitative中
pwd # 查看当前的路径
ls -RF # 查看当前路径下的所有子目录和文件
cd ../../rawdata # 继续切换到rawdata工作目录中

### 5.3 对于TMT多标的项目，TMT_multi_mark ###
if find 'TMT results 1'
then
	cp -r 'TMT results 1' ../5.result/2.Qualitative-Quantitative # 原始数据
	cp -r 'TMT results 2' ../5.result/2.Qualitative-Quantitative
	cp -r 'TMT results 3' ../5.result/2.Qualitative-Quantitative
	cp *fasta ../5.result/2.Qualitative-Quantitative # 搜库fasta序列
fi

cd ../5.result/2.Qualitative-Quantitative # 此时的工作路径在./5.result/2.Qualitative-Quantitative中
pwd # 查看当前的路径
ls -RF # 查看当前路径下的所有子目录和文件
cd ../../rawdata # 继续切换到rawdata工作目录中

### 5.4 对于Label_free项目 ###
if [ -e 数据矩阵.xlsx ]
then
	echo "这是Label_free项目"
	cp '附件1  蛋白鉴定定量总表.xlsx' ../5.result/2.Qualitative-Quantitative/'Protein quantitation.xlsx' # 蛋白表
	cp '附件2  肽段鉴定表.xlsx' ../5.result/2.Qualitative-Quantitative/'Peptide groups.xlsx' # 肽段表
	cp *fasta ../5.result/2.Qualitative-Quantitative # fasta序列
else
	echo "这不是Label_free项目"
fi
#
cd ../5.result/2.Qualitative-Quantitative # 此时的工作路径在./5.result/2.Qualitative-Quantitative中
pwd # 查看当前的路径
ls -RF # 查看当前路径下的所有子目录和文件
cd ../../rawdata # 继续切换到rawdata工作目录中
#
### 5.5 对于DIA项目 ###
if [ -e DDA_library.xlsx ]
then
	echo "这是DIA项目"
	cp DDA_library.xlsx ../5.result/2.Qualitative-Quantitative/ # DDA文库
	cp 数据质控文件.docx ../5.result/2.Qualitative-Quantitative/ # 数据质控文件
	cp *fasta ../5.result/2.Qualitative-Quantitative # fasta序列
else
	echo "这不是DIA项目"
fi
#
### 5.6对于磷酸化phospho项目 ###
if [ -e proteinGroups.txt ]
then
	echo "这是磷酸化项目"
	cp ../1.dep/proteinGroups.xlsx ../5.result/2.Qualitative-Quantitative/ # proteinGroups.xlsx
	cp ../1.dep/modificationSpecificPeptides.xlsx ../5.result/2.Qualitative-Quantitative/ # modificationSpecificPeptides.xlsx
	cp ../1.dep/'Phospho (STY)Sites.xlsx' ../5.result/2.Qualitative-Quantitative/ # Phospho (STY)Sites.xlsx
	cp *fasta ../5.result/2.Qualitative-Quantitative # fasta序列
else
	echo "这不是磷酸化项目"
fi
#
cd ../5.result/2.Qualitative-Quantitative # 此时的工作路径在./5.result/2.Qualitative-Quantitative中
pwd # 查看当前的路径
ls -RF # 查看当前路径下的所有子目录和文件
#

## 6.新建./5.result/2.Qualitative-Quantitative内的子目录Statistics
### 6.1 Statistics ###
mkdir -p Statistics # 此时工作目录在./5.result/2.Qualitative-Quantitative内

### 6.2 histogram ###
#### 1.Molecular_weight_distribution
#### 2.Peptide_number-proteins

# 
if [ -e ../../1.dep/histogram ]
then # 1.dep/histogram目录存在
	echo "1.dep/histogram目录存在"
	cp ../../1.dep/histogram/* ./Statistics
fi
#

pwd;ls -RF Statistics # 查看Statistics目录文件

### 6.3 pie ###
#### Peptide_coverage
#
if [ -e ../../1.dep/pie ]
then # 1.dep/pie目录存在
	echo "1.dep/pie目录存在"
	cp ../../1.dep/pie/* ./Statistics
fi
#

### 6.4 PCA ###

#
if [ -e PCA ]
then # 1.dep/PCA目录存在
	echo "1.dep/PCA目录存在"
	cp ../../1.dep/PCA/* ./Statistics
fi
#

### 6.5 磷酸化项目中的分析结果需要放在Statistics中的
#
if [ -e ../../1.dep/Statistics ]
then # 1.dep/Statistics目录存在
	cp ../../1.dep/Statistics/* ./Statistics
	cp ../../1.dep/PCA/* ./Statistics
	cp ../../1.dep/Motif/* ./Statistics
fi
#
pwd # 查看路径
ls -RF # 查看文件
cd ../;ls # 切换工作目录到5.result中

## 7.Different_expressed_protein或Different_expressed_sites
cd ../1.dep # 切换工作目录到1.dep中
# 增加一个判断，如果有Motif目录，说明是磷酸化项目，目录5.result中的第三个子目录应该是3.Different_expression_sites，否则是3.Different_expressed_protein
if [ -e Motif ]
then
	echo
	echo "这是磷酸化项目"
	cd ../5.result # 切换到目录5.result中
	mkdir -p 3.Different_expressed_sites # 新建子目录3.Different_expressed_sites
else # 1.dep目录中的子目录Motif不存在，说明这不是磷酸化项目
	echo
	cd ../5.result # 切换到目录5.result中
	mkdir -p 3.Different_expressed_protein
fi # 此时工作目录在5.result中

### 7.1 复制iTRAQ/TMT/Label_free/DIA项目的"差异蛋白筛选结果.xlsx"文件到5.result/3.Different_expressed_protein中 ###
if [ -e ../1.dep/差异蛋白筛选结果.xlsx ]
then
	echo
	echo "这不是磷酸化项目"
	cp ../1.dep/差异蛋白筛选结果.xlsx ./3.Different_expressed_protein # 差异蛋白筛选结果.xlsx
	cp ../1.dep/foldchange_bar* ./3.Different_expressed_protein # foldchange_bars.pdf和foldchange_bars.png
	pwd;ls -RF ./3.Different_expressed_protein 
else
	echo
	echo "这是磷酸化项目"
	cp ../1.dep/差异位点筛选结果.xlsx 3.Different_expressed_sites # 差异位点筛选结果.xlsx
	cp ../1.dep/foldchange_bar* ./3.Different_expressed_sites # foldchange_bars.pdf和foldchange_bars.png
	pwd;ls -RF ./3.Different_expressed_sites
fi
#

cd ../1.dep;ls # 查看1.dep目录中的目录和文件

### 7.2 correlations ###
#
if [ -e corrplot ]
then # 磷酸化项目没有蛋白相关性热图
	cd ../5.result/3.Different_expressed_protein
	mkdir -p correlations
	cd ../../1.dep;
	cp ./corrplot/* ../5.result/3.Different_expressed_protein/correlations
fi
#

### 7.3 heatmap ###
#
if [ -e heatmap ]
then # 磷酸化项目有热图，所以还需要判断这个热图是哪个项目类型的
	#
	if [ -e Motif ]
	then # Motif在
		echo "磷酸化项目"
		cp -r heatmap ../5.result/3.Different_expressed_sites
		cp 聚类热图数据.xlsx ../5.result/3.Different_expressed_sites/heatmap
	else # Motif不在
		echo "不是磷酸化项目"
		cp -r heatmap ../5.result/3.Different_expressed_protein
		cp 聚类热图数据.xlsx ../5.result/3.Different_expressed_protein/heatmap
	fi
	#
fi
#

### 7.4 venn ###
#
if [ -e venn ]
then # 磷酸化项目没有有韦恩图
	cd ../5.result/3.Different_expressed_protein
	mkdir -p venn
	cd ../../1.dep;
	cp ./venn/* ../5.result/3.Different_expressed_protein/venn
fi
#

### 7.5 volcano ###
#
if [ -e volcano ]
then # 如果火山图存在于1.dep目录汇中，因为磷酸化项目有火山图，所以还需要判断这个火山图是哪种项目类型的
	#
	if [ -e Motif ]
	then
		echo "这是磷酸化项目"
		cp -r volcano ../5.result/3.Different_expressed_sites
	else
		echo "这不是磷酸化项目"
		cp -r volcano ../5.result/3.Different_expressed_protein
	fi
	#
fi
#

### 7.6 磷酸化项目特有的Abundance_distribution_map ###
#
if [ -e Abundance_distribution_map ]
then # 目录1.dep中有Abundance_distribution_map
	cp -r Abundance_distribution_map ../5.result/3.Different_expressed_sites/
	cp 差异位点筛选结果.xlsx ../5.result/3.Different_expressed_sites/ # 7.7 差异位点筛选结果.xlsx
fi
#

### 7.7 磷酸化项目特有的Motif ###
#
if [ -e Motif ]
then # 目录1.dep中有Motif
	cp -r Motif ../5.result/3.Different_expressed_sites/	
fi
#

#
pwd # 此时，路径在./1.dep
cd ../3.enrichment # 切换工作目录，此时目录在./3.enrichment内
pwd;ls -F
#

# ## 8.注释文件annotation.xlsx
# cd ../5.result
# mkdir -p 4.Enrichment-PPI_network/annotation
# cd ../4.annotation
# if find 'annotation.xlsx'
# then
# 	cp annotation.xlsx ../5.result/4.Enrichment-PPI_network/annotation/
# fi

cd ${project_pwd}/3.enrichment # 切换工作目录到./项目目录/4.enrichment

## 8.Enrichment-PPI_network
### 8.1 enrich
#
if [ -d enrich ]
then # enrich富集分析结果存在
	#
	# cd ../5.result/4.Enrichment-PPI_network/;
	# mkdir enrich;
	# cd ../../3.enrichment;
	#
	cp -r enrich ../5.result/4.Enrichment-PPI_network/
	# cp -r ./enrich/* ../5.result/4.Enrichment-PPI_network/enrich/
	#### 20191009 ####
	#
	if [ -d ../5.result/4.Enrichment-PPI_network/enrich ]
	then
		echo "OK"
		rm -rf ../5.result/4.Enrichment-PPI_network/GO_enrichment
		rm -rf ../5.result/4.Enrichment-PPI_network/KEGG_enrichment
		rm -rf ../5.result/4.Enrichment-PPI_network/KEGG_map
	else
		echo "NO enrich? "
		mkdir -p ../5.result/4.Enrichment-PPI_network/enrich
		mv ../5.result/4.Enrichment-PPI_network/GO_enrichment ../5.result/4.Enrichment-PPI_network/enrich
		mv ../5.result/4.Enrichment-PPI_network/KEGG_enrichment ../5.result/4.Enrichment-PPI_network/enrich
		mv ../5.result/4.Enrichment-PPI_network/KEGG_map ../5.result/4.Enrichment-PPI_network/enrich
	fi
	#
	#### enrichment_go.xls
	rm ../5.result/4.Enrichment-PPI_network/enrich/GO_enrichment/enrichment_go.xls
	# ls -RF ../5.result/4.Enrichment-PPI_network/enrich/GO_enrichment/
	#### convert .pdf files
	cd ../5.result/4.Enrichment-PPI_network/enrich/GO_enrichment/ # 切换工作目录
	# cp /public/hstore5/proteome/pipeline/script/project_result_system/ppi_go_png_convert.sh ./
	# ls -d * | while read i;do cd ${i} && cp ../ppi_go_png_convert.sh ./ && bash ppi_go_png_convert.sh;rm ppi_go_png_convert.sh && cd ../;done
        ## pdf文件格式转换
        ls -d * | while read i;do cd ${i} && ls -1 *.pdf | xargs -n 1 bash -c 'convert "$0" "${0%.pdf}.png"' && cd ../;done 
	pwd
	##### GO.level2*
	rm ./*/GO.level2* # 此时工作路径在./5.result/4.Enrichment-PPI_network/enrich/GO_enrichment内

	# 对于磷酸化项目需要删除的文件 #
	if [ -e ../../../../1.dep/Motif ]
	then
		echo
		echo "这是磷酸化项目"
		rm ./*/*Up* # 删除GO_enrichment的比较组中的Up文件
		rm ./*/*Down* # 删除GO_enrichment的比较组中的Down文件
		pwd;ls -RF ./
	else
		echo "这不是磷酸化项目"
	fi
	
	#### enrichment_kegg.xls
	cd ../KEGG_enrichment
	rm enrichment_kegg.xls # 此时工作路径在./5.result/4.Enrichment-PPI_network/enrich/KEGG_enrichment内
	pwd
	##### diff-KEGG-Classification*
	rm ./*/diff-KEGG-Classification*
	
	# 如果是磷酸化项目则需要删除文件名中有关键词Up和Down的文件
	if [ -e ../../../../1.dep/Motif ]
	then
		echo
		echo "这是磷酸化项目"
		rm ./*/*Up*
		rm ./*/*Down*
		pwd;ls -RF ./
	else
		echo "这不是磷酸化项目"
	fi
	
	# cd ../;ls -RF *
	pwd
	cd ../../../../;pwd;ls # 此时工作路径在项目路径内
fi
#

cd ${project_pwd}/3.enrichment # 此时路径在./项目路径/3.enrichment/内
pwd

### 8.2 ppi ###
#
if [ -d ppi ]
then # ppi存在与./项目路径/3.enrichment/内
	cp -r ppi ../5.result/4.Enrichment-PPI_network
	cp /public/hstore5/proteome/pipeline/report/templates/Cytoscape绘制PPI网络图.pdf ../5.result/4.Enrichment-PPI_network/ppi
	rm ../5.result/4.Enrichment-PPI_network/ppi/*detail.xls
	rm ../5.result/4.Enrichment-PPI_network/ppi/*res.xls
fi
#

### 8.3.注释文件annotation.xlsx ###
cd ../5.result
mkdir -p 4.Enrichment-PPI_network/annotation
cd ../4.annotation # 此时工作目录在./项目路径/4.annotation/内
pwd;ls

#
if [ -f annotation.xlsx ]
then
	cp annotation.xlsx ../5.result/4.Enrichment-PPI_network/annotation/
else
	echo
	echo "Can not find file annotation.xlsx, please check, and according to 2.background of files to generate the annotation.xlsx"

fi
#

## 9.Supplementary
cd ../5.result;ls -F ./
mkdir -p 5.Supplementary
cp /public/hstore5/proteome/pipeline/report/templates/'蛋白组实验常用仪器型号+试剂货号.xls' ./5.Supplementary/
cp /public/hstore5/proteome/pipeline/report/templates/'蛋白组英文报告-鹿明生物（2019）.pdf' ./5.Supplementary/
#
find ./ -maxdepth 10 -type d | while read dir; do count=$(find "$dir" -type f | wc -l); echo "$dir : $count"; done
#
pwd
ls -RF ./
cd ../;ls # 此时工作目录在项目路径内
pwd
echo
echo "Your project result was generated, please check the directory # 5.result #"
echo
echo "Next, you can generate the project report"
#
#
#
########################################################################################################
### <Shell script>: 本脚本的作用是根据项目分析结果文件，并且生成项目report
### <Date>: 2019/10/09
### <Author>: jingxinxing
### <Version>: v3.1
### <News>:
### <Usage>:
###
########################################################################################################
#!/usr/bin/bash
#
########################################
exec 0> report_stdin.log
# exec 1> report_stdout.log
exec 2> report_stderr.log
########################################
date
## 1.report
cd ./6.report
### 1.1 标记项目iTRAQ/TMT报告模板
cp -r /public/hstore5/proteome/pipeline/report/templates/iTRAQ/* ./
cd ./templates
mkdir -p result
cp -r ../../5.result/* ./result/
# mv 5.result result # 将目录名称改为result
cp -r ../../rawdata/figs ./
cp ../../1.dep/5.differentially_protein_number.txt ./figs
cp -r ../../rawdata/pic ./
cp ../../rawdata/report.yaml ./
cp ../../rawdata/init.txt ./init/ ## 用项目的表头文件init.txt代替模板里的init.txt文件
python ../jinja2_report_link.py -c report.yaml -d ./ ## 生成报告的关键语句
sleep 2
pwd;
sleep 1
# find ./ -maxdepth 10 -type d | while read dir; do count=$(find "$dir" -type f | wc -l); echo "$dir : $count"; done
if find report.html
then
# 	var=$(cat ratio.txt);
# 	echo $var > var
# 	# cat var
# 	foldchange=`cat var | awk '{print $3}'`
# 	pvalue=`cat var | awk '{print $4}'`
# 
	echo "Congratulations on the successful generation of the Project Report"
	sed -i 's/表1.1.项目概况//g' report.html
	sed -i 's/<p class="img-mark text-center small">图1.1 <\/p>//g' report.html
	sed -i 's/<p class="img-mark text-center small">图1.2 <\/p>//g' report.html
	sed -i 's/<p class="img-mark text-center small">图1.3 <\/p>//g' report.html
	sed -i 's/本分析使用的 STRING 库是homo sapiens物种库//g' report.html
	# sed -i 's/Foldchange≥?/Foldchange≥${foldchange}/g' report.html
	# if $pvalue != 0
	# then
	# 	sed -i 's/p-value<?/p-value<${pvalue}/g' report.html
	# else
	# 	echo "no pvalue"
	# fi
	echo "The project analysis results document has been sorted out"
	tar -zcvf report.tar.gz result src report.html 1> report_stdout.log
	mv ./report.tar.gz ../../;
	cd ../../;
	# pwd > project_path_info.txt;
	# project_name=`cat project_path_info.txt | awk -F \/ '{print $9}'`;
	var=`pwd`
	project_name=`echo ${var##*/}`
	project_date=`date +"%F"`
	mv report.tar.gz "${project_name}_${project_date}.tar.gz"
	# rm project_path_info.txt
else
	echo "Your project report was not generated, please check the preparation files"
fi
date
