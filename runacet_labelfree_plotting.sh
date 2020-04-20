#!/usr/bin/bash
unset PYTHONPATH
# start plotting envs
source /public/hstore5/proteome/Personal_dir/jingxinxing/software/anaconda3/bin/activate
# export PATH=/public/hstore5/proteome/Personal_dir/jingxinxing/software/anaconda3/bin/:$PATH
# nohup 本地投递绘图脚本
/public/hstore5/proteome/Personal_dir/jingxinxing/software/anaconda3/bin/Rscript Acetylat_Labelfree_R_Plotting.R
sleep 3
# end envs
source /public/hstore5/proteome/Personal_dir/jingxinxing/software/anaconda3/bin/deactivate
rm ./Statistics/Rplots.pdf
echo "Congratulations plotting finished"
