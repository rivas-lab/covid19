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

df %>%
rename(!!str_replace(names(df)[1], '#', '') := names(df)[1] ) %>%
rename(group = names(df)[3]) %>%
mutate(
    Allele_locus = str_replace(Allele, '\\*[0-9:]+', ''),
    Allele_digits = str_replace(Allele, sprintf('%s\\*', Allele_locus), '')
) %>%
mutate(
    Allele = sprintf('%s*%s', Allele_locus, str_sub(Allele_digits, 1, 2)),
) %>%
select(-Allele_locus, -Allele_digits) %>%
group_by(Locus, group, Allele) %>%
summarise_at(names(df)[4:ncol(df)], sum, na.rm = TRUE) %>%
ungroup() %>%
rename(!!names(df)[3] := 'group') %>%
rename(!!names(df)[1] := str_replace(names(df)[1], '#', '')) %>%
select(names(df)) %>%
fwrite(out_f, sep='\t', na = "NA", quote=F)
