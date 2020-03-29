fullargs <- commandArgs(trailingOnly=FALSE)
args <- commandArgs(trailingOnly=TRUE)

script.name <- normalizePath(sub("--file=", "", fullargs[grep("--file=", fullargs)]))

suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(data.table))
suppressPackageStartupMessages(library(googlesheets))

####################################################################
in_f  <- args[1]
out_f <- args[2]
gs_token <- args[3]
gs_sheet <- args[4]
####################################################################

gs_auth(token = gs_token)

map_df <- gs_sheet %>% gs_url() %>% 
gs_read(ws = 'summarize.to.2digits.alleles') %>% 
mutate(Locus = paste0('HLA-', Locus)) %>%
select(-revisit)

df <- fread(in_f)
df %>%
rename(!!str_replace(names(df)[1], '#', '') := names(df)[1] ) %>%
rename(group = names(df)[3]) %>%
filter(Locus != 'ABS') %>%
mutate(
    Allele = str_replace_all(Allele, 'HLA-', '')
) %>%
left_join(
    map_df,
    by=c('Locus', 'Allele')
) %>%
mutate(Allele = Allele2digit) %>%
select(-Allele2digit)%>%
group_by(Locus, group, Allele) %>%
summarise_at(names(df)[4:ncol(df)], sum, na.rm = TRUE) %>%
ungroup() %>%
rename(!!names(df)[3] := 'group') %>%
filter(Locus != 'ABS') %>%
rename(!!names(df)[1] := str_replace(names(df)[1], '#', '')) %>%
select(names(df)) %>%
fwrite(out_f, sep='\t', na = "NA", quote=F)
