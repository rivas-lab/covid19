#!/bin/bash
set -beEuo pipefail

SRCNAME=$(readlink -f $0)
SRCDIR=$(dirname ${SRCNAME})
PROGNAME=$(basename $SRCNAME)
VERSION="0.0.1"
NUM_POS_ARGS="0"

pheno_info_f="${SRCDIR}/pheno.info.tsv"
data_src_dir="${SRCDIR}/data"
data_dst_dir="${SRCDIR}/rivas-lab_covid19_PRS_weights"
data_dst_tar="${data_dst_dir}.$(date +%Y%m%d-%H%M%S).tar.gz"
GDrive_path="@@@@@@@@@@@@@@@@@@@"
local_copy_dir="@@@@@@@@@@@@@@@@@@@"

ml load gdrive

if [ ! -d ${data_dst_dir} ] ; then mkdir -p ${data_dst_dir} ; fi

cat metric.R2.tsv | egrep -v 'INI30230|INI30170' > ${data_dst_dir}/metric.R2.tsv

cat ${pheno_info_f} \
| awk '(NR>1){print $1}' \
| egrep -v 'INI30230|INI30170' \
| while read phe ; do
    for ext in tsv covars.tsv sscore.png sscore.summary.tsv; do
        if [ -f "${data_src_dir}/${phe}/snpnet.${ext}" ]; then
            cp ${data_src_dir}/${phe}/snpnet.${ext} ${data_dst_dir}/${phe}.${ext} 
        fi
        if [ -f "${data_src_dir}/${phe}/${phe}.${ext}" ]; then
            cp ${data_src_dir}/${phe}/${phe}.${ext} ${data_dst_dir}/${phe}.${ext} 
        fi
    done
done

tar -czvf ${data_dst_dir}.tar.gz --transform "s%${SRCDIR}%%g" -C $(dirname ${data_dst_dir}) $(basename ${data_dst_dir})
mv ${data_dst_dir}.tar.gz ${data_dst_tar}
rm -rf ${data_dst_dir}

mv ${data_dst_tar} ${local_copy_dir}/
echo gdrive upload -p ${GDrive_path} ${local_copy_dir}/$(basename ${data_dst_tar})
