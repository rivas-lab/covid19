suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(data.table))

# input
icd_master_f <- '@@@@@@@@@@@@@@@@@@@'
gwas_covar_f <- '@@@@@@@@@@@@@@@@@@@'

# output
icd_phe_f <- '@@@@@@@@@@@@@@@@@@@'

icd10_pattern <- c(0:6, 9:18, 80, 20:22) %>%
lapply(function(x){sprintf('J%02d', x)})

#######################################

icd_master_df <- fread(cmd=paste('zstdcat', icd_master_f, colClasses=c('#IID'='character'))) %>%
rename('IID'='#IID')

IID_disease_cases <- icd_master_df %>%
filter(field %in% c(41201, 41202, 41204, 41270)) %>%
filter(str_detect(val, paste(paste0('^', icd10_pattern), collapse='|'))) %>%
select(IID) %>% unique() %>% pull()

IID_death_cases <- icd_master_df %>%
filter(field %in% c(40001, 40002)) %>%
filter(str_detect(val, paste(paste0('^', icd10_pattern), collapse='|'))) %>%
select(IID) %>% unique() %>% pull()

# c(length(IID_disease_cases), length(IID_death_cases), length(union(IID_disease_cases, IID_death_cases)))
# 1. 28803
# 2. 2546
# 3. 29626

fread(
    gwas_covar_f,
    select=c('FID', 'IID'),
    colClasses=c('FID'='character', 'IID'='character')
) %>% 
mutate(
    ICD_disease = if_else(IID %in% IID_disease_cases, 2, 1),
    ICD_death   = if_else(IID %in% IID_death_cases, 2, 1)
) %>%
rename('#FID' = 'FID') %>%
fwrite(icd_phe_f, sep='\t', na = "NA", quote=F)
