fullargs <- commandArgs(trailingOnly=FALSE)
args <- commandArgs(trailingOnly=TRUE)

script.name <- normalizePath(sub("--file=", "", fullargs[grep("--file=", fullargs)]))

suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(data.table))

####################################################################
source(file.path(dirname(script.name), 'functions.R'))
####################################################################

covar_score_main <- function(phe_f, covar_betas, covar_score_f){
    # 
    # Input
    #   - phe_f:          phenotype file
    #   - covar_betas :   the BETAs for covariates
    # Output 
    #   - covar_score_f : covariate score
    #
    covar_df <- fread(covar_betas)
    
    phe_df <- fread(
        phe_f,
        select=c('FID', 'IID', covar_df$ID),
        colClasses=c('FID'='character', 'IID'='character')
    )
    
    phe_df %>%
    compute_covar_score(covar_df) %>%
    rename('#FID' = 'FID') %>%
    fwrite(covar_score_f, sep='\t')    
}

covar_score_main(
    phe_f=args[1], 
    covar_betas=args[2], 
    covar_score_f=args[3]
)
