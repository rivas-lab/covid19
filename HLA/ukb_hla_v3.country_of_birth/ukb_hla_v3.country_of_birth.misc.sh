#!/bin/bash
set -beEuo pipefail


country_of_birth_data_d="@@@@@@@@@@@@@@@@@@@"
coding_tsv="${country_of_birth_data_d}/@@@@@@@@@@@@@@@@@@@"
country_tsv="${country_of_birth_data_d}/@@@@@@@@@@@@@@@@@@@"

hla_pfile="@@@@@@@@@@@@@@@@@@@"

list_country_codes () {
    cat ${coding_tsv} | awk '(NR>1 && $NF>=30){print $1}'
}

extract_keep_file () {
    local country_code=$1
    cat ${country_tsv} \
    | awk -v FS='\t' -v OFS='\t' -v code=${country_code} '($4 == code){print $1, $2}'
}

run_plink () {
    local country_code=$1
    local out_dir=$2
    
    extract_keep_file ${country_code} \
    | plink2 \
    --memory 40000 --threads 5 \
    --out ${out_dir}/ukb_hla_v3.${country_code} \
    --pfile ${hla_pfile} \
    --keep /dev/stdin \
    --freq
    
    extract_keep_file ${country_code} \
    | plink2 \
    --memory 40000 --threads 5 \
    --out ${out_dir}/ukb_hla_v3.${country_code} \
    --pfile ${hla_pfile} \
    --keep /dev/stdin \
    --geno-counts
}

run_plink_all () {
    local out_dir=$1
    list_country_codes | while read code ; do run_plink ${code} ${out_dir} ; done
}
