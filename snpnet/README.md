# Polygenic risk scores (PRSs) from `snpnet`

To characterize predictive models for biomarkers and blood measurements, we fit multivariate predictive models for each trait using `snpnet` package[1,2,3]. The `snpnet` method and `BASIL` algorithm is described in our preprint[1] and its enhanced implementation is described in another preprint[2]. The `R` package is available in our GitHub repository[3].

## List of 61 traits used in our analysis

[`pheno.info.tsv`](pheno.info.tsv) has the list of 66 traits used in this analysis. This consists of 35 blood and urine biomaker traits[4] and 31 blood measurements[5]. The phenotype definition of the blood measurements are described in this paper[6].

## Our PRS models

Our PRSs are in the form of multivariate regression. Specifically, we fit the following models for each dataset.

- blood measurements: y ~ age + sex + Array + N_CNV + LEN_CNV + PC1 + &middot;&middot;&middot; + PC10 + &Sigma;<sub>j</sub> G<sub>j</sub>
  - `y` is the blood measurements in the original scale
  - G<sub>j</sub>: genetic variants, which includes SNVs and small indels from the genotyping array and the imputed dataset, HLA allelotypes, and copy number variations (CNVs)[7]. We used in total of 5182706 variants in this analysis.
  - age is computed from the birth year of the individual
  - sex is an indicator variable (1 indicates male; 0 indicates female)
  - Array is an indicator variable for the types of genotyping array used in UK Biobank study (1 indicates UKBB array; 0 indicates UKBL array)
  - N_CNV and LEN_CNV: the number and length of CNVs.
  - PC1-PC10: the first 10 genotype PCs.
- 35 biomarker traits: y ~ N_CNV + LEN_CNV
  - `y` is the **covariate-adjusted** biomarker measurements. Please see our manuscript[4] for more information about our covariate adjstment procedure. Note that we have updated the covariate adjustment procedure since the initial draft of the manuscript and are still preparing the updated manuscript.
  - G<sub>j</sub>, N_CNV, and LEN_CNV: genetic variant and the number and length of CNVs as described above.

## Performance of polygenic risk scores (PRSs)

<span style="color:red">**Our PRS results are not finalized yet! We provide PRSs from intermediate results from our computation.**</span>

We evaluated the performance of PRSs with R<sup>2</sup> and summarize them in two tables, [`metric.summary.blood.tsv`](metric.summary.blood.tsv) and [`metric.summary.biomarkers.tsv`](metric.summary.biomarkers.tsv), for the blood measurements[5] and the biomarker traits[4], respectively. Those two files have the following 4 columns:

1. `phenotype`: the phenotype name
2. `geno_and_covars`: the R<sup>2</sup> in the test set using the risk score computed from both genetic and covariate information.
3. `geno`: the R<sup>2</sup> in the test set using the risk score computed from genetic variation alone.
4. `covars`: the R<sup>2</sup> in the test set using the risk score computed from covariates alone.

Note: for the 35 biomarker phenotypes, we used **covariate-adjusted** biomarker measurements for the inputs for the model and the "covariates" in this evaluation specifically refers to two additional covariates, N_CNV, and LEN_CNV. For the blood measurements, we used the original values as the input.

We also provide the performance metrics computed on the training and the validation set, which is used to choose the optimial _L_<sub>1</sub> regularization parameter for Lasso regression, in [`metric.R2.tsv`](metric.R2.tsv). It has the following 13 colmuns:

- 1. GBE_ID: the phenotype ID in our dataset release.
- 2. pheno: the full phenotype name.
- 3. pheno_plot: a simplified phenotype names, which we often use for visualization.
- 4. dataset: indicates whether the trait belongs to the blood measurements or the 35 biomarkers.
- 5-13. The R<sup>2</sup> metric computed for the training, validation, and test sets. We report the metric using the three sets of features (genetic information + covariates, genetic information alone, and covariates alone) as described above. The column names are in the form of `<data set split>_<feature set>`.

## Weights of polygenic risk scores

We are still running the `snpnet` computation, but provide the PRS weights extracted from the intermediate results. ~~We will soon make the weights (`BETA` in the multivariate predictive model) of the polygenic risk score publicly available.~~

<span style="color:red">**Our PRS results are not finalized yet! We provide PRSs from intermediate results from our computation.**</span>

