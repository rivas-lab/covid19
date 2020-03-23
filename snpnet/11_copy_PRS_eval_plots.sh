#!/bin/bash
set -beEuo pipefail

SRCNAME=$(readlink -f $0)
SRCDIR=$(dirname ${SRCNAME})
PROGNAME=$(basename $SRCNAME)
VERSION="0.0.1"
NUM_POS_ARGS="0"

pheno_info_f="${SRCDIR}/pheno.info.tsv"
src_dir='data'
dst_dir='figs'

cat ${pheno_info_f} | sed -e 's/(//g' | sed -e 's/)//g' | cut -f1,2 | grep -v '#' \
| while read GBE_ID pheno ; do 
    src_f="${src_dir}/${GBE_ID}/${GBE_ID}.sscore.png" 
    dst_f="${dst_dir}/PRS.eval.${pheno}.png"
    if [ -f ${src_f} ] ; then cp ${src_f} ${dst_f} ; fi
done
