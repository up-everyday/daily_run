import re
import os
import io
import json
import sys
def get_info_files(src):
    '''
    e.g.
    case info -- HTML:
        180808_050234.@dft_server_run_daily_time_20180808050234_time.html
    '''
    html_list = []
    for root, dirs, files in os.walk(src):
        for file_name in files:
            if file_name.endswith('time.html') and '_run_daily_' in file_name:
                html_list.append(os.path.join(root,file_name))
    return html_list

def get_failed_case_list(files):
    fail_list = []
    fail_item_template = re.compile("<td>Failed item list is \[(.*)\]</td>")
    for file_name in files:
        if file_name.endswith('.html') and '_run_daily_' in file_name:
            with io.open(file_name, 'r', encoding='utf-8') as fin:
                html_str = fin.read()
                fail_find = re.findall(fail_item_template, html_str)
                if fail_find:  # two times found, choose the first.fail_find[0]
                    fail_list.extend(re.sub(r"dft_server/|'| |\.json", "", fail_find[0]).replace("/","_").replace("-","_").split(","))
    return fail_list

if __name__ == '__main__':
    #src_dir = r"D:\daily_run\ITU_BJRMS22A\181225_143919_r_1"
    src_dir = sys.argv[1]
    failed_case_list = []
    html_list = get_info_files(src_dir)
    case_list = get_failed_case_list(html_list)

    for case in case_list:
        tmp_case = case.replace('_','/')+'.json'
        if tmp_case.startswith("SPID/"):
            tmp_case = tmp_case.replace('SPID/', 'SPID-')
        failed_case_list.append(tmp_case)
    if len(failed_case_list) != 0:
        with open(os.path.join(src_dir,r'failed_case_list.json'), 'wt') as f:
            json.dump(failed_case_list,f, indent=True)
            print("failed_case_list.json is generated!")
    print("gen_failed_list.py ran!")
