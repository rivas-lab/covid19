#!/bin/bash
set -beEuo pipefail

# we extract the variants tagging ABO locus and convert file format

original_pfile="@@@@@@@@@@@@@@@@@@@"
extract_list="1_prep_plink_data.var.lst"
out_prefix="data/ukb_ABO_tag"


ml load plink2
ml load plink

plink2 --out ${out_prefix} --pfile ${original_pfile} vzs --extract ${extract_list} --make-pgen vzs 
mv ${out_prefix}.log ${out_prefix}.pgen.log

plink2 --out ${out_prefix} --pfile ${out_prefix} vzs --make-bed
mv ${out_prefix}.log ${out_prefix}.bed.log

plink2 --out ${out_prefix} --pfile ${out_prefix} vzs --export A 
mv ${out_prefix}.log ${out_prefix}.raw.log

plink  --out ${out_prefix} --bfile ${out_prefix} --export ped
mv ${out_prefix}.log ${out_prefix}.ped.log
