suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(data.table))

f <- 'summarize.to.2digits.alleles.tsv'

df <- fread(f, head=F, data.table=F, col.name = c('Locus', 'Allele')) %>%
filter(Locus != 'ABS') %>%
mutate(
    Allele = str_replace(Allele, 'HLA-', ''),
    loc = str_locate_all(Allele, ':'),
    revisit = str_detect(Allele, '/')    
)

df$end <- 1:nrow(df) %>%
lapply(function(idx){
    magrittr::extract2(df$loc, idx)[,1][1]
})

df %>% 
mutate(
    Allele2digit = if_else(
        is.na(end), 
        str_sub(Allele, 1, str_length(Allele)),
        str_sub(Allele, 1, as.integer(end) - 1)
    )
) %>%
select(-loc, -end) %>%
unique() %>%
arrange(Locus, Allele2digit, Allele) %>%
select(Locus, Allele, Allele2digit, revisit) %>%
fwrite(f, sep='\t', na = "NA", quote=F)
