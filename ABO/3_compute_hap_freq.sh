#!/bin/bash
set -beEuo pipefail

SRCNAME=$(readlink -f $0)
SRCDIR=$(dirname ${SRCNAME})
PROGNAME=$(basename $SRCNAME)
VERSION="0.0.1"
NUM_POS_ARGS="0"

ml load snpnet_yt

pop_cnt_file='UKB_population_n.tsv'
hap_freq_dir='data'
hap_freq_tsv='ABO_UKB_freq.tsv'

Rscript ${SRCDIR}/3_compute_hap_freq.R \
${pop_cnt_file} ${hap_freq_dir} ${hap_freq_tsv}
