suppressWarnings(suppressPackageStartupMessages({
    library(tidyverse)
    library(data.table)
}))

gcount_format <- function(df){
    df %>%
    mutate(
        homN_Allele2=TWO_ALT_GENO_CTS,
        hetN_Allele2=HET_REF_ALT_CTS+HAP_ALT_CTS,
        N=HOM_REF_CT+HET_REF_ALT_CTS+TWO_ALT_GENO_CTS+HAP_REF_CT+HAP_ALT_CTS,
        AF=(HET_REF_ALT_CTS+2*TWO_ALT_GENO_CTS+HAP_ALT_CTS)/(2*(HOM_REF_CT+HET_REF_ALT_CTS+TWO_ALT_GENO_CTS)+(HAP_REF_CT+HAP_ALT_CTS))
    ) %>%
    select(ID, AF, homN_Allele2, hetN_Allele2, N)
}

# input
in_f <- '@@@@@@@@@@@@@@@@@@@'

# reference
afreq_d <- '@@@@@@@@@@@@@@@@@@@'
mfi_f <- '@@@@@@@@@@@@@@@@@@@'

# output
out_f_basename <- '@@@@@@@@@@@@@@@@@@@'
out_f <- file.path(dirname(in_f), out_f_basename)

print('start')

afreq_df <- c(1:22, 'X', 'XY') %>%
lapply(function(chr){
    case_df <- file.path(afreq_d, sprintf('@@@@@@@@@@@@@@@@@@@.chr%s.gcount', chr)) %>%
    fread() %>% rename('CHROM'='#CHROM') %>% gcount_format() %>%
    rename(
        'AF.Cases' = 'AF',
        'homN_Allele2_cases' = 'homN_Allele2',
        'hetN_Allele2_cases' = 'hetN_Allele2',
        'N.Cases' = 'N'
    )

    control_df <- file.path(afreq_d, sprintf('@@@@@@@@@@@@@@@@@@@.chr%s.gcount', chr)) %>%
    fread() %>% rename('CHROM'='#CHROM') %>% gcount_format() %>%
    rename(
        'AF.Controls' = 'AF',
        'homN_Allele2_ctrls' = 'homN_Allele2',
        'hetN_Allele2_ctrls' = 'hetN_Allele2',
        'N.Controls' = 'N'
    )

    case_df %>% left_join(control_df, by='ID')
}) %>%
bind_rows()

print('afreq_df .. done')

mfi_df <- fread(
    cmd=paste('zstdcat', mfi_f, '|', 'sed -e "s/#ID/ID/g"'),
    select=c('ID', 'ORIGINAL_VAR_ID', 'INFO')
)

print('mfi_df .. done')

df1 <- fread(cmd=paste('zcat', in_f)) %>%
rename('CHROM'='#CHROM') %>%
filter(ERRCODE == '.') %>%
mutate(BETA=log(OR))%>%
select(-A1, -TEST, -ERRCODE, -'FIRTH?', -OR) %>%
rename(
    'CHR'='CHROM',    
    'Allele1'='REF',
    'Allele2'='ALT',
    'SE'='LOG(OR)_SE',
    'p.value'='P'
)

print('df1 .. done')

df2 <- df1 %>%
left_join(
    mfi_df,
    by='ID'
)

print('df2 .. done')

df3 <- df2 %>%
left_join(afreq_df, by='ID') %>%
select(-ID) %>%
rename(
    'imputationInfo'='INFO',
    'ID'='ORIGINAL_VAR_ID'
) %>%
mutate(
    AC_Allele2 = 2*(homN_Allele2_cases+homN_Allele2_ctrls)+(hetN_Allele2_cases+hetN_Allele2_ctrls),
    AF_Allele2 = AC_Allele2/(2*(N.Cases+N.Controls))
) %>%
select(
    CHR, POS, Allele1, Allele2, AC_Allele2, AF_Allele2,
    imputationInfo, BETA, SE,
    p.value, AF.Cases, AF.Controls, N.Cases, N.Controls,
    homN_Allele2_cases, hetN_Allele2_cases,
    homN_Allele2_ctrls, hetN_Allele2_ctrls
)

print('df3 .. done')

df3 %>%
fwrite(out_f, sep='\t', na = "NA", quote=F)
