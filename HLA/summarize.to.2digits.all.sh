#!/bin/bash
set -beEuo pipefail

in_tbls=(
17ihiw-Family-FQ.tsv
17ihiw-Unrelated-FQ.tsv
UKB.HLA.country_of_birth.tsv
UKB.HLA.PCA_pop.tsv
)

src='summarize.to.2digits.R'

for in_f in ${in_tbls[@]} ; do
  Rscript ${src} $in_f ${in_f%.tsv}.2digits.tsv
done
