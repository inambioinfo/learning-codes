#########################################################################
# File Name: pc07-exome.sh
# Author: Chun-Jie Liu
# Mail: chunjie-sam-liu@foxmail.com
# Created Time: Tue 03 Jul 2018 09:47:24 AM CST
#########################################################################
#!/bin/bash

# ! pipeline scripts
wes=/project/xiamx/exome/exome_pipline/wes_analysis.py

# ? data dir
data_dir=/home/liucj/data/wxs/liujy/Project_C0571180007

sample_dir=`ls -d ${data_dir}/Sample*`


# for sd in ${sample_dir[@]}
# do
#     gz_file=(`ls ${sd}/*gz`)
#     fq1=${gz_file[0]%.gz}
#     [[ -f ${fq1} ]] || gunzip ${gz_file[0]}
#     fq2=${gz_file[1]%.gz}
#     [[ -f ${fq2} ]] || gunzip ${gz_file[1]}
# done

source activate py27
for sd in ${sample_dir[@]}
do
    s=`basename ${sd}`
    fqs=(`ls ${sd}/*fastq`)
    fq1=`basename ${fqs[0]}`
    fq2=`basename ${fqs[1]}`
    out=${data_dir}/wxs-result/${s}
    [[ -d ${out} ]] || mkdir -p ${out}
    # run the wxs analysis
    cmd="python ${wes} -pe1 ${fq1} -pe2 ${fq2} -i ${sd} -o ${out}"
    echo "Notice: start analysis ${s}"
    echo ${cmd}
    eval ${cmd}
    echo "Notice: ${s} analysis end"
done