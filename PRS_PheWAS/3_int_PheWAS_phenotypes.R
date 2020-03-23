suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(data.table))

master_phe_f <- '@@@@@@@@@@@@@@@@@@@'
gwas_covar_f <- '@@@@@@@@@@@@@@@@@@@'
phewas_int_phe_f <- '@@@@@@@@@@@@@@@@@@@'

apply_int <- function(df, trait){
    # apply inverse normal transformation.
    df_int <-  df %>%
    rename('trait' = trait) %>%
    select(FID, IID, population, trait) %>%
    drop_na(trait, population) %>%
    group_by(population) %>% 
    mutate(trait=qnorm(1-rank(-trait)/n())) %>%
    ungroup()%>%
    select(FID, IID, trait)
    colnames(df_int) <- c('FID', 'IID', trait)
    df_int
}

PheWAS_traits <- 
fread('PRS_PheWAS.phenotypes.tsv', sep='\t') %>%
rename('GBE_ID' = '#GBE_ID')

master_phe_df <- fread(
    master_phe_f,
    select=c('FID', 'IID', sort(PheWAS_traits$GBE_ID)),
    colClasses=c('FID'='character', 'IID'='character')
) %>%
mutate_if(is.numeric, list(~na_if(.,-9)))

gwas_covar_df <- fread(
    gwas_covar_f,
    select=c('FID', 'IID', 'population', 'split', 'age', 'sex', 'N_CNV', 'LEN_CNV', 'Array', paste0('PC', 1:10)),
    colClasses=c('FID'='character', 'IID'='character')
)

df <- gwas_covar_df %>%
left_join(master_phe_df, by=c('FID', 'IID'))

int_df <- gwas_covar_df %>%
left_join(
    sort(PheWAS_traits$GBE_ID) %>%
    lapply(
        function(trait){apply_int(df, trait)}
    ) %>% 
    reduce(function(x, y){x %>% full_join(y, by=c('FID', 'IID'))}), 
    by=c('FID', 'IID')
)

int_df %>%
rename('#FID' = 'FID') %>%
fwrite(phewas_int_phe_f, sep='\t', na = "NA", quote=F)
