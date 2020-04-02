#!/bin/bash
set -beEuo pipefail

ml load gdrive
download_dir=$1
gdrive_file=$2

timestamp=$(date +%Y%m%d-%H%M%S)
filename='ABO_COVID19'

latest_f=$(find ${download_dir} -type f | grep ${filename} | sort -Vr | awk 'NR==1')
latest_md5sum=$(md5sum ${latest_f} | awk '{print $1}')

cd ${download_dir}
gdrive export -f --mime text/tab-separated-values ${gdrive_file}

new_md5sum=$(md5sum ${filename} | awk '{print $1}')

if [ "${new_md5sum}" != "${latest_md5sum}" ] ; then
    mv ${download_dir}/${filename} ${download_dir}/${filename}.${timestamp}.tsv
else # no change.
    mv ${latest_f} ${download_dir}/${filename}.${timestamp}.tsv
    rm ${download_dir}/${filename}
fi

echo ${download_dir}/${filename}.${timestamp}.tsv
