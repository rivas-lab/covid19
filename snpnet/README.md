# snpnet

We compute PRS with `snpnet`.

## list of scripts/notebooks

- `1_phe_prep.ipynb`: phenotype file prep. We merge the GWAS covariates file, master phe file (for blood measurements phenotypes), and biomarker phenotype file (which is not a part of master phe file).
- `2a_snpnet.biomarkers.sbatch.sh`: snpnet sbatch script for the biomarker phenotypes.
- `2b_snpnet.blood.sbatch.sh`: snpnet sbatch script for the blood measurement phenotypes.

## some useful commans

We are planning to move this section into a separate document.

### check the status of the jobs

```{bash}
cd /oak/stanford/groups/mrivas/projects/covid19/snpent

find  -type f -name "*sscore.zst" | while read p ; do basename $p .sscore.zst ; done | sort | awk '{print NR, $0}'

find  -type f -name "*.RData" | wc

find  -type f -name "*.RData"|  awk -v FS='/' '{print $2}' | sort | uniq -c | sort -k1,1n | less

find  -type f -name "*.RData" | egrep -v $(find  -type f -name "*sscore.zst" | while read p ; do basename $p .sscore.zst ; done | sort | tr "\n" "|" | rev | cut -c2- | rev) |  awk -v FS='/' '{print $2}' | sort | uniq -c | sort -k1,1n | less
```

### v3

- Default is now 120GB of mem.
- Added special commands to COVID-19 queue.
- The job submission and re-submission histories are dumped to log files.

```{bash}
cat pheno.info.tsv | awk '(NR>1){print $1}' | while read p ; do if [ ! -f /oak/stanford/groups/mrivas/projects/covid19/snpent/$p/snpnet.tsv ] ; then echo $p ; fi ; done | egrep -v '^INI' | while read p ; do echo $p ; sbatch 2a_snpnet.biomarkers.sbatch.v3.sh $p ; done | tee 2a_snpnet.biomarkers.sbatch.v3.log

cat pheno.info.tsv | awk '(NR>1){print $1}' | while read p ; do if [ ! -f /oak/stanford/groups/mrivas/projects/covid19/snpent/$p/snpnet.tsv ] ; then echo $p ; fi ; done | egrep '^INI' | while read p ; do echo $p ; sbatch 2b_snpnet.blood.sbatch.v3.sh $p ; done | tee 2b_snpnet.blood.sbatch.v3.log
```

### v2

- This version of the scripts comes with an automated re-submission of the jobs.

```{bash}
cat pheno.info.tsv | awk '(NR>1){print $1}' | while read p ; do if [ ! -f /oak/stanford/groups/mrivas/projects/covid19/snpent/$p/snpnet.tsv ] ; then echo $p ; fi ; done | egrep -v '^INI' | while read p ; do echo $p ; sbatch 2a_snpnet.biomarkers.sbatch.v2.sh $p ; done | tee 2a_snpnet.biomarkers.sbatch.v2.log

cat pheno.info.tsv | awk '(NR>1){print $1}' | while read p ; do if [ ! -f /oak/stanford/groups/mrivas/projects/covid19/snpent/$p/snpnet.tsv ] ; then echo $p ; fi ; done | egrep '^INI' | while read p ; do echo $p ; sbatch 2b_snpnet.blood.sbatch.v2.sh $p ; done | tee 2b_snpnet.blood.sbatch.v2.log
```

### v1

- Initial version of the script

```{bash}
cat pheno.info.tsv | awk '(NR>1){print $1}' | egrep -v '^INI' | while read p ; do echo $p ; sbatch 2a_snpnet.biomarkers.sbatch.sh $p ; done | tee 2a_snpnet.biomarkers.sbatch.log

cat pheno.info.tsv | awk '(NR>1){print $1}' | egrep '^INI' | while read p ; do echo $p ; sbatch 2b_snpnet.blood.sbatch.sh $p ; done | tee 2b_snpnet.blood.sbatch.log
```

```{bash}
cat pheno.info.tsv | awk '(NR>1){print $1}' | while read p ; do if [ ! -f /oak/stanford/groups/mrivas/projects/covid19/snpent/$p/snpnet.tsv ] ; then echo $p ; fi ; done
```
