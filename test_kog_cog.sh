#!/bin/bash
kegg_species_name="hsa"
if grep $kegg_species_name /public/hstore5/proteome/pipeline/script/project_result_system/kegg真核生物简称_英文全称_中文名称.txt
then
	echo "It is eu"
elif grep $kegg_species_name /public/hstore5/proteome/pipeline/script/project_result_system/kegg原核生物简称_英文全称.txt
then
	echo "It is pro"
else
	echo "注意：$kegg_species_name 不在文件kegg原核生物简称_英文全称.txt或kegg真核生物简称_英文全称_中文名称.txt中"
fi
