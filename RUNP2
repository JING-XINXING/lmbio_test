#!/bin/bash
########################################################################################################
# Pipeline2: 蛋白分析流程中部，涉及背景文件生成、内容整理和富集分析部分，简称P2
# Version: v2.8.0
# Date: 2020/04/14
# New: 
# Usage: RUNP2
########################################################################################################
#
date
########################################################################################################
## 第一部分：背景文件
########################################################################################################
# 华为云数据库没有现成的物种背景文件，需要脚本自动下载并处理时，需要传下面5个参数 #
## Taxonomy ID
# 参数1
species="mus_musculus"
# 参数2
taxid="10090"
# 参数3
search_library_seq="uniprot-proteome_UP000000589-Mus_musculus.fasta"
# 参数4，如果是动物就填写：Animal；如果是植物就填写：Plant；如果是微生物就填写：Micro
king="Animal"
# species_reviewed_protein_seq="uniprot_sus_scrofa_reviewed.fasta"
# 参数5
uniprot_species_reviewed_pseq_website="https://www.uniprot.org/uniprot/?query=*&format=fasta&force=true&sort=score&fil=reviewed:yes%20AND%20organism:%22Mus%20musculus%20(Mouse)%20[10090]%22%20AND%20proteome:up000000589&compress=yes"
# kegg_species_name="ssc"
##
# 后面实现脚本自动化获得参数 #
##
###########################
# KEGG background files #
# GO background files #
# P2P background files #
###########################
## 1.KEGG Abbreviation of species name, for example kegg_species_name="hsa"
pwd=`pwd`
#pwd2=`echo ${pwd#*-}`
kegg_species_name=`echo ${pwd##*-}`
#
cd /public/hstore5/proteome/database/background/ # 切换工作路径  
######################################################################################################################
######################################################################################################################

# if ls -lht | grep ${kegg_species_name}
if [ -d $kegg_species_name ]
then # $kegg_species_name is exist in /public/hstore5/proteome/database/background
	cd ./$kegg_species_name
	echo
	echo "$kegg_species_name background is exist"
	ls -RF ./
	#
	if [ -d uniprot ]
	then # has uniprot class
		cd ./uniprot # 此时工作路径在/public/hstore5/proteome/database/background/$kegg_species_name/uniprot内
		echo "$kegg_species_name has uniprot class"
		# kegg
		if [ -f kegg_gene.backgroud.txt ]
		then # kegg_gene.backgroud.txt is exist
			echo "kegg_gene.backgroud.txt is exist"
			cp kegg_gene.backgroud.txt ${pwd}/2.background
			sed -i 's/"/ /g' ${pwd}/2.background/kegg_gene.backgroud.txt	
			cp anno-kegg_gene.backgroud.txt ${pwd}/2.background
			sed -i 's/"/ /g' ${pwd}/2.background/anno-kegg_gene.backgroud.txt
		else # kegg_gene.backgroud.txt is not exist
			echo "kegg_gene.backgroud.txt is not exist"
			cp kegg_gene.backgroud.xls ${pwd}/2.background
			sed -i 's/"/ /g' ${pwd}/2.background/kegg_gene.backgroud.xls
			cp anno-kegg_gene.backgroud.xls ${pwd}/2.background
			sed -i 's/"/ /g' ${pwd}/2.background/anno-kegg_gene.backgroud.xls
		fi
		# go
		if [ -f gene_go.backgroud.txt ]
		then # gene_go.backgroud.txt is exist
			echo "gene_go.backgroud.txt is exist"
			cp gene_go.backgroud.txt ${pwd}/2.background
		else # gene_go.backgroud.txt is not exist
			echo "gene_go.backgroud.txt is not exist"
			cp gene_go.backgroud.xls ${pwd}/2.background
		fi
		# p2p
		if [ -f protein2protein_network.xls ]
		then # protein2protein_network.xls is exist
			echo "protein2protein_network.xls is exist"
			cp protein2protein_network.xls ${pwd}/2.background
		else # protein2protein_network.xls is not exist
			echo "protein2protein_network.xls is not exist"
		fi
		# pre1.txt
		if [ -f pre1.txt ]
		then
			echo "pre1.txt is exist"
			cp pre1.txt ${pwd}/2.background
		else
			echo "pre1.txt is not exist"
		fi
	else # has no uniprot class 
		echo "$kegg_species_name has no uniprot class"
		# kegg
		if [ -f kegg_gene.backgroud.txt ]
		then # kegg_gene.backgroud.txt is exist
			echo "kegg_gene.backgroud.txt is exist"
			cp kegg_gene.backgroud.txt ${pwd}/2.background
			sed -i 's/"/ /g' ${pwd}/2.background/kegg_gene.backgroud.txt
			cp anno-kegg_gene.backgroud.txt ${pwd}/2.background
			sed -i 's/"/ /g' ${pwd}/2.background/anno-kegg_gene.backgroud.txt
		else # kegg_gene.backgroud.txt is not exist
			echo "kegg_gene.backgroud.txt is not exist"
			cp kegg_gene.backgroud.xls ${pwd}/2.background
			sed -i 's/"/ /g' ${pwd}/2.background/kegg_gene.backgroud.xls
			cp anno-kegg_gene.backgroud.xls ${pwd}/2.background
			sed -i 's/"/ /g' ${pwd}/2.background/anno-kegg_gene.backgroud.xls
		fi
		# go
		if [ -f gene_go.backgroud.txt ]
		then # gene_go.backgroud.txt is exist
			echo "gene_go.backgroud.txt is exist"
			cp gene_go.backgroud.txt ${pwd}/2.background
		else # gene_go.backgroud.txt is not exist
			echo "gene_go.backgroud.txt is not exist"
			cp gene_go.backgroud.xls ${pwd}/2.background
		fi
		# p2p
		if [ -f protein2protein_network.xls ]
		then # protein2protein_network.xls is exist
			echo "protein2protein_network.xls is exist"
			cp protein2protein_network.xls ${pwd}/2.background
		else # protein2protein_network.xls is not exist
			echo "protein2protein_network.xls is not exist"
		fi
		# pre1.txt
		if [ -f pre1.txt ]
		then
			echo "pre1.txt is exist"
			cp pre1.txt ${pwd}/2.background
		else
			echo "pre1.txt is not exist"
		fi

	fi
	#
