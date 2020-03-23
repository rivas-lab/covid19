fullargs <- commandArgs(trailingOnly=FALSE)
args <- commandArgs(trailingOnly=TRUE)

script.name <- normalizePath(sub("--file=", "", fullargs[grep("--file=", fullargs)]))

suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(data.table))


data_dir <- '@@@@@@@@@@@@@@@@@@@'
prs_f <- file.path(data_dir, 'snpnet.PRS.tsv.zst')
phe_f <- file.path(data_dir, 'phewas_int_phe.tsv.zst')
phewas_res_f <- file.path(data_dir, 'phewas.white_british.full.tsv')
PheWAS_traits_f <- 'PRS_PheWAS.phenotypes.tsv'

covariates <- c('age', 'sex', 'N_CNV', 'LEN_CNV', 'Array', paste0('PC', 1:10))
percentiles <- c(.01, .05, .95, .99)

####################################################################
source(file.path(dirname(script.name), 'PRS_PheWAS_functions.R'))
####################################################################

PheWAS_traits <- fread(PheWAS_traits_f, sep='\t') %>%
rename('GBE_ID' = '#GBE_ID')

prs_df <- fread(cmd=paste('zstdcat', prs_f), colClasses=c('#FID'='character', 'IID'='character')) %>%
rename('FID' = '#FID')

phe_df <- fread(cmd=paste('zstdcat', phe_f), colClasses=c('#FID'='character', 'IID'='character')) %>%
rename('FID' = '#FID')

df <- phe_df %>%
full_join(prs_df, by=c('FID', 'IID'))

pop_df <- df %>%
filter(population == 'white_british') 

# PRS_cols <- colnames(prs_df)[3:5]
# PRS_cols <- colnames(prs_df)[3:ncol(prs_df)] # all traits
PRS_cols <- colnames(prs_df)[3:31] # blood only

# phenotypes <- c('INI23000', 'INI23001')
phenotypes <- PheWAS_traits$GBE_ID

phewas_res_df <- pop_df %>%
phewas_loop(phenotypes, PRS_cols, percentiles)

phewas_res_df %>%
rename('#phenotype' = 'phenotype') %>%
fwrite(phewas_res_f, sep='\t', na = "NA", quote=F)
