#!/bin/bash
#SBATCH --job-name=snpnet
#SBATCH --output=logs/snpnet.biomarkers.%A.out
#SBATCH  --error=logs/snpnet.biomarkers.%A.err
#SBATCH --nodes=1
#SBATCH --cores=6
#SBATCH --mem=80000
#SBATCH --time=2-00:00:00
#SBATCH -p mrivas,normal,owners
set -beEuo pipefail

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
covariates="N_CNV,LEN_CNV"
split_col="split"
status_col="CoxStatus"

############################################################
# Configure other parameters
############################################################
cores=$( cat $0 | egrep '^#SBATCH --cores='  | awk -v FS='=' '{print $NF}' )
mem=$(   cat $0 | egrep '^#SBATCH --mem='    | awk -v FS='=' '{print $NF}' )
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

echo "[$0 $(date +%Y%m%d-%H%M%S)] [end] hostname = $(hostname) SLURM_JOBID = ${SLURM_JOBID:=0}; phenotype = ${phenotype_name}" >&2
