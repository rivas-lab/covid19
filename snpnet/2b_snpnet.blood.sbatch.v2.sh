#!/bin/bash
#SBATCH --job-name=snpnet
#SBATCH --output=logs/snpnet.blood.%A.out
#SBATCH  --error=logs/snpnet.blood.%A.err
#SBATCH --nodes=1
#SBATCH --cores=6
#SBATCH --mem=80000
#SBATCH --time=2-00:00:00
#SBATCH -p mrivas,normal,owners
set -beEuo pipefail

def_cores=$( cat $0 | egrep '^#SBATCH --cores='  | awk -v FS='=' '{print $NF}' )
def_mem=$(   cat $0 | egrep '^#SBATCH --mem='    | awk -v FS='=' '{print $NF}' )

if [ $# -gt 1 ] ; then try_cnt=$2 ;     else try_cnt='1' ; fi
if [ $# -gt 2 ] ; then try_cnt_tot=$3 ; else try_cnt_tot='1' ; fi
if [ $# -gt 3 ] ; then cores=$4 ;       else cores=${def_cores} ; fi
if [ $# -gt 4 ] ; then mem=$5 ;         else mem=${def_mem} ; fi

submit_new_job () {
    local job_script="2b_snpnet.blood.sbatch.v2.sh"

    local job_phenotype_name=$1
    local job_try_cnt=$2
    local job_try_cnt_tot=$3
    local job_cores=$4
    local job_mem=$5

    if [ "${job_try_cnt_tot}" -lt 15 ] ; then
        if [ "${job_try_cnt}" -gt 3 ] ; then
            job_cores=$( perl -e "print(int(${job_cores} * 1.5))" )
            job_mem=$(   perl -e "print(int(${job_mem} * 1.5))" )
            job_try_cnt=1
        else
            job_try_cnt=$( perl -e "print(int(${job_try_cnt} + 1))" )
        fi
        job_try_cnt_tot=$( perl -e "print(int(${job_try_cnt_tot} + 1))" )

        sbatch \
        --dependency=afternotok:${SLURM_JOBID} \
        --cores=${job_cores} \
        --mem=${job_mem} \
        ${job_script} \
        ${job_phenotype_name} \
        ${job_try_cnt} \
        ${job_try_cnt_tot} \
        ${job_cores} \
        ${job_mem} \
        | awk '{print $NF}'
    fi
}

############################################################
# Required arguments for ${snpnet_wrapper} script
############################################################
phenotype_name=$1 # One may use phenotype_name=$1 etc
genotype_pfile="/scratch/groups/mrivas/ukbb24983/array_imp_combined/pgen/ukb24983_hg19_cal_hla_cnv_imp"
# phe_file="/oak/stanford/groups/mrivas/projects/covid19/snpent/pheno.tsv"
phe_file="/scratch/groups/mrivas/projects/covid19/snpent/pheno.tsv"
family="gaussian"
results_dir="/oak/stanford/groups/mrivas/projects/covid19/snpent/${phenotype_name}"

############################################################
# Additional optional arguments for ${snpnet_wrapper} script
############################################################
# covariates="None"
# covariates="age,sex,Array,PC1,PC2,PC3,PC4"
covariates="age,sex,Array,N_CNV,LEN_CNV,PC1,PC2,PC3,PC4,PC5,PC6,PC7,PC8,PC9,PC10"
split_col="split"
status_col="CoxStatus"

############################################################
# Configure other parameters
############################################################
# cores=$( cat $0 | egrep '^#SBATCH --cores='  | awk -v FS='=' '{print $NF}' )
# mem=$(   cat $0 | egrep '^#SBATCH --mem='    | awk -v FS='=' '{print $NF}' )
ml load snpnet_yt/0.3.4
#ml load snpnet_yt/dev
# Two variables (${snpnet_dir} and ${snpnet_wrapper}) should be already configured by Sherlock module
# https://github.com/rivas-lab/sherlock-modules/tree/master/snpnet
# Or, you may use the latest versions
#  snpnet_dir="$OAK/users/$USER/repos/rivas-lab/snpnet"
#  snpnet_wrapper="$OAK/users/$USER/repos/rivas-lab/PRS/helper/snpnet_wrapper.sh"

############################################################
# Run ${snpnet_wrapper} script
############################################################

echo "[$0 $(date +%Y%m%d-%H%M%S)] [start] hostname = $(hostname) SLURM_JOBID = ${SLURM_JOBID:=0}; phenotype = ${phenotype_name}" >&2

if  [ ! -f ${results_dir}/snpnet.tsv ] && 
    [ ! -f ${results_dir}/snpnet.RData ] &&
    [ ! -f ${results_dir}/${phenotype_name}.log ] &&
    [ ! -f ${results_dir}/${phenotype_name}.sscore.zst ] ; then
    
    new_job_id="$( submit_new_job ${phenotype_name} ${try_cnt} ${try_cnt_tot} ${cores} ${mem} )"

    bash ${snpnet_wrapper} \
    --snpnet_dir ${snpnet_dir} \
    --nCores ${cores} --memory ${mem} \
    --covariates ${covariates} \
    --split_col ${split_col} \
    --status_col ${status_col} \
    --verbose \
    --save_computeProduct \
    --glmnetPlus \
    ${genotype_pfile} \
    ${phe_file} \
    ${phenotype_name} \
    ${family} \
    ${results_dir}

    # --no_save
fi

if [ ! -z "${new_job_id}" ] ; then
    scancel ${new_job_id}
fi

echo "[$0 $(date +%Y%m%d-%H%M%S)] [end] hostname = $(hostname) SLURM_JOBID = ${SLURM_JOBID:=0}; phenotype = ${phenotype_name}" >&2
