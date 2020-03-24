# COVID-19 Host Genetics analysis

As a part of [COVID-19 Host Genetics Initiative](https://covid-19genehostinitiative.net/), we perform the following set of analyses to better understand the genetic basis of COVID-19 susceptibility and severity.

Please check out initial draft of host genetics of COVID-19, [Initial review and analysis of COVID-19 host genetics and associated phenotypes](https://www.preprints.org/manuscript/202003.0356/v1).

- [`UKB_HLA_freq`](/UKB_HLA_freq): HLA frequency in UK Biobank[2].
- [`ABO`](/ABO): The ABO blood type frequency in UK Biobank.
- [`snpnet`](/snpnet): Polygenic prediction of biomarkers and blood measurements. We deposit notebooks and scripts for polygenic risk score (PRS) analysis in this directory[3,4,5].
- [`PRS_PheWAS`](PRS_PheWAS): Application of blood measurement PRSs for disease risk prediction.

## Please share ABO blood type frequency in COVID-19 patients

We replicated recent findings in Zhao et al.[6] about the significant risk reduction of the blood group O across different control groups in UK Biobank. For a robust inference of risk factors, we would like to encourage a broad sharing of ABO blood type frequencies across (1) mild, (2) moderate, and (3) severe/critical COVID-19 cases at [https://tinyurl.com/abo-covid19](https://tinyurl.com/abo-covid19).

## Publicly available resources

- [PRS-PheWAS results](/PRS_PheWAS)
- [ABO blood type frequencies in UK Biobank](/ABO)
- [HLA allelotype frequencies in UK Biobank](/UKB_HLA_freq)
- [The weights for polygenic risk prediction](/snpnet)
  - The weights of PRSs are available at [Google Drive shared folder: https://bit.ly/rivas-lab_covid19_PRS_weights](https://bit.ly/rivas-lab_covid19_PRS_weights).
  - Please see the documentation in [`snpnet`](/snpnet) directory for more information.

## Note

This repo is a summary of joint effort for the community project from the Stanford Researchers and Clinicians, including (but not limited to) the following people: Yosuke Tanigawa, Marcelo Fernandez Vina, Euan Ashley, Carlos Bustamante, Julia Palacios, Benjamin Pinsky, Manuel A. Rivas.

## Acknowledgement

We thank [Stanford Research Computing Center](https://srcc.stanford.edu/) for [providing prioritized queue for COVID-19 research](http://news.sherlock.stanford.edu/posts/sherlock-joins-the-fight-against-covid-19)[7].

## Update log

- 2020/3/24: [Our initiral draft of write-up is now posted on preprints.org](https://www.preprints.org/manuscript/202003.0356/v1).
- 2020/3/23: We added the PRS evaluation plots and updated the documentation.
- 2020/3/22: We added results and source code for the PRS-PheWAS analysis [PRS_PheWAS](/PRS_PheWAS).
- 2020/3/22: We updated the documentation of the [ABO blood type analysis](/ABO).
- 2020/3/22: We made our initial draft of our host genetic analysis, [Initial review and analysis of COVID-19 host genetics and associated phenotypes](https://www.preprints.org/manuscript/202003.0356/v1) available at ~~Google Docs~~ (it is now available at Preprints.org).
- 2020/3/21: We added the [ABO blood type frequency reference](/ABO) across 9 population groups in UK Biobank (White British, Non-British white, African, South Asian, East Asian, self-reported Chinese, self-reported Indian, self-reported Pakistani, and self-reported Bangladeshi).
- 2020/3/20: We added a link to the [17th IHIW NGS HLA Data](http://17ihiw.org/17th-ihiw-ngs-hla-data/).
- 2020/3/19: We made an initial release of the polygenic risk score weights for 66 triats (blood measurements and biomarkers)! The weights of polygenic risk scores (PRSs) are available at [Google Drive shared folder: https://bit.ly/rivas-lab_covid19_PRS_weights](https://bit.ly/rivas-lab_covid19_PRS_weights). Please see [`snpnet`](/snpnet) directory for more information. We are still running the PRS computations and we will make an update release when we have improved results.
- 2020/3/17: We updated the [HLA fequency reference](/UKB_HLA_freq). It now includes the frequencies from 5 population groups.
- 2020/3/17: initial release!

## Reference

1. [Tanigawa, Y. & Rivas, M. Initial Review and Analysis of COVID-19 Host Genetics and Associated Phenotypes. (2020) doi:10.20944/preprints202003.0356.v1](https://www.preprints.org/manuscript/202003.0356/v1).
2. [McInnes, G. et al. Global Biobank Engine: enabling genotype-phenotype browsing for biobank summary statistics. Bioinformatics (2019)](https://doi.org/10.1093/bioinformatics/bty999).
3. [Qian, J. et al. A Fast and Flexible Algorithm for Solving the Lasso in Large-scale and Ultrahigh-dimensional Problems. bioRxiv 630079 (2019)](https://doi.org/doi:10.1101/630079).
4. [Sinnott-Armstrong, N. et al. Genetics of 38 blood and urine biomarkers in the UK Biobank. bioRxiv 660506 (2019)](https://doi.org/10.1101/660506).
5. [UK Biobank : Category 100081. Blood count - Blood assays - Assay results - Biological samples](http://biobank.ctsu.ox.ac.uk/crystal/label.cgi?id=100081).
6. [Zhao, J. et al. Relationship between the ABO Blood Group and the COVID-19 Susceptibility. medRxiv 2020.03.11.20031096 (2020)](https://doi.org/10.1101/2020.03.11.20031096).
7. [Sherlock joins the fight against COVID-19. Stanford Research Computing Center](http://news.sherlock.stanford.edu/posts/sherlock-joins-the-fight-against-covid-19).
