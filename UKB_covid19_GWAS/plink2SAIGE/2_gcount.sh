#!/bin/bash
set -beEuo pipefail

ml load plink2/20200409

for c in $(seq 1 22) X XY ; do

plink2 \
  --memory 32000 \
  --threads 4 \
  --keep @@@@@@@@@@@@@@@@@@@ \
  --out  @@@@@@@@@@@@@@@@@@@.chr${c} \
  --pfile @@@@@@@@@@@@@@@@@@@ vzs \
  --geno-counts

plink2 \
  --memory 32000 \
  --threads 4 \
  --keep @@@@@@@@@@@@@@@@@@@ \
  --out  @@@@@@@@@@@@@@@@@@@.chr${c} \
  --pfile @@@@@@@@@@@@@@@@@@@ vzs \
  --geno-counts

done
