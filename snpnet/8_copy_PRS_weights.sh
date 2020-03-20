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

cat ${pheno_info_f} \
| awk '(NR>1){print $1}' \
| while read phe ; do
    for ext in tsv covars.tsv ; do
        if [ -f "${data_src_dir}/${phe}/snpnet.${ext}" ]; then
            cp ${data_src_dir}/${phe}/snpnet.${ext} ${data_dst_dir}/${phe}.${ext} 
        fi
    done
done

tar -czvf ${data_dst_dir}.tar.gz ${data_dst_dir}
mv ${data_dst_dir}.tar.gz ${data_dst_tar}
rm -rf ${data_dst_dir}

gdrive upload -p ${GDrive_path} ${data_dst_tar}
mv ${data_dst_tar} ${local_copy_dir}
