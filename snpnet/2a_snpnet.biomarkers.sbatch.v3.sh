#!/bin/bash
#SBATCH --job-name=snpnet
#SBATCH --output=logs/snpnet.biomarkers.%A.out
#SBATCH  --error=logs/snpnet.biomarkers.%A.err
#SBATCH --nodes=1
#SBATCH --cores=8
#SBATCH --mem=120000
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
    local job_script="2a_snpnet.biomarkers.sbatch.v3.sh"
    local job_sub_log="2a_snpnet.biomarkers.sbatch.v3.log"

    local job_phenotype_name=$1
    local job_try_cnt=$2
    local job_try_cnt_tot=$3
    local job_cores=$4
    local job_mem=$5

    if [ "${job_try_cnt_tot}" -lt 20 ] ; then
        if [ "${job_try_cnt}" -gt 4 ] ; then
            job_cores=$( perl -e "print(int(${job_cores}))" )
            job_mem=$(   perl -e "print(int(${job_mem} * 1.5))" )
            job_try_cnt=1
        else
            job_try_cnt=$( perl -e "print(int(${job_try_cnt} + 1))" )
        fi
        job_try_cnt_tot=$( perl -e "print(int(${job_try_cnt_tot} + 1))" )

        jid=$(sbatch \
        --dependency=afternotok:${SLURM_JOBID} \
        --cores=${job_cores} \
        --mem=${job_mem} \
        ${job_script} \
        ${job_phenotype_name} \
        ${job_try_cnt} \
        ${job_try_cnt_tot} \
        ${job_cores} \
        ${job_mem} \
        | awk '{print $NF}')

        echo "${job_phenotype_name} ${jid}" >> ${job_sub_log}

        echo ${jid}
    fi
}

############################################################
# Required arguments for ${snpnet_wrapper} script
############################################################
phenotype_name=$1 # One may use phenotype_name=$1 etc
genotype_pfile="@@@@@@@@@@@@@@@@@@@"
phe_file="@@@@@@@@@@@@@@@@@@@"
family="gaussian"
results_dir="@@@@@@@@@@@@@@@@@@@/snpent/${phenotype_name}"

############################################################
# Additional optional arguments for ${snpnet_wrapper} script
############################################################
# covariates="None"
# covariates="age,sex,Array,PC1,PC2,PC3,PC4"
covariates="N_CNV,LEN_CNV"
split_col="split"
status_col="CoxStatus"

############################################################
# Configure other parameters
############################################################
ml load snpnet_yt/0.3.4

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
