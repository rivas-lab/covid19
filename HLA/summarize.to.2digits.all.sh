#!/bin/bash
set -beEuo pipefail

in_tbls=(
17ihiw-Family-FQ.tsv
17ihiw-Unrelated-FQ.tsv
UKB.HLA.country_of_birth.tsv
UKB.HLA.PCA_pop.tsv
)

gs_token="@@@@@@@@@@@@@@@@@@@"
gs_sheet='@@@@@@@@@@@@@@@@@@@'

for in_f in ${in_tbls[@]} ; do
    cat ${in_f} | awk '(NR>1){print $1, $2}'
done \
| sed -e 's/HLA-//g' \
| sort -u > summarize.to.2digits.alleles.tsv

Rscript summarize.to.2digits.name.conv.R summarize.to.2digits.alleles.tsv

# upload to gdrive and manual fix for some corner cases

src='summarize.to.2digits.R'

for in_f in ${in_tbls[@]} ; do
  Rscript ${src} $in_f ${in_f%.tsv}.2digits.tsv ${gs_token} ${gs_sheet}
done
