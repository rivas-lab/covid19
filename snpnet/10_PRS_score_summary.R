suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(data.table))

#input
phe_info_f <- 'pheno.info.tsv'
data_dir<-'@@@@@@@@@@@@@@@@@@@'
# output
score_summary_all_f<-'metric.quantile.summary.blood.tsv'

phe_info_df <- fread(phe_info_f) %>%
rename('GBE_ID' = '#GBE_ID')%>%
filter(GBE_ID != pheno)

score_summary_all_df <- lapply(
    phe_info_df$GBE_ID,
    function(phenotype){
        df <- fread(
            file.path(data_dir, phenotype, sprintf('%s.sscore.summary.tsv', phenotype)),
            select=c('bin_str', 'mean_str')
        ) 
        colnames(df) <- c('quantile_bin', phenotype)
        df
    }
) %>%
reduce(
    function(x, y){x %>% inner_join(y, by='quantile_bin')}
)

score_summary_all_df %>%
rename('#quantile_bin' = 'quantile_bin') %>%
fwrite(score_summary_all_f, sep='\t', na = "NA", quote=F)
