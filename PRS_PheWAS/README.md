# PRS-PheWAS

We assessed association between blood measurement traits polygenic risk scores (PRSs) and i) infection disease risk, and ii) acute respiratory infection, acute respiratory distress syndrome, influenza and pneumonia hospitalization and death risk. We focused on 44 disease antigen measurements (listed in [`UKB_Category_1307.tsv`](UKB_Category_1307.tsv))[1], infectious diseases and acute respiratory infections (ICD-10 codes corresponding to J00-J06, J09-J18, J80, and J20-J22), and deaths in UK Biobank.

Please check out initial draft of host genetics of COVID-19, [Initial review and analysis of COVID-19 host genetics and associated phenotypes](https://doi.org/10.20944/preprints202003.0356.v1).

## List of files in this directory

### Results files

- [`PRS_PheWAS.phenotypes.tsv`](PRS_PheWAS.phenotypes.tsv): the list of disease antigen phenotypes used in the study. It has sample size counts (`N`) across different population definitions in the Rivas Lab.
- [`phewas.white_british.summary.tsv`](phewas.white_british.summary.tsv): this table has the results for PRS-PheWAS across 44 disease antigens.
- [`phewas.white_british.icd.summary.tsv`](phewas.white_british.icd.summary.tsv): this table has the accosiaion results for the diseases and deaths of the infectious diseases and acute respiratory infections.
- [`PRS.icd.OR.summary.tsv`](PRS.icd.OR.summary.tsv): this table contains the odds ratio across PRS percentile bins computed for diseases and deaths of the infectious diseases and acute respiratory infections. The corresponding figures are in [`figs`](figs) directory.

### Scripts and notebook

- [`1_master_PRS_file.R`](1_master_PRS_file.R): this script combines the PRS files and prepare as a "master PRS" file.
- [`2_PRS_PheWAS_phenotype.ipynb`](2_PRS_PheWAS_phenotype.ipynb): from the list of UK Biobank Field IDs (listed in [`UKB_Category_1307.tsv`](UKB_Category_1307.tsv)), this script identifies the corresponding set of phenotypes and write it to a file ([`PRS_PheWAS.phenotypes.tsv`](PRS_PheWAS.phenotypes.tsv)).
- [`3_int_PheWAS_phenotypes.R`](3_int_PheWAS_phenotypes.R): this script applies the inverse-normal transformation to the phenotypes.
- [`4_PRS_PheWAS.R`](4_PRS_PheWAS.R): this script pefroms the PRS-PheWAS analysis across 44 disease antigen measurements.
- [`5_PRS_PheWAS_summary.ipynb`](5_PRS_PheWAS_summary.ipynb): summarize the results from PRS-PheWAS and write it to a file.
- [`6_define_phe_from_ICD10.R`](6_define_phe_from_ICD10.R): this script defines disease and mortality phenotypes for infectious diseases and acute respiratory infections (ICD-10 codes corresponding to J00-J06, J09-J18, J80, and J20-J22).
- [`7_additional_PheWAS.ipynb`](7_additional_PheWAS.ipynb): this notebook performs the PheWAS analysis for the disease and death traits.
- [`PRS_PheWAS_functions.R`](PRS_PheWAS_functions.R): a helper files with functions used in the analysis in this directory.

## Reference

1. [UK Biobank : Category 1307. Infectious Disease Antigens - Infectious Diseases - Blood assays - Assay results - Biological samples](http://biobank.ctsu.ox.ac.uk/crystal/label.cgi?id=1307).
