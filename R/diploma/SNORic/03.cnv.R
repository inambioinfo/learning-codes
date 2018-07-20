library(magrittr)

data_path <- "/home/liucj/data/data/diploma/SNORic/snoric/clean_data/cnv"
snorna_path <- "/home/liucj/data/data/diploma/SNORic/snoric/clean_data/snorna_expression"

rds <- list.files(data_path, pattern = "rds.gz")
list.files(path = mrna_path, pattern = "rds.gz")

get_stat <- function(.x){}

rds %>% 
  purrr::map(
    .f = function(.x) {
      .cnv <- readr::read_rds(file.path(data_path, .x)) %>% 
        dplyr::select(-dataset_id) %>% 
        tidyr::gather(key = "barcode", value = "cnv", -snorna)
      
      
      .ctyps <- stringr::str_split(string = .x, pattern = "\\.", simplify = TRUE)[1,2]
      
      .mrna <- readr::read_rds(path = file.path(snorna_path, glue::glue("snorna_expression.{.ctyps}.rds.gz"))) %>% 
        dplyr::select(-2) %>% 
        tidyr::gather(key = "barcode", value = mrna, -snorna)
      
      .cnv %>%  
        dplyr::mutate(cnv = as.numeric(cnv)) %>% 
        tidyr::drop_na(cnv) %>% 
        dplyr::inner_join(.mrna, by = c("snorna", "barcode")) -> .cnv_mrna
      
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
        dplyr::arrange(estimate) %>% 
        dplyr::mutate(fdr = p.adjust(p.value, method = "fdr")) 
    }
  ) -> rds_corr


rds %>% stringr::str_split(pattern = "\\.", simplify = TRUE) %>% .[,2] -> .names
names(rds_corr) <- .names
readr::write_rds(x = rds_corr, path = "cnv_corr.rds.gz", compress = "gz")

rds_corr %>% 
  tibble::enframe() %>% 
  dplyr::mutate(
    stat = purrr::map(
      .x = value, 
      .f = function(.x) {
        .x %>% dplyr::filter(fdr < 0.05) -> .d
        pos <- sum(.d$estimate > 0)
        neg <- sum(.d$estimate < 0)
        tibble::tibble(
          pos = pos,
          neg = neg
        )
      }
    )
  ) %>% 
  dplyr::select(-value) %>% 
  tidyr::unnest() -> cnv_cor

names(cnv_cor) <- c("Cancer Types", "Positive", "Negative")

cnv_cor %>% readr::write_csv(path = "cnv_corr.csv")
