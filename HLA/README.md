# Worldwide population frequencies of HLA allelotypes

We chatacterize the HLA allelotype frequencies across different populations. We aggregate the allelotype frequencies from two resources: UK Biobank (four-digit HLA allelotype) and the [17th IHIW NGS HLA Data](http://17ihiw.org/17th-ihiw-ngs-hla-data/).

We have the [HLA map app](https://biobankengine.shinyapps.io/hla-map/)[1] for vidualization of the frequency data.

[![HLA map UKB country of birth](figs/HLA_map_UKB_country_of_birth_A0101.png)](https://biobankengine.shinyapps.io/hla-map/)

**Figure.** The worldwide population frequency of A*01:01 allele computed from the country of birth field in UK Biobank. Please visit [HLA map app](https://biobankengine.shinyapps.io/hla-map/) for interactive visualization.

The summary statistics (count and frequencies of HLA allelotypes) are available in this GitHub repository (please see the description below). We also have a brief description of this resource in our companion preprint, [Tanigawa, Y. & Rivas, M. Initial Review and Analysis of COVID-19 Host Genetics and Associated Phenotypes. Preprints.org (2020)](https://doi.org/10.20944/preprints202003.0356.v1)[2].

## Availalble datasets

We have the following files available as community resource. Please see the corresponding section below for more information.

- [`UKB.HLA.country_of_birth.tsv`](UKB.HLA.country_of_birth.tsv): HLA allelotype frequencies characterized for "country of birth" questionnaire answers in UK Biobank.
- [`UKB.HLA.PCA_pop.tsv`](UKB.HLA.PCA_pop.tsv): HLA allelotype frequencies characterized for 5 populations (White British, non-British white, African, South Asian, and East Asian).
- [`17ihiw-Unrelated-FQ.tsv`](17ihiw-Unrelated-FQ.tsv): HLA allelotype frequencies characterized for unrelated individuals in the [17th IHIW NGS HLA Data](http://17ihiw.org/17th-ihiw-ngs-hla-data/)
- [`17ihiw-Family-FQ.tsv`](17ihiw-Family-FQ.tsv): HLA allelotype frequencies characterized for families in the [17th IHIW NGS HLA Data](http://17ihiw.org/17th-ihiw-ngs-hla-data/)

## HLA allelotype frequencies in the UK Biobank

We provide the HLA allelotype frequencies in UK Biobank[3,4], which reports the imputed four-digit HLA allelotype for nearly 500,000 individuals. Specifically, we computed the allelotype frequencies based on the following two types of grouping definitions.

### Country of birth

We used the following two fields to extract the information on the country of birth[5,6].

- [Data-Field 20115: Country of Birth (non-UK origin)](http://biobank.ndph.ox.ac.uk/showcase/field.cgi?id=20115) ([Data-coding 89](http://biobank.ndph.ox.ac.uk/showcase/coding.cgi?id=89))
- [Data-Field 1647: Country of birth (UK/elsewhere)](http://biobank.ndph.ox.ac.uk/showcase/field.cgi?id=1647) ([Data-coding 100420](http://biobank.ndph.ox.ac.uk/showcase/coding.cgi?id=100420))

We focued on individuals with array genotype data, removed the individuals with participation withdrawal, and applied the following QC filters in sample QC file.

1. `putative_sex_chromosome_aneuploidy` (n = 652 individuals were removed)
2. `het_missing_outliers` (n = 968 individuals were removed)

We investegated the answers for the country of birth question and focused on individuals with consistent answer after removing uninformative options (such as do not know and prefer not to answer).

The answers for [Data-Field 20115: Country of Birth (non-UK origin)](http://biobank.ndph.ox.ac.uk/showcase/field.cgi?id=20115) are recorded in a hieralchical format with two levels and we tried to focus on the finest geographical resolutions. If, however, the number of individuals are less than 30 for a given country, we replaced the country name with the upper-level geographic region name.

We computed the allelotype frequency using `--geno-counts` subcommands in PLINK v2.00a3LM[7,8] and summarized the results in [`UKB.HLA.country_of_birth.tsv`](UKB.HLA.country_of_birth.tsv). This file has the following set of columns: `Locus`, `Allele` (to represent the four-digit allele), `country_of_birth`, `Frequency` (the allelotype frequency), and `Count` (the allelotype count).

### Our population definitions based on the genotype PCs

The allelotype frequencies are also computed for the **unrelated** sets of individuals in the following 5 populations.

- White British (`white_british`, N = 337,138)
- Non-British White (`non_british_white`, N = 24,905)
- South Asian (`s_asian`, N = 7,885)
- African (`african`, N = 6,497)
- East Asian (`e_asian`, N = 1,154)

Our population definitions are based on a combination of self-reported ethnicity data and genotype PCs provided by UK Biobank. Our sample QC procedure is described in our manuscript[9] (we have updated the definition since the initial draft of this manuscript and we are still preparing the updated manuscript at this moment).

We computed the allelotype frequency using `--geno-counts` subcommands in PLINK v2.00a3LM[7,8] and summarized the results in [`UKB.HLA.PCA_pop.tsv`](UKB.HLA.PCA_pop.tsv). This file has the following set of columns: `Locus`, `Allele` (to represent the four-digit allele), `PCA_pop` (PCA-based population), `Frequency` (the allelotype frequency), and `Count` (the allelotype count).

Our initial HLA allelotype association analysis using the White British population defined above is also briefly described in our paper[10].

## HLA allelotype frequencies in the [17th IHIW NGS HLA Data](http://17ihiw.org/17th-ihiw-ngs-hla-data/)

Using the [worldwide population frequencies in unrelated individuals and in families](http://17ihiw.org/17th-ihiw-ngs-hla-data/)[11,12] dataset, we prepared two tables, [`17ihiw-Unrelated-FQ.tsv`](17ihiw-Unrelated-FQ.tsv) and [`17ihiw-Family-FQ.tsv`](17ihiw-Family-FQ.tsv), for frequencies in unrelated individuals and in families, respectively. We thank Kazutoyo Osoegawa for reformatting and aggregating the 17th IHIW NGS HLA Data.

Those summary files have the following columns:

- [`17ihiw-Unrelated-FQ.tsv`](17ihiw-Unrelated-FQ.tsv): `Locus`, `Allele`, `Ethnicity`, `Frequency`, and `Count`
- [`17ihiw-Family-FQ.tsv`](17ihiw-Family-FQ.tsv): `Locus`, `Allele`, `Ethnicity/Country`, `Freq`, `AlleleCount` (observed allelotype count), `FamCount` (number of families included in the study), `and SampleCount` (number of subjects including children included in the study).

For example, the first 5 lies of [`17ihiw-Unrelated-FQ.tsv`](17ihiw-Unrelated-FQ.tsv) should look like this and they represent the allelotype counts and frequencies in the global population.

```{text}
#Locus  Allele  Ethnicity       Frequency       Count
HLA-A   A*02:01:01:01   Global  0.23311 2015
HLA-A   A*01:01:01:01   Global  0.13362 1155
HLA-A   A*03:01:01:01   Global  0.10805 934
HLA-A   A*24:02:01:01   Global  0.08017 693
```

### Notes on the HLA allelotype information

Here are additional description on the data generation and aggregation process.

- The frequency information in two files are equivalent, but are computed separately, for unrelated and family. In general, unrelated project had more samples, because selection criteria is simple, ethnicity for individual. For family study, we had to have parents and at least one child.
- In a perfect world, one parent has 2 HLA haplotypes information available, and the allelotype count should be 4 per family. In their study, they had families with only one parent, two children. In this case they "imputed" the second parents using the children's HLA genotypes. If the children had "shared" one haplotype from the missing parent, they could impute only one allele. In this scenario, we had only three haplotypes per family. That's why the number of these are off from the perfect world scenario.
- The allelotype frequencies in family study is calculated by treating "parents" as unrelated individuals.
- For unrelated study, haplotypes were built using Expectation-Maximization (EM) algorithm, while family study, they were built using HLA allele inheritance.
- For more information, please check the [17th IHIW NGS HLA Data](http://17ihiw.org/17th-ihiw-ngs-hla-data/) website and their README files for [frequencies in unrelated individuals](http://17ihiw.org/wp-content/uploads/2018/10/Readme-Unrelated-HLA-allele-and-haplotypes-FQ-tables_072318.pdf) and [frequencies in families](http://17ihiw.org/wp-content/uploads/2018/10/Readme-Family-HLA-allele-and-haplotypes-FQ-tables.pdf). Specifically, you may find it useful to check out the README files abbreviations for the ethnicity and country.

## Acknowledgement

We thank Marcelo Fernandez-Vina and Euan Ashley for providing the information about the 17th IHIW NGS HLA Data. We thank Kazutoyo Osoegawa for reformatting and aggregating the 17th IHIW NGS HLA Data.

## Reference

1. [Tanigawa, Y. & Rivas, M. Initial Review and Analysis of COVID-19 Host Genetics and Associated Phenotypes. Preprints.org (2020)](https://doi.org/10.20944/preprints202003.0356.v1).
2. [Tanigawa, Y., Osoegawa, K. et al. HLA Map. Shiny Apps](https://biobankengine.shinyapps.io/hla-map/).
3. [UK Biobank: Data-Field 22182, HLA imputation values. HLA - Genotypes - Genomics](http://biobank.ctsu.ox.ac.uk/crystal/field.cgi?id=22182).
4. [UK Biobank: Resource 182: Imputation of classical HLA types](http://biobank.ctsu.ox.ac.uk/crystal/crystal/docs/HLA_imputation.pdf).
5. [UK Biobank: Data-Field 20115: Country of Birth (non-UK origin). Early life factors - Verbal interview - UK Biobank Assessment Centre](http://biobank.ndph.ox.ac.uk/showcase/field.cgi?id=20115)
6. [UK Biobank: Data-Field 1647: Country of birth (UK/elsewhere). Early life factors - Verbal interview - UK Biobank Assessment Centre](http://biobank.ndph.ox.ac.uk/showcase/field.cgi?id=1647)
7. [Chang, C. C. et al. Second-generation PLINK: rising to the challenge of larger and richer datasets. Gigascience 4, (2015)](https://doi.org/10.1186/s13742-015-0047-8).
8. [PLINK 2.0](https://www.cog-genomics.org/plink/2.0/).
9. [Sinnott-Armstrong, N. et al. Genetics of 38 blood and urine biomarkers in the UK Biobank. bioRxiv 660506 (2019)](https://doi.org/10.1101/660506).
10. [McInnes, G. et al. Global Biobank Engine: enabling genotype-phenotype browsing for biobank summary statistics. Bioinformatics (2019)](https://doi.org/10.1093/bioinformatics/bty999).
11. [17th IHIW NGS HLA Data | 17th International HLA and Immunogenetics Workshop](http://17ihiw.org/17th-ihiw-ngs-hla-data/).
12. [Osoegawa, K. et al. HLA Haplotype Validator for quality assessments of HLA typing. Human Immunology 77, 273–282 (2016)](https://doi.org/10.1016/j.humimm.2015.10.018).
