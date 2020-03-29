suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(data.table))

read_plink_out <- function(field_val_list, ext){
    lapply(field_val_list, function(field_val){
        file.path(freq_data_dir, sprintf('ukb_hla_v3.%s.%s', field_val, ext)) %>%
        fread(file=.) %>%
        rename('CHROM'='#CHROM') %>%
        mutate(field_val = field_val)
    }) %>% bind_rows()    
}

UKB_HLA_ID_to_4digit_allele <- function(df){
    df %>% 
    mutate(ID_copy = ID) %>%
    separate(ID_copy, c('Locus', 'Allele_digits')) %>%
    mutate(
        Allele_digits = sprintf('%04d', as.integer(Allele_digits)),
        Allele = sprintf(
            '%s*%s:%s', Locus, 
            str_sub(Allele_digits, 1, 2), 
            str_sub(Allele_digits, 3, 4)
        ),
        Locus = paste0('HLA-', Locus)
    ) %>%
    select(-Allele_digits)   
}
