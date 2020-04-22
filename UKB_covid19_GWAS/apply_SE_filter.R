fullargs <- commandArgs(trailingOnly=FALSE)
args <- commandArgs(trailingOnly=TRUE)

script.name <- normalizePath(sub("--file=", "", fullargs[grep("--file=", fullargs)]))

suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(data.table))

####################################################################
radiogwas <- as.integer(args[1])
####################################################################

apply_filter <- function(fm, radiogwas){
    if(radiogwas == 4 ){
      fm <- fm[fm["SE"] <= .6 , ]
    }else if(radiogwas == 5){
      fm <- fm[!is.na(fm["P"]) & fm["LOG(OR)_SE"] <= .3 , ]
    }else if(radiogwas == 6){
      fm <- fm[!is.na(fm["P"]) & fm["SE"] <= .2 , ]
    }else{
      fm <- fm[!is.na(fm["P"]) & fm["LOG(OR)_SE"] <= .6, ]
    }
    fm
}

apply_filter_main <- function(radiogwas){
    ss_d <- '@@@@@@@@@@@@@@@@@@@'
    ma_d <- '@@@@@@@@@@@@@@@@@@@'
    out_d <- '@@@@@@@@@@@@@@@@@@@'
    sumstats_files <- list()
    sumstats_files[['0']] <- file.path(ss_d, 'ukb24983_v2_hg19.white_british.array-combined.covid19_test_result.glm.logistic.hybrid.BMI_Townsend.gz')
    sumstats_files[['8']] <- file.path(ss_d, 'ukb24983_v2_hg19.white_british.array-combined.ICD_disease.glm.logistic.hybrid.gz')
    sumstats_files[['9']] <- file.path(ss_d, 'ukb24983_v2_hg19.white_british.array-combined.ICD_death.glm.logistic.hybrid.gz')
    sumstats_files[['7']] <- file.path(ss_d, 'ukb24983_v2_hg19.white_british.array-combined.covid19_severe.glm.logistic.hybrid.gz')
    sumstats_files[['1']] <- file.path(ss_d, 'ukb24983_v2_hg19.WB_NBW.array-combined.covid19_test_result.glm.logistic.hybrid.BMI_Townsend.gz')
    sumstats_files[['2']] <- file.path(ss_d, 'ukb24983_v2_hg19.s_asian.array-combined.covid19_test_result.glm.logistic.hybrid.BMI_Townsend.gz')
    sumstats_files[['3']] <- file.path(ss_d, 'ukb24983_v2_hg19.african.array-combined.covid19_test_result.glm.logistic.hybrid.BMI_Townsend.gz')
    sumstats_files[['4']] <- file.path(ma_d, 'ukb24983_v2_hg19.array-combined.covid19_test_result.BMI_Townsend.metal.tsv.gz')
    sumstats_files[['5']] <- file.path(ss_d, 'ukb24983_v2_hg38.WB_NBW.exome-spb.covid19_test_result.glm.logistic.hybrid.gz')
    sumstats_files[['6']] <- file.path(ma_d, 'ukb24983_v2_hg19.array-combined.covid19_test_result.recessive.metal.tsv.gz')
    
    in_f <- sumstats_files[[as.character(radiogwas)]]
    fread(in_f, data.table=F) %>%
    apply_filter(radiogwas) %>%
    fwrite(file.path(out_d, basename(in_f)), sep='\t', na = "NA", quote=F)
}

####################################################################

apply_filter_main(radiogwas)
