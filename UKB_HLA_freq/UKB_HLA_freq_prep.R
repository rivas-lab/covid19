suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(data.table))

# we read allelotype counts from file
df <- lapply(
    c('A','B','C','DPA1','DPB1','DQA1','DQB1','DRB1','DRB3','DRB4','DRB5'),
    function(x){fread(sprintf('data/%s_freq.csv', x), sep=',')}
) %>%
bind_rows() %>% 
rename('count' = 'frequency')

# compute the sum of counts
count_sum <- sum(df$count)

# compute the allelotype frequencies and save them to the output file
df %>%
mutate(
    frequency=count/count_sum
) %>%
rename('#allelotype' = 'allelotype') %>%
fwrite('UKB_HLA_freq.tsv', sep='\t')
