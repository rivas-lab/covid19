fullargs <- commandArgs(trailingOnly=FALSE)
args <- commandArgs(trailingOnly=TRUE)

script.name <- normalizePath(sub("--file=", "", fullargs[grep("--file=", fullargs)]))

suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(data.table))

####################################################################
in_f  <- args[1]
out_f <- args[2]
####################################################################

df <- fread(in_f)
if(!'Count' %in% colnames(df)){
    # special treatment for the family-based study
    df$Count <- df$AlleleCount
}

df %>%
rename(!!str_replace(names(df)[1], '#', '') := names(df)[1] ) %>%
rename(!!'group' := names(df)[3] ) %>%
select(Allele, group, Count) %>%
spread(Allele, Count, fill=0) %>%
left_join(    
    df %>%
    rename(!!str_replace(names(df)[1], '#', '') := names(df)[1] ) %>%
    rename(!!'group' := names(df)[3] ) %>%
    group_by(Locus, group) %>%
    summarise(n = sum(Count)) %>%
    spread(Locus, n, fill=0),
    by='group'
) %>%
rename(!!sprintf('#%s', names(df)[3]) := 'group') %>%
fwrite(out_f, sep='\t', na = "NA", quote=F)
