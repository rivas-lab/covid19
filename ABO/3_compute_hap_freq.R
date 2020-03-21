fullargs <- commandArgs(trailingOnly=FALSE)
args <- commandArgs(trailingOnly=TRUE)

script.name <- normalizePath(sub("--file=", "", fullargs[grep("--file=", fullargs)]))

suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(data.table))

####################################################################
source(file.path(dirname(script.name), 'ABO_functions.R'))
####################################################################

pop_cnt_file <- args[1]
hap_freq_dir <- args[2]
hap_freq_tsv <- args[3]

pop_cnt <- get_pop_cnt(pop_cnt_file) 
ABO_haplotype_freq <- pop_cnt %>%
names() %>%
read_ABO_hap_freq(hap_freq_dir, pop_cnt)

ABO_haplotype_freq %>%
rename('#population' = 'population') %>%
fwrite(hap_freq_tsv, sep='\t', na = "NA", quote=F)
