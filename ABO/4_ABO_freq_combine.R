suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(data.table))

source('ABO_functions.R')

ABO_UKB_freq_file <- 'ABO_UKB_freq.tsv'
ABO_external_freq_file <- 'ABO_external_studies_freq.tsv'
pop_cnt_file <- 'UKB_population_n.tsv'

ABO_combined_freq_file <- 'ABO_combined_freq.tsv'

#####################
ABO_haplotype_freq <-
fread(ABO_UKB_freq_file, sep='\t') %>%
rename('population' = '#population')

Case_freq <- fread(ABO_external_freq_file) %>%
rename('population' = '#population') %>%
rename('nA'='A', 'nB'='B', 'nAB'='AB', 'nO'='O') %>%
mutate(A = nA/n, B = nB/n, AB=nAB/n, O=nO/n)

UKB_pop_cnt <- get_pop_cnt(pop_cnt_file)

UKB_pheno_freqs <- list()

for(pop in names(UKB_pop_cnt)){
    UKB_pheno_freqs[[ pop ]] <-
    ABO_haplotype_freq %>%
    filter(population == pop) %>%
    compute_pheno_freq()    
}

freqs <- UKB_pheno_freqs %>% 
as.data.frame() %>% 
as.matrix() %>% 
t() %>% 
as.data.frame() %>%
rownames_to_column('population') %>%
left_join(
    data.frame(n = UKB_pop_cnt) %>%
    rownames_to_column('population'), 
    by='population'
) %>%
mutate(population = paste('UKB', population, sep='_')) %>%
bind_rows(Case_freq %>% select(population, A, B, AB, O, n))

freqs %>% 
rename('#population' = 'population') %>%
fwrite(ABO_combined_freq_file, sep='\t', na = "NA", quote=F)