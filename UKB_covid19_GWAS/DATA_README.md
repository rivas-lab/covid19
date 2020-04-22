# COVID-19 UKB GWAS Dataset release from the Rivas Lab

We make our dataset publicly available via Google Drive shared folder: @@@@@@@@@@@@@@@@@@@. Given that we will be continuously updating our analysis, we use an explicit versioning of our data release and the release date is indicated by directory name (`YYYYMMDD`).

This document explains the set of availalbe files. Please check [`README.md`](README.md) for a summary of our analysis.

## Version `20200421`

We have the following files are available in this dataset. All summary statistics files are on hg19, with the exception of the exome dataset (hg38).

- GWAS summary statistics for COVID-19
  - Additive model with `age + sex + BMI + Townsend Array + PC1 + ... + PC10 + N_CNV + LEN_CNV` as covariates.
    - Meta-analysis of WB_NBW, African, and South Asian (in this order)
      - `ukb24983_v2_hg19.array-combined.covid19_test_result.BMI_Townsend.metal.tsv.gz`
    - White British and non-British white (WB + NBW, 388 + 41 = 429 cases vs 361614 controls)
      - `ukb24983_v2_hg19.WB_NBW.array-combined.covid19_test_result.glm.logistic.hybrid.BMI_Townsend.gz`
    - African (40 cases and 6457 controls)
      - `ukb24983_v2_hg19.african.array-combined.covid19_test_result.glm.logistic.hybrid.BMI_Townsend.gz`
    - South Asian (24 cases and 7861 controls)
      - `ukb24983_v2_hg19.s_asian.array-combined.covid19_test_result.glm.logistic.hybrid.BMI_Townsend.gz`
    - White British (388 cases and 336750 controls)
      - `ukb24983_v2_hg19.white_british.array-combined.covid19_test_result.glm.logistic.hybrid.BMI_Townsend.gz`
  - Recessive model
    - Meta-analysis of WB_NBW, African, and South Asian (in this order)
      - `ukb24983_v2_hg19.array-combined.covid19_test_result.recessive.metal.tsv.gz`
  - Severe cases
    - White British severe (331 cases and 299124 controls)
      - `ukb24983_v2_hg19.white_british.array-combined.covid19_severe.glm.logistic.hybrid.gz`
  - Exome analysis (hg38)
    - White British and non-British white (WB + NBW, 55 + 3 cases and 37029 controls)
      - `ukb24983_v2_hg38.WB_NBW.exome-spb.covid19_test_result.glm.logistic.hybrid.gz`
- GWAS summary statistics for disease assertation and mortality information for infectious diseases, and acute respiratory infections disease.
  - White British, `Tanigawa et al, disease` (19135 cases and 318003 controls)
    - `ukb24983_v2_hg19.white_british.array-combined.ICD_disease.glm.logistic.hybrid.gz`
  - White British , `Tanigawa et al, death` (1691 cases and 335447 controls)
    - `ukb24983_v2_hg19.white_british.array-combined.ICD_death.glm.logistic.hybrid.gz`
