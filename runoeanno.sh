#!/usr/bin/bash
date
unset PYTHONPATH
## copy files
# cp /public/hstore5/proteome/pipeline/script/project_result_system/pfam_all.xlsx ./
# cp /public/hstore5/proteome/pipeline/script/project_result_system/eggNOG_new.xlsx ./
# cp /public/hstore5/proteome/pipeline/script/project_result_system/NOG.annotations.txt ./
## start plotting envs
source /public/hstore5/proteome/Personal_dir/jingxinxing/software/anaconda3/bin/activate
/public/hstore5/proteome/Personal_dir/jingxinxing/software/anaconda3/bin/Rscript oe_annotation.R
sleep 3
# end envs
source /public/hstore5/proteome/Personal_dir/jingxinxing/software/anaconda3/bin/deactivate
if find annotation.xlsx
then
	echo "Congratulations The annotation.xlsx is generated" 
else
	echo "Please check your GO、KEGG、KOG/COG and 差异蛋白筛选结果.xlsx文件，the pfam and eggNOG data are ready, you needn't check them"
fi
