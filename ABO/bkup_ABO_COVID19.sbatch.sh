#!/bin/bash
#SBATCH --job-name=ABO_bkup
#SBATCH --begin=now+2hours
#SBATCH --dependency=singleton
#SBATCH --time=00:02:00
#SBATCH --mail-type=FAIL
#SBATCH -p mrivas,normal

download_dir=$1
gdrive_file=$2

bash bkup_ABO_COVID19.sh ${download_dir} ${gdrive_file}

## Resubmit the job for the next execution
sbatch $0 ${download_dir} ${gdrive_file}
