fullargs <- commandArgs(trailingOnly=FALSE)
args <- commandArgs(trailingOnly=TRUE)

script.name <- normalizePath(sub("--file=", "", fullargs[grep("--file=", fullargs)]))

suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(data.table))

####################################################################
source(file.path(dirname(script.name), 'functions.R'))
####################################################################

eval_main <- function(phe_f, score_f, covar_score_f, trait, eval_f){
    # 
    # Input
    #   - phe_f:          phenotype file
    #   - covar_betas :   the BETAs for covariates
    # Output 
    #   - covar_score_f : covariate score
    #
    phe_df <- read_phe_and_scores(phe_f, score_f, covar_score_f, trait)
    
    eval_res <- eval_r2(phe_df, trait_name = trait)
    
    eval_res %>%
    rename('#trait' = 'trait') %>%
    fwrite(eval_f, sep='\t')    
}

eval_main(
    phe_f=args[1], 
    score_f=args[2],
    covar_score_f=args[3],
    trait=args[4],
    eval_f=args[5]
)
