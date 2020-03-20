#!/bin/bash
set -beEuo pipefail

SRCNAME=$(readlink -f $0)
SRCDIR=$(dirname ${SRCNAME})
PROGNAME=$(basename $SRCNAME)
VERSION="0.0.1"
NUM_POS_ARGS="0"

ml load snpnet_yt

data_dir=$(readlink -f $1)
phe_info_f='pheno.info.tsv'
out_file=metric.R2.tsv
out_tmp_file=metric.R2.tmp.tsv

find ${data_dir} -name "*.eval.tsv" \
| parallel 'cat {} | grep -v "#"' > ${out_tmp_file}


Rscript ${SRCDIR}/7_aggregate_eval_metrics.R ${phe_info_f} ${out_tmp_file} ${out_file}

rm ${out_tmp_file}