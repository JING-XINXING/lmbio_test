#!/usr/bin/bash
date
unset PYTHONPATH
## start plotting envs
source /public/hstore5/proteome/Personal_dir/jingxinxing/software/anaconda3/bin/activate
## gene_go.backgroud.xls
sed -e 's/:/\t/' gene_go.backgroud.xls > gene_go.backgroud_new.xls
## gene_kegg.backgroud.xls
sed -e 's/:/\t/' gene_kegg.backgroud.xls > gene_kegg.backgroud_new.xls
## gene_anno-kegg.backgroud.xls
sed -e 's/:/\t/' gene_anno-kegg.backgroud.xls > gene_anno-kegg.backgroud_new.xls
## 新建一个目录，用来存放物种的GO/KEGG背景文件
mkdir -p Species_background
## 
cp gene_go.backgroud.xls ./Species_background
cp gene_kegg.backgroud.xls ./Species_background
cp gene_anno-kegg.backgroud.xls ./Species_background
##
Rscript Trusted_Backgroud_v1.R
sleep 3
## end envs
source /public/hstore5/proteome/Personal_dir/jingxinxing/software/anaconda3/bin/deactivate
##
ls -RF ./Trusted_Backgroud
cp ./Trusted_Backgroud/* ./
echo "Congratulations. Your work is done."
