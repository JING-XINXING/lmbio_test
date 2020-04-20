#!/usr/bin/bash
startTime=`date +"%s.%N"`
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
## 运行R脚本
/public/hstore5/proteome/Personal_dir/jingxinxing/software/anaconda3/bin/Rscript Trusted_Background_v2.R
sleep 3
## end envs
source /public/hstore5/proteome/Personal_dir/jingxinxing/software/anaconda3/bin/deactivate
## 
ls -RF ./Trusted_Background
cp ./Trusted_Background/* ./
echo "Congratulations. Your work is done." 
endTime=`date +"%s.%N"` 
echo `awk -v x1="$(echo $endTime | cut -d '.' -f 1)" -v x2="$(echo $startTime | cut -d '.' -f 1)" -v y1="$[$(echo $endTime | cut -d '.' -f 2) / 1000]" -v y2="$[$(echo $startTime | cut -d '.' -f 2) /1000]" 'BEGIN{printf "RunTIme:%.6f s",(x1-x2)+(y1-y2)/1000000}'`
