fullargs <- commandArgs(trailingOnly=FALSE)
args <- commandArgs(trailingOnly=TRUE)

script.name <- normalizePath(sub("--file=", "", fullargs[grep("--file=", fullargs)]))

suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(data.table))

####################################################################
source(file.path(dirname(script.name), 'functions.R'))
####################################################################

phe_info_f   <- args[1]
metric_tmp_f <- args[2]
metric_f     <- args[3]

metric_df <- fread(
    metric_tmp_f,
    col.names = c(
        'trait', 
        'train_geno_and_covars',
        'train_geno',
        'train_covars',
        'val_geno_and_covars',
        'val_geno',
        'val_covars',
        'test_geno_and_covars',
        'test_geno',
        'test_covars'
    )
)

metric_df <- fread(phe_info_f) %>%
rename('GBE_ID' = '#GBE_ID') %>%
mutate(dataset = if_else(GBE_ID == pheno, 'biomarkers', 'blood')) %>%
left_join(metric_df, by=c('GBE_ID' = 'trait'))

# prepare a simplified table for each dataset (biomarkers and blood)
summary_df <- list()
for(d in unique(metric_df$dataset)){
    summary_df[[ d ]] <- metric_df %>%
    filter(dataset == d) %>%
    select(pheno_plot, test_geno_and_covars, test_geno, test_covars) %>%
    rename(
        'geno_and_covars' = 'test_geno_and_covars',
        'geno'            = 'test_geno',
        'covars'          = 'test_covars'
    ) %>%
    rename('phenotype' = 'pheno_plot') %>%
    round_cols_in_df(c('geno_and_covars', 'geno', 'covars'))
}

# write the results to file
metric_df %>% 
rename('#GBE_ID' = 'GBE_ID') %>%
select(-Units_of_measurement) %>%
fwrite(metric_f, sep='\t', na = "NA", quote=F)

for(d in unique(metric_df$dataset)){
    summary_df[[ d ]] %>%
    rename('#phenotype' = 'phenotype') %>%
    fwrite(
        str_replace(metric_f, '.R2', sprintf('.summary.%s', d)),
        sep='\t'
    )
}
