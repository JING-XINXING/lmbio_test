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
