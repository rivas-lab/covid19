fullargs <- commandArgs(trailingOnly=FALSE)
args <- commandArgs(trailingOnly=TRUE)

script.name <- normalizePath(sub("--file=", "", fullargs[grep("--file=", fullargs)]))

suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(data.table))

####################################################################
in_f  <- args[1]
out_d <- args[2]
####################################################################

df <- fread(in_f)
if(!'Count' %in% colnames(df)){
    # special treatment for the family-based study
    df$Count <- df$AlleleCount
}

# genes <- c('HLA-A',
# 'HLA-B',
# 'HLA-C',
# 'HLA-DPA1',
# 'HLA-DPB1',
# 'HLA-DQA1',
# 'HLA-DQB1',
# 'HLA-DRB1',
# 'HLA-DRB3',
# 'HLA-DRB4',
# 'HLA-DRB5')
genes <- df %>% pull(names(df)[1]) %>% unique()

for(gene in genes){
    if (!file.exists(file.path(out_d, gene))){
        dir.create(file.path(out_d, gene))
    }
    df %>%
    rename(!!str_replace(names(df)[1], '#', '') := names(df)[1] ) %>%
    filter(Locus == gene) %>%
    rename(!!'group' := names(df)[3] ) %>%
    select(Allele, group, Count) %>%
    spread(Allele, Count, fill=0) %>%
    left_join(    
        df %>%
        rename(!!str_replace(names(df)[1], '#', '') := names(df)[1] ) %>%
        rename(!!'group' := names(df)[3] ) %>%
        filter(Locus == gene) %>%
        group_by(group) %>%
        summarise(n = sum(Count)),
        by='group'
    ) %>%
    rename(!!sprintf('#%s', names(df)[3]) := 'group') %>%
    fwrite(file.path(out_d, gene, str_replace(basename(in_f), '.tsv$', '.wide.tsv')), sep='\t', na = "NA", quote=F)
}
