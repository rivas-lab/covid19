# snpnet job submission commands

In this document, we summarize some of the useful commands for job submission.

## some useful commans

We are planning to move this section into a separate document.

### check the status of the jobs

```{bash}
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
cat pheno.info.tsv | awk '(NR>1){print $1}' | egrep -v '^INI' | while read p ; do sbatch 2a_snpnet.biomarkers.sbatch.v3.sh $p | awk -v p=$p '{print p, $NF}' ; done | tee -a 2a_snpnet.biomarkers.sbatch.v3.log

cat pheno.info.tsv | awk '(NR>1){print $1}' | egrep '^INI' | while read p ; do sbatch 2b_snpnet.blood.sbatch.v3.sh $p | awk -v p=$p '{print p, $NF}' ; done | tee -a 2b_snpnet.blood.sbatch.v3.log
```

### v2

- This version of the scripts comes with an automated re-submission of the jobs.

### v1

- Initial version of the script
