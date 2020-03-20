suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(data.table))

assign_ID_from_FID_IID <- function(df){
    df %>%
    mutate(ID = paste(FID, IID, sep='_')) %>%
    select(-FID, -IID)
}

compute_covar_score <- function(phe_df, covar_df){
    # compute covariate score    
    phe_df %>% 
    assign_ID_from_FID_IID() %>%
    column_to_rownames('ID') %>% 
    as.matrix() %*%
    as.matrix(covar_df %>% column_to_rownames('ID')) %>%
    as.data.frame() %>%
    rownames_to_column('ID') %>%
    separate('ID', c('FID', 'IID')) %>%
    rename('SCORE_covars' = 'BETA')
}

read_phe_and_scores <- function(phe_f, score_f, covar_score_f, trait, split.col='split'){
    phe_df <- fread(
        phe_f,
        select=c('FID', 'IID', split.col, trait),
        colClasses=c('FID'='character', 'IID'='character')
    ) %>%
    assign_ID_from_FID_IID() %>%
    rename('pheno' = trait) %>%
    mutate(pheno = na_if(pheno, -9))
    
    score_df <- fread(
        cmd=paste('zstdcat', score_f),
        select=c('#FID', 'IID', 'SCORE1_SUM'),
        colClasses=c('#FID'='character', 'IID'='character')
    ) %>%
    rename('FID' = '#FID', 'SCORE_geno' = 'SCORE1_SUM') %>%
    assign_ID_from_FID_IID() 
    
    covar_score_df <- fread(
        covar_score_f,
        select=c('#FID', 'IID', 'SCORE_covars'),
        colClasses=c('#FID'='character', 'IID'='character')    
    ) %>%
    rename('FID' = '#FID') %>%
    assign_ID_from_FID_IID()
    
    phe_df %>%
    left_join(score_df, by='ID') %>%
    left_join(covar_score_df, by='ID') %>%
    mutate(geno_and_covars = SCORE_geno + SCORE_covars) %>%
    rename('geno' = 'SCORE_geno', 'covars' = 'SCORE_covars') %>%
    select(ID, split, pheno, geno_and_covars, geno, covars) %>%
    drop_na(pheno)    
}

eval_r2 <- function(df, trait_name, splits = c('train', 'val', 'test'), scores = c('geno_and_covars', 'geno', 'covars')){
    metric_df <- lapply(splits, function(s){
        filtered <- df %>% filter(split == s)
        r2 <- lapply(scores, function(score_col){cor(filtered$pheno, filtered[[ score_col ]]) ^ 2})
        names(r2) <- paste(s, scores, sep='_')
        r2 %>% as.data.frame()
    }) %>% bind_cols()
    
    metric_df %>%
    mutate(
        trait = trait_name
    ) %>%
    select(c('trait', names(metric_df)))
}

round_cols_in_df <- function(df, cols, digits=3){
    for(col in cols){
        df[[ col ]] <- sprintf(paste0("%.", digits, "f"), df[[ col ]])
    }
    df
}
