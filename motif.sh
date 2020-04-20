#!/bin/bash
unset PYTHONPATH
# start plotting envs
source /public/hstore5/proteome/Personal_dir/jingxinxing/software/anaconda3/bin/activate
mkdir Motif/
 Rscript ./test.R --minseq 5 \
		--pvalue 0.01 \


cd Motif
convert  -resize "10000000@" Motif.pdf Motif.png
# end envs
source /public/hstore5/proteome/Personal_dir/jingxinxing/software/anaconda3/bin/deactivate
echo "Congratulations plotting finished"

