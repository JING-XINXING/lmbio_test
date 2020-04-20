#!/usr/bin/bash
unset PYTHONPATH
# start plotting envs
source /public/hstore5/proteome/Personal_dir/jingxinxing/software/anaconda3/bin/activate
# nohup 本地投递绘图脚本
/public/hstore5/proteome/Personal_dir/jingxinxing/software/anaconda3/bin/Rscript venn_plot.R
sleep 3
# end envs
source /public/hstore5/proteome/Personal_dir/jingxinxing/software/anaconda3/bin/deactivate
echo "Congratulations venn plotting finished"
