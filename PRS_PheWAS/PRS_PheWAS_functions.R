suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(data.table))

glm_wrapper <- function(glm_df, phenotype, covariates, PRS_col, family='gaussian', df=FALSE){
    glmfit <- stats::glm(
        stats::as.formula(sprintf(
            '%s ~ 1 + %s + scale(%s)', 
            phenotype, paste(covariates, collapse =' + '), PRS_col
        )),
        family=family,
        data=glm_df
    ) 
    if(!df){
        glmfit
    }else{
        glmfit_coeff_df <- summary(glmfit)$coefficients %>%
        data.frame() %>%
        rownames_to_column('variable') %>%
        mutate(
            variable=str_sub(variable, 1, 15)
        )
        
        data.frame(
            phenotype = phenotype,
            PRS_col = PRS_col,
            BETA    = glmfit_coeff_df[nrow(glmfit_coeff_df), 2],
            std_err = glmfit_coeff_df[nrow(glmfit_coeff_df), 3],
            P       = glmfit_coeff_df[nrow(glmfit_coeff_df), 5],            
#             BETA    = glmfit_coeff_df[nrow(glmfit_coeff_df), 'Estimate'],
#             std_err = glmfit_coeff_df[nrow(glmfit_coeff_df), 'Std..Error'],
#             P       = glmfit_coeff_df[nrow(glmfit_coeff_df), 'Pr...t..'],
            stringsAsFactors=F
        ) %>%
        mutate(
            l_err    = BETA - std_err,
            u_err    = BETA + std_err,
            BETA_str = sprintf('%.3f (%.3f,%.3f)', BETA, l_err, u_err),
            P_str    = sprintf('%.2e', P)
        )        
    }
}

phewas_loop <- function(df, phenotypes, PRS_cols, covariates, family='gaussian'){
    lapply(phenotypes, function(phenotype){
        phewas_df <- df %>% drop_na(phenotype)
        lapply(PRS_cols, function(PRS_col){
            tryCatch({
                glm_wrapper(phewas_df, phenotype, covariates, PRS_col, family, T)
            }, error=function(e){})
        }) %>% 
        bind_rows()    
    }) %>%
    bind_rows()
}
