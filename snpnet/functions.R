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

read_phe <- function(phe_f, trait, split.col='split'){
    fread(
        phe_f,
        select=c('FID', 'IID', split.col, trait),
        colClasses=c('FID'='character', 'IID'='character')
    ) %>%
    assign_ID_from_FID_IID() %>%
    rename('pheno' = trait) %>%
    mutate(pheno = na_if(pheno, -9))
}

read_PRS_score <- function(score_f){
    fread(
        cmd=paste('zstdcat', score_f),
        select=c('#FID', 'IID', 'SCORE1_SUM'),
        colClasses=c('#FID'='character', 'IID'='character')
    ) %>%
    rename('FID' = '#FID', 'SCORE_geno' = 'SCORE1_SUM') %>%
    assign_ID_from_FID_IID() %>%
    select(ID, SCORE_geno)
}

read_phe_and_scores <- function(phe_f, score_f, covar_score_f, trait, split.col='split'){
    phe_df <- read_phe(phe_f, trait, split.col)

    score_df <- read_PRS_score()
    
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

### functions for evaluation (PRS bin vs. OR and mean)

compute_mean <- function(df, percentile_col, phe_col, l_bin, u_bin){
    # Compute the mean and sd of the trait value (phe_col), based on the
    # binning (l_bin, u_bin] with the percentile of PRS (percentile_col)
    stratified_df <- df %>%
    rename(Percentile = percentile_col, phe = phe_col) %>%
    filter(l_bin < Percentile, Percentile <= u_bin)

    n     <- stratified_df %>% nrow()
    mean  <- stratified_df %>% select(phe) %>% pull() %>% mean()
    sd    <- stratified_df %>% select(phe) %>% pull() %>% sd()
    std_e <- sd / sqrt(n)
    l_err <- mean - std_e
    u_err <- mean + std_e

    data.frame(
        l_bin = l_bin,
        u_bin = u_bin,
        mean   = mean,
        std_err = std_e,
        l_err = l_err,
        u_err = u_err,
        mean_str = sprintf('%.3f (%.3f-%.3f)', mean, l_err, u_err),
        bin_str = paste0(100 * l_bin, '% - ', 100 * u_bin, '%'),
        stringsAsFactors=F
    ) %>%
    mutate(mean_str = as.character(mean_str))
}

filter_by_percentile_and_count_phe <- function(df, percentile_col, phe_col, l_bin, u_bin){
    # a helper function for compute_OR. 
    # This provides the counts of the descrete phenotype value (phe_col)
    # for the specified bin (l_bin, u_bin], based on the percentile of PRS (percentile_col)
    df %>% 
    rename(Percentile = percentile_col, phe = phe_col) %>%
    filter(l_bin < Percentile, Percentile <= u_bin) %>% 
    count(phe)
}

compute_OR <- function(df, percentile_col, phe_col, l_bin, u_bin, cnt_middle){
    # Compute the OR and sd of the trait value (phe_col), based on the
    # binning (l_bin, u_bin] with the percentile of PRS (percentile_col)
    # The odds ratio is defined against the "middle" of the PRS distribution, and
    # we assume to have the phenotype counts in that bin (cnt_middle)
    cnt_tbl <- df %>% 
    filter_by_percentile_and_count_phe(percentile_col, phe_col, l_bin, u_bin) %>%
    inner_join(cnt_middle, by='phe') %>% 
    gather(bin, cnt, -phe) %>% arrange(-phe, bin)
        
    cnt_res <- cnt_tbl %>% mutate(cnt = as.numeric(cnt)) %>% select(cnt) %>% pull()
    names(cnt_res) <- c('n_TP', 'n_FN', 'n_FP', 'n_TN')
        
    OR <- (cnt_res[['n_TP']] * cnt_res[['n_TN']]) / (cnt_res[['n_FP']] * cnt_res[['n_FN']])
    LOR <- log(OR)    
    se_LOR <- cnt_tbl %>% select(cnt) %>% pull() %>% 
    lapply(function(x){1/x}) %>% reduce(function(x, y){x+y}) %>% sqrt()
    l_OR = exp(LOR - 1.96 * se_LOR)
    u_OR = exp(LOR + 1.96 * se_LOR)
        
    data.frame(
        l_bin = l_bin,
        u_bin = u_bin,
        n_TP = cnt_res[['n_TP']],
        n_FN = cnt_res[['n_FN']],
        n_FP = cnt_res[['n_FP']],
        n_TN = cnt_res[['n_TN']],
        OR   = OR,
        SE_LOR = se_LOR,
        l_OR = l_OR,
        u_OR = u_OR,
        OR_str = sprintf('%.3f (%.3f-%.3f)', OR, l_OR, u_OR),
        bin_str = paste0(100 * l_bin, '% - ', 100 * u_bin, '%'),
        stringsAsFactors=F
    )
}

compute_summary_OR_df <- function(df, percentile_col, phe_col, bins=((0:10)/10)){
    cnt_middle <- df %>% 
    filter_by_percentile_and_count_phe(percentile_col, phe_col, 0.4, 0.6) %>%
    rename('n_40_60' = 'n')

    1:(length(bins)-1) %>%
    lapply(function(i){
        compute_OR(df, percentile_col, phe_col, bins[i], bins[i+1], cnt_middle)
    }) %>%
    bind_rows()
}

compute_summary_mean_df <- function(df, percentile_col, phe_col, bins=c(0, .0005, .01, (1:19)/20, .99, .9995, 1)){
    1:(length(bins)-1) %>%
    lapply(function(i){
        compute_mean(df, percentile_col, phe_col, bins[i], bins[i+1])
    }) %>%
    bind_rows()
}

compute_summary_df <- function(df, percentile_col, phe_col, bins=c(0, .0005, .01, (1:19)/20, .99, .9995, 1), metric='mean'){
    if(metric == 'mean'){
        compute_summary_mean_df(df, percentile_col, phe_col, bins)
    }else if(metric == 'OR'){
        compute_summary_OR_df(df, percentile_col, phe_col, bins)
    }else{
        stop(sprintf('metric %s is not supported!', metric))
    }
}

### functions for plotting

plot_PRS_vs_phe <- function(plot_df, plot_bin2d_x=0.05, plot_bin2d_y=NULL){
    if(is.null(plot_bin2d_y)){
        plot_bin2d_y <- diff(quantile(plot_df$pheno, c(.4, .6))) / 4
    }
    plot_df %>%
    filter(
        # 99.9% coverage
        quantile(plot_df$pheno, .0005) < pheno,
        quantile(plot_df$pheno, .9995) > pheno
    ) %>%
    ggplot(aes(x = SCORE_geno_z, y = pheno)) +
    geom_bin2d(binwidth = c(plot_bin2d_x, plot_bin2d_y)) +
    scale_fill_continuous(type = "viridis") +
    theme_bw()
}

plot_PRS_bin_vs_phe <- function(summary_plot_df, horizontal_line){
    summary_plot_df %>%
    mutate(x_ticks_labels = paste0('[', bin_str, ']')) %>%
    ggplot(aes(x=reorder(x_ticks_labels, -u_bin), y=mean)) +
    geom_point() +
    geom_errorbar(aes(ymin = l_err, ymax = u_err)) +
    geom_hline(yintercept = horizontal_line, color='gray')+
    theme_bw() +
    theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust=.5))
}
