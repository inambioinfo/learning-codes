library(magrittr)

data_path <- "/home/liucj/data/data/diploma/SNORic/snoric/clean_data/cnv"
mrna_path <- "/home/liucj/data/data/diploma/SNORic/snoric/clean_data/mrna_expression/r0.3"

rds <- list.files(data_path, pattern = "rds.gz")
list.files(path = mrna_path, pattern = "rds.gz")

get_stat <- function(.x){}

rds %>% 
  head(1) %>% 
  purrr::map(
    .f = function(.x) {
      .cnv <- readr::read_rds(file.path(data_path, .x)) %>% 
        dplyr::select(-dataset_id) %>% 
        tidyr::gather(key = "barcode", value = "cnv", -snorna)
      
      
      .ctyps <- stringr::str_split(string = .x, pattern = "\\.", simplify = TRUE)[1,2]
      
      .mrna <- readr::read_rds(path = file.path(mrna_path, glue::glue("mrna_expression.{.ctyps}.rds.gz"))) %>% 
        dplyr::select(-c(2:7)) %>% 
        tidyr::gather(key = "barcode", value = mrna, -snorna)
      
      .cnv %>% dplyr::inner_join(.mrna, c("snorna", "barcode")) %>% 
        dplyr::mutate(cnv = as.numeric(cnv)) -> .cnv_mrna
      
      .cnv_mrna %>% 
        tidyr::drop_na(cnv, mrna) %>% 
        dplyr::group_by(snorna) %>% 
        dplyr::do(
          broom::tidy(
              tryCatch(
                expr = cor.test(.$cnv, .$mrna, method = 'spearman'),
                error = function(e) {1}
              )
            )
          ) -> .corr
        
      .corr %>% 
        dplyr::ungroup() %>% 
        dplyr::select(snorna, estimate, p.value) %>% 
        dplyr::filter(!is.na(p.value)) %>% 
        dplyr::arrange(estimate)
    }
  )