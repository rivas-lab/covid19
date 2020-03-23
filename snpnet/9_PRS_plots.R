fullargs <- commandArgs(trailingOnly=FALSE)
args <- commandArgs(trailingOnly=TRUE)

script.name <- normalizePath(sub("--file=", "", fullargs[grep("--file=", fullargs)]))

suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(data.table))
library(latex2exp)

####################################################################
source(file.path(dirname(script.name), 'functions.R'))
####################################################################

# input
phe_info_f<-args[1]
phe_f<-args[2]
trait<-args[3]
score_f<-args[4]

# output
score_plot_f<-args[5]
score_summary_f<-args[6]

####################################################################
# some functions to format the labels and units

plot_name_patch <- function(name){
    name %>%
    str_replace_all('%', 'percentage')
}

plot_units_patch <- function(units){
    units %>%
    str_replace_all('percent', '$\\%$') %>%
    str_replace_all('/', ' / ')
}

####################################################################

# read phenotype meta data file
phe_info_df <- fread(phe_info_f) %>%
rename('GBE_ID' = '#GBE_ID')

phe_info_plot_names <- setNames(phe_info_df$pheno_plot, phe_info_df$GBE_ID)
phe_unit <- setNames(phe_info_df$Units_of_measurement, phe_info_df$GBE_ID)

# read the raw phenotype and PRS
df <- read_phe(phe_f, trait) %>% 
left_join(read_PRS_score(score_f), by='ID')

# prepare data frames for the plots
plot_df <- df %>% 
filter(split == 'test') %>% 
drop_na(SCORE_geno, pheno) %>%
mutate(
    SCORE_geno_z = (SCORE_geno - mean(SCORE_geno)) / sd(SCORE_geno),
    SCORE_geno_percentile = rank(-SCORE_geno) / n()
)

summary_plot_df <- plot_df %>%
compute_summary_df('SCORE_geno_percentile', 'pheno')

# write the summary table to a file
summary_plot_df %>% 
rename('#l_bin' = 'l_bin') %>%
fwrite(score_summary_f, sep='\t', na = "NA", quote=F)

# plot
plot_labs_title <- sprintf(
    '%s (%s)', 
    plot_name_patch(phe_info_plot_names[[trait]]),
    trait
)

plot_labs_y <- TeX(sprintf(
    '%s  \\[%s\\]', 
    plot_name_patch(phe_info_plot_names[[trait]]), 
    plot_units_patch(phe_unit[[trait]])
))

p1 <- plot_df %>%
plot_PRS_vs_phe() +
theme(legend.position=c(.1, .8))+
labs(title = plot_labs_title, x = 'snpnet PRS (Z-score)', y = plot_labs_y)    

p2 <- summary_plot_df %>%
plot_PRS_bin_vs_phe(mean(plot_df$pheno))+
labs(
    title = plot_labs_title,
    x = 'The percentile of snpnet PRS',
    y = plot_labs_y
)

# save the plot into a file
g <- gridExtra::arrangeGrob(p1, p2, ncol=2)
ggsave(score_plot_f, g, width=12, height=6)

# # view the plots in Jupyter notebook
# options(repr.plot.width=10, repr.plot.height=5)
# gridExtra::grid.arrange(p1, p2, ncol=2)
