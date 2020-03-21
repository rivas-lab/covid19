#!/bin/bash
set -beEuo pipefail

# run plink/1.07 --hap-freq

out_prefix="data/ukb_ABO_tag"
pop_def_dir="@@@@@@@@@@@@@@@@@@@"

for pop in Chinese Indian Pakistani Bangladeshi ; do

    ml load plink/1.90b6.16
    plink --bfile ${out_prefix} --export ped --keep ${pop_def_dir}/ukb24983_${pop}.phe --out ${out_prefix}.${pop}
    mv ${out_prefix}.${pop}.log ${out_prefix}.${pop}.ped.log 

    ml load plink/1.07
    plink --hap-window 3 --file ${out_prefix}.${pop} --hap-freq --noweb --out ${out_prefix}.${pop}
    mv ${out_prefix}.${pop}.log ${out_prefix}.${pop}.frq.hap.log 

done