else # $kegg_species_name is not exist in /public/hstore5/proteome/database/background
##################################################################################################################
	## 从头准备背景数据 ##
	cd /public/hstore5/proteome/database/background # 切换工作目录
	mkdir -p $kegg_species_name/uniprot # 创建物种目录
	cd $kegg_species_name/uniprot # 切换物种工作目录
##################################################################################################################
	## kegg 背景文件 ##
	cp /public/hstore5/proteome/database/background/program1-2_KEGG_keg_parse.pl ./ # 此时工作路径在/public/hstore5/proteome/database/background/$kegg_species_name/uniprot内
	# cp /public/hstore5/proteome/database/background/program1_ncbi_RNASeq_files_prepare_v3.sh ./
	### 自动检测和修改program1_ncbi_RNASeq_files_prepare_v3.sh 中的物种参数
	# bash ./program1_ncbi_RNASeq_files_prepare_v3.sh # 运行kegg背景文件生成脚本
	#
	# species_org=$kegg_species_name
	#
	#下载kegg文件
	wget  "http://www.kegg.jp/kegg-bin/download_htext?htext=${kegg_species_name}00001.keg&format=htext&filedir=" 
	mv download_htext?htext=${kegg_species_name}00001.keg*   ${kegg_species_name}00001.keg
	cat ${kegg_species_name}00001.keg |awk -F'\t' 'substr($1,1,7)=="D      "||substr($1,1,5)=="C    "||substr($1,1,6)=="B  <b>"||substr($1,1,1)=="A"'|sed 's/<b>/ /g' |sed 's:</b>::' > keg.tmp1.txt
	perl program1-2_KEGG_keg_parse.pl # 此时工作路径在/public/hstore5/proteome/database/background/$kegg_species_name/uniprot内
	##################@@@@@@@@@@$$$$$$$$$$$$$%%%%%%%%%%%%%%%%%^^^^^^^^^^^^^^^^&&&&&&&&&&&&&&&&&&&################
	cat  tmp.out|grep  "PATH:"|awk -F'\t' -v OFS='\t' '{print $4,substr($3,6)}'|sed 's/^D      //' |sed 's: :\t:' |awk -F'\t' -v OFS='\t' '{print $1,$3}'|sed 's: :\t:' |awk -F'\t' -v OFS='\t' '{print $1,substr($3,index($3,"PATH")),$3}'|sed 's:]::'|awk -F'[' '{print substr($1,1,length($1)-1)}' | sort -k2,2 |awk  -F'\t' -v OFS='\t'  '{v=$1; a[v]=a[v]","$2 ;b[v]=b[v]"|"$3}END{for (j in a) print j,a[j],b[j]}' |sed 's:\t|:\t:g'|sed 's:\t,:\t:g' |sed 's:PATH:path:g'  >kegg_gene.backgroud.txt
	cat  tmp.out|grep  "PATH:"|awk -F'\t' -v OFS='\t' '{print $4,$5}'|sed 's/^D      //' |sed 's: :\t:'|awk -F'\t' -v OFS='\t'  '{print $1,$3}'|sed 's: :\t:'|sed 's:;:\t:'|awk -F'[' '{print $1,$2}'|awk -F']' '{print $1}'|sort -k1|awk -F'\t' '++a[$1]==1' > keg.tmp2.txt
	awk -F'\t' -v OFS='\t' 'NR==FNR{a[$1]=$1;b[$1]=$2;next}{if(a[$1]==$1) print $1,$1,$2}'  keg.tmp2.txt    kegg_gene.backgroud.txt > anno-kegg_gene.backgroud.txt
	rm -rf keg.tmp2.txt keg.tmp1.txt tmp.out
	##################@@@@@@@@@@$$$$$$$$$$$$$%%%%%%%%%%%%%%%%%^^^^^^^^^^^^^^^^&&&&&&&&&&&&&&&&&&&################
	if [ -f kegg_gene.backgroud.txt ]
	then
		echo "文件kegg_gene.backgroud.txt已经生成"
		cp kegg_gene.backgroud.txt kegg_gene.backgroud.xls
		cp kegg_gene.backgroud* ${pwd}/2.background
		sed -i 's/"/ /g' ${pwd}/2.background/kegg_gene.backgroud*
	elif [ -f anno-kegg_gene.backgroud.txt ]
	then
		echo "文件anno-kegg_gene.backgroud.txt已经生成"
		cp anno-kegg_gene.backgroud.txt anno-kegg_gene.backgroud.xls
		cp anno-kegg_gene.backgroud* ${pwd}/2.background
		sed -i 's/"/ /g' ${pwd}/2.background/anno-kegg_gene.backgroud*
	else
		echo "kegg背景文件没有生成，请检查生成kegg背景文件脚本的输入文件和参数"
	fi
	#
			
	# 后续通过uniprot id和基因id的关联列表即可转换为蛋白的backgroud文件
