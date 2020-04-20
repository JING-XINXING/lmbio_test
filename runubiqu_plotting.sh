#!/usr/bin/bash
unset PYTHONPATH
# start plotting envs
source /public/hstore5/proteome/Personal_dir/jingxinxing/software/anaconda3/bin/activate
# nohup 本地投递绘图脚本
# /public/hstore5/proteome/Personal_dir/jingxinxing/software/anaconda3/bin/Rscript Phosph_R_Plotting.R --minseq 5 --pvalue 0.01
/public/hstore5/proteome/Personal_dir/jingxinxing/software/anaconda3/bin/Rscript Ubiquitinated_Labelfree_R_Plotting.R
sleep 3
# end envs
source /public/hstore5/proteome/Personal_dir/jingxinxing/software/anaconda3/bin/deactivate
rm ./Statistics/Rplots.pdf
echo "Congratulations plotting finished"
