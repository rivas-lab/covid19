suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(data.table))

get_pop_cnt <- function(pop_count_file){
    
    cnt <- fread(pop_count_file) %>%
    column_to_rownames('#population')
    setNames(cnt$n, rownames(cnt))
}

get_haplotype_map <- function(){
    # Returns ABO alleles taged by the haplotype with 
    # 'rs8176746', 'rs687289', 'rs507666'    
    data.frame(
        haplotype      =  c('GAA', 'GAG', 'TAG', 'GGG'),
        ABO_allele      = c('A',   'A',   'B',   'O'),
        ABO_allele_full = c('A1',  'A2',  'B',   'O'),
        stringsAsFactors=F
    )   
}

read_ABO_hap_freq <- function(pops, hap_freq_dir, pop_cnt){
    ABO_haplotype_freq <- lapply(
        pops, 
        function(pop){
            freq_hap_df <- fread(
                file.path(hap_freq_dir, sprintf('ukb_ABO_tag.%s.frq.hap', pop)),
            ) %>%
            select(-LOCUS) %>%
            rename('haplotype' = 'HAPLOTYPE', 'frequency' = 'F') %>%
            mutate(
                n = round(2 * frequency * pop_cnt[[pop]]),
                f = if_else(frequency < .5, frequency, 1 - frequency),
                SE = sqrt( 1/(2*(pop_cnt[[pop]])*f*(1-2*f))),
                population = pop
            )        
        }
    ) %>%
    bind_rows() %>%
    select(population, haplotype, n, frequency, SE) %>%
    left_join(get_haplotype_map(), by='haplotype') %>%
    select(population, haplotype, ABO_allele, ABO_allele_full, n, frequency, SE)
}


compute_pheno_freq <- function(df){
    af <- setNames(
        df$frequency, 
        df$ABO_allele
    )    
    setNames(
        c(
            af[['A']] ^ 2 + 2 * af[['A']] * af[['O']],
            af[['B']] ^ 2 + 2 * af[['B']] * af[['O']],
            2 * af[['A']] * af[['B']],
            af[['O']] ^ 2
        ),
        c('A', 'B', 'AB', 'O')
    )
}

comparefreq <- function(f1, f2, n1, n2){ 
    ft <- fisher.test(matrix(c(f1*n1, n1*(1 - f1), f2*n2, n2*(1-f2)), nrow = 2), 2)
    return(ft)
}

comparefreq_wrapper <- function(case, control, ABO_type, freq_tbl, summary=F){
    test_res <- comparefreq(
        freq_tbl[case, ABO_type], freq_tbl[control, ABO_type], 
        freq_tbl[case, 'n'], freq_tbl[control, 'n'] 
    )
    if(summary){
        data.frame(
            case = case,
            control = control, 
            ABO_type = ABO_type,
            OR = test_res$estimate[1],
            CI_l = test_res$conf.int[1],
            CI_h = test_res$conf.int[2],
            P    = test_res$p.value,
            stringsAsFactors=F
        ) %>%
        mutate(
            OR_str = sprintf('%.3f (%.3f - %.3f)', OR, CI_l, CI_h)
        ) %>%
        rownames_to_column('test') %>%
        select(-test)        
    }else{
        test_res
    }
}

comparefreq_all_wrapper <- function(case, control, freq_tbl, summary=F){
    lapply(
        c('A', 'B', 'AB', 'O'),
        function(ABO){
            comparefreq_wrapper(case,control,ABO,freq_tbl, summary)
        }
    ) %>%
    bind_rows()
}