##################################################################################################################
##################################################################################################################
	## go 背景文件 ##
	cp /public/hstore5/proteome/database/background/Uni2GO.txt ./ # 此时工作路径在/public/hstore5/proteome/database/background/${kegg_species_name}/uniprot/内
	cp ${pwd}/rawdata/*.fasta ./${search_library_seq}
	# 3.上传本物种/动物/植物/微生物reviewed蛋白序列作为背景库（uniprot下载），以及搜库序列文件（uniprot/NCBI/拼接id）进行blastp比对。
	## 下载物种的reviewed proteins fasta文件，为GO背景文件提供信息
	wget -c -O uniprot_${species}_reviewed.fasta.gz $uniprot_species_reviewed_pseq_website
	## 解压文件
	gunzip uniprot_${species}_reviewed.fasta.gz
	# 暂时手动下载reviewed蛋白序列作为背景库：species_reviewed_protein_seq
	# 处理搜库序列.fasta文件，使得以>号开头的信息记录行只保留id号
	python3 /public/hstore5/proteome/pipeline/script/background-oe/rst/pure-fasta.py -i $search_library_seq
	# 比对
	# sh /public/hstore5/proteome/pipeline/script/background-oe/rst/blast.sh pure_id.fasta $species_reviewed_protein_seq
	# sh /public/hstore5/proteome/pipeline/script/background-oe/rst/blast.sh pure_id.fasta uniprot_${species}_reviewed.fasta
	# 20191220 Friday
	sh /public/hstore5/proteome/pipeline/script/background-oe/rst/blast.sh uniprot_${species}_reviewed.fasta pure_id.fasta
	# 生成go背景
	python3 /public/hstore5/proteome/pipeline/script/background-oe/rst/go-back
	#
	cp gene_go.backgroud.txt gene_go.backgroud.xls # .txt格式的文件转换为.xls格式
	#
	if [ -f gene_go.backgroud.txt ]
	then
		echo "文件gene_go.backgroud.txt已经生成"
		cp gene_go.backgroud.txt ${pwd}/2.background
	elif [ -f gene_go.backgroud.xls ]
	then
		echo "文件gene_go.backgroud.xls已经生成"
		cp gene_go.backgroud.xls ${pwd}/2.background
	else
		echo "GO背景文件没有生成，请检查生成GO的脚本的输入文件和参数"
	fi
	#
##################################################################################################################
##################################################################################################################
	# ## p2p ##
	## String下载
	wget -c https://stringdb-static.org/download/protein.links.v11.0/${taxid}.protein.links.v11.0.txt.gz
	wget -c https://stringdb-static.org/download/protein.sequences.v11.0/${taxid}.protein.sequences.v11.0.fa.gz
	## 解压文件
	gunzip *protein.links.v11.0.txt.gz
	gunzip *protein.sequences.v11.0.fa.gz
	##
	# sh /public/hstore5/proteome/pipeline/script/background-oe/pro2pro/script.sh 下载的序列文件 互作关系文件 上传的序列文件
	cp ${pwd}/rawdata/$search_library_seq ./ # 当前工作路径在/public/hstore5/proteome/database/background/${kegg_species_name}/uniprot/内
	python3 /public/hstore5/proteome/pipeline/script/background-oe/rst/pure-fasta.py -i $search_library_seq # 获得搜库序列的干净fasta文件：pure_id.fasta
	## 准备ppi分析的关键文件
	sh /public/hstore5/proteome/pipeline/script/background-oe/pro2pro/script.sh *protein.sequences.v11.0.fa *protein.links.v11.0.txt pure_id.fasta
	cp protein2protein_network.xls ${pwd}/2.background
	cp pure_id.fasta ${pwd}/2.background
	cp blast_result.txt ${pwd}/2.background
	## pre1.txt
	# 暂时手动下载物种蛋白背景信息文件pre1.txt #
	## 自动下载pre1.txt文件
	grep [[:blank:]]${taxid}[[:blank:]] /public/hstore5/proteome/database/species_genes_proteins_database_info/proteomes-all.tab > species_taxid_info # 提取信息
	species_proteomes_info=`cat species_taxid_info | awk '{print $1}'` # 提取信息
	wget -c -O uniprot-proteome_${species_proteomes_info}.tab.gz "https://www.uniprot.org/uniprot/?query=proteome:${species_proteomes_info}&format=tab&force=true&columns=id,protein%20names,database(GeneID),genes(PREFERRED)&sort=score&compress=yes" # 下载
	gunzip uniprot-proteome_${species_proteomes_info}.tab.gz
	cp uniprot-proteome_${species_proteomes_info}.tab pre1.txt # 修改名称
	echo
	echo "pre1.txt文件准备完毕"
	echo "pre1.txt文件的蛋白个数为： "
	wc -l pre1.txt
	cp pre1.txt ${pwd}/2.background
fi
#
## database/backgroud目录中的物种子目录权限修改为可读可执行
chmod -R a+x /public/hstore5/proteome/database/background/${kegg_species_name}
ls -l /public/hstore5/proteome/database/background/${kegg_species_name}
#
##################################################################################################################
######################################################################################################################
#
## 项目路径下的背景文件处理 ##
# 切换工作目录到项目路径的2.background目录
cd ${pwd}/2.background
ls -RF
# 根据项目搜库的可信蛋白ID将背景文件ID替换
## 复制脚本的输入文件到当前工作目录
cp ../1.dep/差异*筛选结果.xlsx ./
cp ../1.dep/sample_information.xlsx ./
#
cp /public/hstore5/proteome/database/background/${kegg_species_name}/uniprot/gene_go.backgroud* ./
cp /public/hstore5/proteome/database/background/${kegg_species_name}/uniprot/kegg_gene.backgroud* ./
cp /public/hstore5/proteome/database/background/${kegg_species_name}/uniprot/anno-kegg_gene.backgroud* ./
cp /public/hstore5/proteome/database/background/${kegg_species_name}/uniprot/protein2protein_network.xls ./
## 执行python脚本
### 激活prap环境python
# source /public/hstore5/software/anaconda3/bin/activate prap

python /public/hstore5/proteome/pipeline/script/project_result_system/diff-file.py # 生成比较组差异蛋白文件
python /public/hstore5/proteome/pipeline/script/background-oe/rst/pre1-2.py # pre1.txt到pre2.txt
python /public/hstore5/proteome/pipeline/script/background-oe/rst/pre-key5.py # pre2.txt到key5.txt
python /public/hstore5/proteome/pipeline/script/background-oe/rst/replace-kegg.py # kegg背景文件ID替换
#
if [ -e gene_go.backgroud.txt ]
then
	echo "gene_go.backgroud.txt is exist"
	cp gene_go.backgroud.txt gene_go.backgroud.xls
else
	echo "gene_go.backgroud.txt is not exist"
fi
#
python3 /public/hstore5/proteome/pipeline/script/background-oe/rst/replace-go.py # go背景文件ID替换

## 处理项目背景目录下的物种kegg文件
## change name
mv kegg_gene.backgroud.xls gene_kegg.backgroud.xls
mv anno-kegg_gene.backgroud.xls gene_anno-kegg.backgroud.xls
## gene_anno-kegg.backgroud.xls文件处理
python3 /public/hstore5/proteome/pipeline/script/background-oe/rst/clean-anno.py
## 字符串path:替换空值
sed -i "s/path://g" gene_kegg.backgroud.xls

## 复制2.background背景文件到3.enrichment
cp gene_go.backgroud* ../3.enrichment # 此时工作路径在/项目/2.background目录内
cp gene_kegg.backgroud* ../3.enrichment
cp gene_anno-kegg.backgroud* ../3.enrichment
cp protein2protein_network.xls ../3.enrichment
cp ../rawdata/*.fasta ./
echo
echo "GO/KEGG/PPI的背景文件准备完毕"
##
## 生成注释文件的KOG/COG背景
echo
echo "项目准备KOG或COG背景文件"
#
if [ -d KOG ]
then
	echo
	echo "项目目录/2.background/内的KOG文件已经存在，可以生成注释文件"
elif [ -d COG ]
then
	echo
	echo "项目目录/2.background/内的COG文件已经存在，可以生成注释文件"
else
	echo
	echo "项目目录中还没有KOG和COG文件，需要生成"
	echo "开始生成KOG或COG背景文件"
	#
	if grep $kegg_species_name /public/hstore5/proteome/pipeline/script/project_result_system/kegg真核生物简称.txt # 此时>工作路径在/项目路径/2.background内
	then
		echo
		echo "$kegg_species_name是真核生物"
		export PATH=/public/hstore5/software/anaconda3/bin:$PATH # 切换环境
		python3 /public/hstore5/proteome/pipeline/script/background-oe/rst/select_seq.py # 根据差异蛋白、位点和搜库序>列生成可信蛋白FASTA序列文件：trusted.fa
		cp sequence.txt trusted.fa
		perl /public/hstore5/proteome/pipeline/script/annotation_ggy_2019/3.1.run_annotation.pl -fa trusted.fa -sn $kegg_species_name -db kog -sp ${king}
	elif grep $kegg_species_name /public/hstore5/proteome/pipeline/script/project_result_system/kegg原核生物简称.txt # 此>时>工作路径在/项目路径/2.background内
	then
        	echo
        	echo "$kegg_species_name是原核生物"
        	export PATH=/public/hstore5/software/anaconda3/bin:$PATH # 切换环境
        	python3 /public/hstore5/proteome/pipeline/script/background-oe/rst/select_seq.py # 根据差异蛋白、位点和搜库序>列生成可信蛋白FASTA序列文件：trusted.fa
        	cp sequence.txt trusted.fa
        	perl /public/hstore5/proteome/pipeline/script/annotation_ggy_2019/3.1.run_annotation.pl -fa trusted.fa -sn $kegg_species_name -db cog -sp ${king}
	fi
	#
fi
ls -F ${pwd}/2.background # 查看/项目目录/2.background内的文件
## 查看KOG或COG目录是否存在
#
if [ -d KOG ]
then
        echo
        echo "$kegg_species_name的KOG背景文件已经生成"
elif [ -d COG ]
then
        echo
        echo "$kegg_species_name的COG背景文件已经生成"
else
        echo
        echo "$kegg_species_name的KOG或COG没有生成，请检查生成KOG和COG的输入文件'差异蛋白筛选结果.xlsx'、'sample_information.xlsx'和项目搜库FASTA序列文件是否存在以及格式是否正确"
fi
#
echo
echo "Background files is OK"
########################################################################################################
## 第二部分：富集分析
########################################################################################################
#
## 2.0 PPI蛋白互作分析
cp ./*-vs-*-diff-protein.xls ../3.enrichment # 此时工作路径在/项目/2.background目录内。将处理过的比较组差异蛋白文件复制到3.enrichment目录内
cd ${pwd}/3.enrichment # 切换工作路径到/项目/3.enrichment
cp -r /public/hstore5/proteome/pipeline/script/enrich_ppi_script_2019/PPI_network ./
cp protein2protein_network.xls protein2protein.xls ## 修改名称
perl PPI_network/ppi_network.pl -i ./ -g protein2protein.xls -o ppi
perl PPI_network/ppi_network_html.pl -i ppi/ -o ppi/
#
if [ -d ppi ]
then # ppi is exist
	echo "ppi directory is generated"
	if [[ -s top_300_diff-*-vs-*_protein2protein_network.xls ]]
	then
		echo "top_300_diff-*-vs-*_protein2protein_network.xls is not empty"
	else
		echo
		echo "top_300_diff-*-vs-*_protein2protein_network.xls is empty"
		echo "please check ppi analysis of input files"
	fi
else # ppi does not exist
	echo "ppi directory is not generated"
fi

## 处理比较组文件*-vs-*-diff-protein.xls
cp ../1.dep/sample_information.xlsx ./ # 此时工作路径在3.enrichment目录内
cp ../1.dep/差异* ./
cp ../2.background/key5.xls ./
python /public/hstore5/proteome/pipeline/script/project_result_system/pc2.py # 比较组差异蛋白文件ID替换

# 2.1生成Unigene.KEGG.Classification.xls文件
perl /public/hstore5/proteome/pipeline/script/enrich_ppi_script_2019/enrichment_of_different_expressed_gene/format_keggbackgroud.pl -i gene_kegg.backgroud.xls -s $kegg_species_name -o Unigene.KEGG.Classification.xls
#
if [ -s Unigene.KEGG.Classification.xls ]
then # not empty
	echo "Unigene.KEGG.Classification.xls is not empty"
else # empty
	echo "Unigene.KEGG.Classification.xls is empty"
fi
#

# 2.2复制category.xls到项目路径3.enrichment目录内
cp /public/hstore5/proteome/pipeline/script/enrich_ppi_script_2019/enrichment_of_different_expressed_gene/category.xls ./

# 2.3生成Unigene.GO.classification.stat.xls文件
perl /public/hstore5/proteome/pipeline/script/enrich_ppi_script_2019/enrichment_of_different_expressed_gene/format_gobackgroud.pl -i gene_go.backgroud.xls -c category.xls -s Unigene -o ./
#
if [ -s Unigene.GO.classification.stat.xls ]
then # not empty
	echo "Unigene.GO.classification.stat.xls is not empty"
else # empty
	echo "Unigene.GO.classification.stat.xls is empty"	
fi
#

# 2.4最后一步生成enrich目录及富集的文件
perl /public/hstore5/proteome/pipeline/script/enrich_ppi_script_2019/enrichment_of_different_expressed_gene/5.2.enrich_go_kegg.pl -infile *-vs-*-diff-*.xls -go_bg gene_go.backgroud.xls -category category.xls -kegg_bg gene_kegg.backgroud.xls -html /public/hstore5/proteome/database/kegg/${kegg_species_name} -anno_kegg gene_anno-kegg.backgroud.xls -outdir enrich/ -go_lv2 Unigene.GO.classification.stat.xls -kegg_lv2 Unigene.KEGG.Classification.xls
#
if [ -d enrich ]
then # enrich is exist
	echo "enrich directory is generated"
	cd ./enrich;ls
else # enrich is not exist
	echo "enrich directory is not exist"
fi
#
### 关闭prap环境
# source /public/hstore5/software/anaconda3/bin/deactivate prap

echo
echo "Good News: Enrichment analysis is finished, see enrichment result directory 'enrich'"
