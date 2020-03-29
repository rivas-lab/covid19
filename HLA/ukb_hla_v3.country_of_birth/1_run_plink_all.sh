#!/bin/bash
set -beEuo pipefail

SRCNAME=$(readlink -f $0)
SRCDIR=$(dirname ${SRCNAME})
PROGNAME=$(basename $SRCNAME)

source "${SRCDIR}/ukb_hla_v3.country_of_birth.misc.sh"
############################################################

ml load plink2

out_dir="private_data"

run_plink_all ${out_dir}
