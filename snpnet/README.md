# snpnet

We compute PRS with snpnet.

## list of scripts/notebooks

- `1_phe_prep.ipynb`: phenotype file prep. We merge the GWAS covariates file, master phe file (for blood measurements phenotypes), and biomarker phenotype file (which is not a part of master phe file).
- `2a_snpnet.biomarkers.sbatch.sh`: snpnet sbatch script for the biomarker phenotypes.
- `2b_snpnet.blood.sbatch.sh`: snpnet sbatch script for the blood measurement phenotypes.

## some useful commans

### v2

```
cat pheno.info.tsv | awk '(NR>1){print $1}' | while read p ; do if [ ! -f /oak/stanford/groups/mrivas/projects/covid19/snpent/$p/snpnet.tsv ] ; then echo $p ; fi ; done | egrep -v '^INI' | while read p ; do echo $p ; sbatch 2a_snpnet.biomarkers.sbatch.v2.sh $p ; done | tee 2a_snpnet.biomarkers.sbatch.v2.log

cat pheno.info.tsv | awk '(NR>1){print $1}' | while read p ; do if [ ! -f /oak/stanford/groups/mrivas/projects/covid19/snpent/$p/snpnet.tsv ] ; then echo $p ; fi ; done | egrep '^INI' | while read p ; do echo $p ; sbatch 2b_snpnet.blood.sbatch.v2.sh $p ; done | tee 2b_snpnet.blood.sbatch.v2.log
```

### v1

```
cat pheno.info.tsv | awk '(NR>1){print $1}' | egrep -v '^INI' | while read p ; do echo $p ; sbatch 2a_snpnet.biomarkers.sbatch.sh $p ; done | tee 2a_snpnet.biomarkers.sbatch.log

cat pheno.info.tsv | awk '(NR>1){print $1}' | egrep '^INI' | while read p ; do echo $p ; sbatch 2b_snpnet.blood.sbatch.sh $p ; done | tee 2b_snpnet.blood.sbatch.log
```

```
cat pheno.info.tsv | awk '(NR>1){print $1}' | while read p ; do if [ ! -f /oak/stanford/groups/mrivas/projects/covid19/snpent/$p/snpnet.tsv ] ; then echo $p ; fi ; done 
```