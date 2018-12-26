#!/bin/sh

count=1
cycl=2
tool_dir="/home/cedailyrun/automation189_itu_BJRMS22A/"
dest_dir="/home/cedailyrun/log/automation189_itu_BJRMS22A/SurepayDraft/result/"
#cases_flie="ITU_BJRMS22A.json"
cases_flie="test.json"

log_dir="${tool_dir}SurepayDraft/result/"

if [[ -f  "${tool_dir}failed_case_list.json"  && "$count" -eq "1" ]]
then
rm ${tool_dir}failed_case_list.json
fi

for ((i=1;i<=$count;i++))
do
echo "if judeg"
if [ -f  "${tool_dir}failed_case_list.json" ]
then
echo "if run"
count_str='f'_${i}
count_d="$(date "+%y%m%d_%H%M%S_${count_str}")"
echo "Complete to run the selected cases, please check it." > ${tool_dir}${count_d}.log 2>&1
python ${tool_dir}genSimpleReport.py ${log_dir}
python ${tool_dir}gen_failed_list.py ${log_dir}
rm ${tool_dir}failed_case_list.json
mv ${log_dir}failed_case_list.json ${tool_dir}
elif (($count < $cycl))
then
echo "else if "
count=3
count_str='r'_${i}
count_d="$(date "+%y%m%d_%H%M%S_${count_str}")"
echo "Complete to run the selected cases, please check it." > ${tool_dir}${count_d}.log  2>&1
python ${tool_dir}genSimpleReport.py ${log_dir}
python ${tool_dir}gen_failed_list.py ${log_dir}
mv ${log_dir}failed_case_list.json ${tool_dir}
fi
sleep 1
dir1="$(date "+%y%m%d_%H%M%S_$count_str")"
mkdir ${log_dir}$dir1/
mv ${log_dir}*.log ${log_dir}*.json ${log_dir}*.html ${log_dir}*.debug ${log_dir}*.decode ${log_dir}$dir1/
sleep 5
#scp -r ${log_dir}$dir1/ cedailyrun@135.242.16.163:${dest_dir} && rm -rf ${log_dir}$dir1
hostname="BJRMS22B"
python xxx.py ${hostname} ${tool_dir}${count_d}.log
cp -pr ${log_dir}$dir1  ${dest_dir} && rm -rf ${log_dir}$dir1
done
