# COVID-19 Host Genetics analysis

As a part of [COVID-19 Host Genetics Initiative](https://covid-19genehostinitiative.net/), we perform the following set of analyses to better understand the genetic basis of COVID-19 susceptibility and severity.

Please check out initial draft of host genetics of COVID-19, [Initial review and analysis of COVID-19 host genetics and associated phenotypes](https://tinyurl.com/genes-covid19) (it is now hosted on Google Docs -- we submitted the manuscript to a pre-print server).

- [`UKB_HLA_freq`](/UKB_HLA_freq): HLA frequency in UK Biobank[1].
- [`ABO`](/ABO): The ABO blood type frequency in UK Biobank.
- [`snpnet`](/snpnet): Polygenic prediction of biomarkers and blood measurements. We deposit notebooks and scripts for polygenic risk score (PRS) analysis in this directory[2,3,4].
- [`PRS_PheWAS`](PRS_PheWAS): Application of blood measurement PRSs for disease risk prediction.

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

We thank [Stanford Research Computing Center](https://srcc.stanford.edu/) for [providing prioritized queue for COVID-19 research](http://news.sherlock.stanford.edu/posts/sherlock-joins-the-fight-against-covid-19)[5].

## Update log

- 2020/3/22: We add results and source code for the PRS-PheWAS analysis [PRS_PheWAS](/PRS_PheWAS).
- 2020/3/22: We updated the documentation of the [ABO blood type analysis](/ABO).
- 2020/3/22: We made our initial draft of our host genetic analysis, [Initial review and analysis of COVID-19 host genetics and associated phenotypes](https://tinyurl.com/genes-covid19) (it is now hosted on Google Docs -- we submitted the manuscript to a pre-print server).
- 2020/3/21: We added the [ABO blood type frequency reference](/ABO) across 9 population groups in UK Biobank (White British, Non-British white, African, South Asian, East Asian, self-reported Chinese, self-reported Indian, self-reported Pakistani, and self-reported Bangladeshi).
- 2020/3/20: We added a link to the [17th IHIW NGS HLA Data](http://17ihiw.org/17th-ihiw-ngs-hla-data/).
- 2020/3/19: We made an initial release of the polygenic risk score weights for 66 triats (blood measurements and biomarkers)! The weights of polygenic risk scores (PRSs) are available at [Google Drive shared folder: https://bit.ly/rivas-lab_covid19_PRS_weights](https://bit.ly/rivas-lab_covid19_PRS_weights). Please see [`snpnet`](/snpnet) directory for more information. We are still running the PRS computations and we will make an update release when we have improved results.
- 2020/3/17: We updated the [HLA fequency reference](/UKB_HLA_freq). It now includes the frequencies from 5 population groups.
- 2020/3/17: initial release!

## Reference

1. [McInnes, G. et al. Global Biobank Engine: enabling genotype-phenotype browsing for biobank summary statistics. Bioinformatics (2019)](https://doi.org/10.1093/bioinformatics/bty999).
2. [Qian, J. et al. A Fast and Flexible Algorithm for Solving the Lasso in Large-scale and Ultrahigh-dimensional Problems. bioRxiv 630079 (2019)](https://doi.org/doi:10.1101/630079).
3. [Sinnott-Armstrong, N. et al. Genetics of 38 blood and urine biomarkers in the UK Biobank. bioRxiv 660506 (2019)](https://doi.org/10.1101/660506).
4. [UK Biobank : Category 100081. Blood count - Blood assays - Assay results - Biological samples](http://biobank.ctsu.ox.ac.uk/crystal/label.cgi?id=100081).
5. [Sherlock joins the fight against COVID-19. Stanford Research Computing Center](http://news.sherlock.stanford.edu/posts/sherlock-joins-the-fight-against-covid-19).