The weights of our PRS models are available from our [Google Drive shared folder: https://bit.ly/rivas-lab_covid19_PRS_weights](https://bit.ly/rivas-lab_covid19_PRS_weights).

In the shared directory, you should be able to find a `tar.gz` file, named as `rivas-lab_covid19_PRS_weights.YYYYMMDD-hhmmss.tar.gz`. The `YYYYMMDD-hhmmss` represents the date and time of the data release, given that we are still in a process of PRS computation (and will post updates in the future).

Once you extracted the tar file (`$ tar -xzvf rivas-lab_covid19_PRS_weights.YYYYMMDD-hhmmss.tar.gz`), you should able to see two files for each trait in our analysis.

- `<trait ID>.tsv`: the PRS weights for genetic variants. This file has the following columns:
  - CHROM: the chromosome
  - POS: the position (we use `GRCh37` assembly)
  - ID: the variant ID
  - REF: the reference allele
  - ALT: the alternate allele
  - BETA: the effect size estimate in our PRS model, **computed for the ALT allele**.
- `<trait ID>.covars.tsv` the PRS weights for covariates. This file has the following columns:
  - ID: the covariates
  - BETA: the effect size estimate in our PRS model

Our trait IDs are written as `GBE_ID` in [`pheno.info.tsv`](pheno_info.tsv). The full performance metric table ([`metric.R2.tsv`](metric.R2.tsv)) also has the `GBE_ID` column.

## List of scripts/notebooks

- `1_phe_prep.ipynb`: phenotype file prep. We merge the GWAS covariates file, master phe file (for blood measurements phenotypes), and biomarker phenotype file (which is not a part of master phe file).
- `2a_snpnet.biomarkers.sbatch.v3.sh`: snpnet sbatch script for the biomarker phenotypes.
- `2b_snpnet.blood.sbatch.v3.sh`: snpnet sbatch script for the blood measurement phenotypes.
- `3_export_intermediate.sh`: a script to export the intermediate results
- `4_covar_score.R`: a script to compute the risk scores from the covariates
- `5_eval.R`: a script to compute R<sup>2</sup> metric.
- `6_update_evals.sh`: a wrapper script to update the evaluation metrics.
- `7_aggregate_eval_metrics.{R, sh}`: a pair of scripts to update the metric tables.
- `8_copy_PRS_weights.sh`: a script to copy the PRS weights and upload to the Google Drive shared folder.

## Job submission commands

The job submission commands are summarized in this document: [`snpnet_job_submission.md`](snpnet_job_submission.md).

## Acknowledgement

We thank [Stanford Research Computing Center](https://srcc.stanford.edu/) for [providing prioritized queue for COVID-19 research](http://news.sherlock.stanford.edu/posts/sherlock-joins-the-fight-against-covid-19)[8].

## Reference

1. [Qian, J. et al. A Fast and Flexible Algorithm for Solving the Lasso in Large-scale and Ultrahigh-dimensional Problems. bioRxiv 630079 (2019)](https://doi.org/doi:10.1101/630079).
2. [Li, R. et al. Fast Lasso method for Large-scale and Ultrahigh-dimensional Cox Model with applications to UK Biobank. bioRxiv 2020.01.20.913194 (2020)](https://doi.org/10.1101/2020.01.20.913194).
3. [GitHub:rivas-lab/snpnet - Efficient Lasso Solver for Large-scale genetic variant data. (Rivas Lab, 2019)](https://github.com/rivas-lab/snpnet).
4. [Sinnott-Armstrong, N. et al. Genetics of 38 blood and urine biomarkers in the UK Biobank. bioRxiv 660506 (2019)](https://doi.org/10.1101/660506).
5. [UK Biobank : Category 100081. Blood count - Blood assays - Assay results - Biological samples](http://biobank.ctsu.ox.ac.uk/crystal/label.cgi?id=100081).
6. [Tanigawa, Y. et al. Components of genetic associations across 2,138 phenotypes in the UK Biobank highlight adipocyte biology. Nat Commun 10, 1–14 (2019)](https://doi.org/10.1038/s41467-019-11953-9).
7. [Aguirre, M., Rivas, M. A. & Priest, J. Phenome-wide Burden of Copy-Number Variation in the UK Biobank. The American Journal of Human Genetics 105, 373–383 (2019)](https://doi.org/10.1016/j.ajhg.2019.07.001).
8. [Sherlock joins the fight against COVID-19. Stanford Research Computing Center](http://news.sherlock.stanford.edu/posts/sherlock-joins-the-fight-against-covid-19).
