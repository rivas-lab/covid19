fullargs <- commandArgs(trailingOnly=FALSE)
args <- commandArgs(trailingOnly=TRUE)

script.name <- normalizePath(sub("--file=", "", fullargs[grep("--file=", fullargs)]))

suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(data.table))

snpnet_src_dir <- file.path(dirname(dirname(script.name)), 'snpnet')

####################################################################
source(file.path(snpnet_src_dir, 'functions.R'))
####################################################################

snpnet_data_dir <- '@@@@@@@@@@@@@@@@@@@'
maste_PRS_f <- '@@@@@@@@@@@@@@@@@@@'

####################################################################

phe_info_f <- file.path(snpnet_src_dir, 'pheno.info.tsv')
phe_info_df <- fread(phe_info_f) %>% rename('GBE_ID' = '#GBE_ID')

traits <- phe_info_df$GBE_ID

prs_df <- lapply(
    traits,
    function(trait){
        prs_df <- 
        file.path(snpnet_data_dir, trait, paste0(trait, '.sscore.zst')) %>%
        read_PRS_score()
        colnames(prs_df) <- c('ID', trait)
        prs_df
    }
) %>%
reduce(function(x, y){x %>% inner_join(y, by='ID')}) %>%
separate(ID, c('FID', 'IID'), sep='_')

new.colnames <- c(
    colnames(prs_df)[1:2], 
    paste(colnames(prs_df)[3:ncol(prs_df)], 'PRS', sep='_')
)

colnames(prs_df) <- new.colnames

prs_df %>%
rename('#FID'='FID') %>%
fwrite(maste_PRS_f, sep='\t', na = "NA", quote=F)
