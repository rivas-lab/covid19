# snpnet

To characterize predictive models for biomarkers and blood measurements, we fit multivariate predictive models for each trait using `snpnet` package[1,2,3]. The `snpnet` method and `BASIL` algorithm is described in our preprint[1] and its enhanced implementation is described in another preprint[2]. The `R` package is available in our GitHub repository[3].

## List of traits

[`pheno.info.tsv`](pheno_info.tsv) has the list of 66 traits used in this analysis. This consists of 35 blood and urine biomaker traits[4] and 31 blood measurements[5]. The phenotype definition of the blood measurements are described in this paper[6].

## list of scripts/notebooks

- `1_phe_prep.ipynb`: phenotype file prep. We merge the GWAS covariates file, master phe file (for blood measurements phenotypes), and biomarker phenotype file (which is not a part of master phe file).
- `2a_snpnet.biomarkers.sbatch.sh`: snpnet sbatch script for the biomarker phenotypes.
- `2b_snpnet.blood.sbatch.sh`: snpnet sbatch script for the blood measurement phenotypes.

## job submission commands

The job submission commands are summarized in this document: [`snpnet_job_submission.md`](snpnet_job_submission.md).

## Acknowledgement

We thank [Stanford Research Computing Center](https://srcc.stanford.edu/) for [providing prioritized queue for COVID-19 research](http://news.sherlock.stanford.edu/posts/sherlock-joins-the-fight-against-covid-19)[7].

## Reference

1. [Qian, J. et al. A Fast and Flexible Algorithm for Solving the Lasso in Large-scale and Ultrahigh-dimensional Problems. bioRxiv 630079 (2019)](https://doi.org/doi:10.1101/630079).
2. [Li, R. et al. Fast Lasso method for Large-scale and Ultrahigh-dimensional Cox Model with applications to UK Biobank. bioRxiv 2020.01.20.913194 (2020)](https://doi.org/10.1101/2020.01.20.913194).
3. [GitHub:rivas-lab/snpnet - Efficient Lasso Solver for Large-scale genetic variant data. (Rivas Lab, 2019)](https://github.com/rivas-lab/snpnet).
4. [Sinnott-Armstrong, N. et al. Genetics of 38 blood and urine biomarkers in the UK Biobank. bioRxiv 660506 (2019)](https://doi.org/10.1101/660506).
5. [UK Biobank : Category 100081. Blood count - Blood assays - Assay results - Biological samples](http://biobank.ctsu.ox.ac.uk/crystal/label.cgi?id=100081).
6. [Tanigawa, Y. et al. Components of genetic associations across 2,138 phenotypes in the UK Biobank highlight adipocyte biology. Nat Commun 10, 1–14 (2019)](https://doi.org/10.1038/s41467-019-11953-9).
7. [Sherlock joins the fight against COVID-19. Stanford Research Computing Center](http://news.sherlock.stanford.edu/posts/sherlock-joins-the-fight-against-covid-19).
