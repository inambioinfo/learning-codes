library(magrittr)

data_path <- "/home/liucj/data/data/diploma/SNORic/snoric/clean_data/methylation"
snorna_path <- "/home/liucj/data/data/diploma/SNORic/snoric/clean_data/snorna_expression"

rds_file <- list.files(data_path, "rds.gz")

rds_file %>% 
  purrr::map(
    .f = function(.x) {
      .d <- readr::read_rds(path = file.path(data_path, .x)) %>% 
        dplyr::select(-2,-3,-4,-5, -6, -7, -8,-10) %>% 
        tidyr::gather(key = "barcode", value = "beta", -c(snorna, meth_id)) %>% 
        dplyr::mutate(beta = as.numeric(beta)) %>% 
        tidyr::drop_na(beta)
      
      .ctyps <- stringr::str_split(string = .x, pattern = "\\.", simplify = TRUE)[1,2]
      
      .mrna <- readr::read_rds(path = file.path(snorna_path, glue::glue("snorna_expression.{.ctyps}.rds.gz"))) %>% 
        dplyr::select(-2) %>% 
        tidyr::gather(key = "barcode", value = mrna, -snorna) %>% 
        tidyr::drop_na(mrna)
      
      .d %>% dplyr::inner_join(.mrna, by = c('snorna', 'barcode')) -> .dd
      
      .dd %>% 
        dplyr::group_by(snorna, meth_id) %>% 
        dplyr::do(
          broom::tidy(
            tryCatch(
              expr = cor.test(.$beta, .$mrna, method = 'spearman'),
              error = function(e) {1}
            )
          )
        ) -> .corr
      .corr %>% 
        dplyr::ungroup() %>% 
        dplyr::select(snorna,meth_id, estimate, p.value) %>% 
        dplyr::filter(!is.na(p.value)) %>% 
        dplyr::arrange(estimate) 
    }
  ) -> rds_corr

rds_file %>% stringr::str_split(pattern = "\\.", simplify = TRUE) %>% .[,2] -> .names
names(rds_corr) <- .names

readr::write_rds(x = rds_corr, path = "meth_corr.rds.gz", compress = "gz")




rds_corr %>% 
  tibble::enframe() %>% 
  dplyr::mutate(
    stat = purrr::map(
      .x = value, 
      .f = function(.x) {
        .x %>% dplyr::filter(p.value < 0.05) -> .d
        
        .d$snorna %>% unique() %>% length() -> sno
        .d %>% dplyr::group_by(snorna) %>% dplyr::count() %>% .$n %>% mean() -> .mean
        pos <- sum(.d$estimate > 0)
        neg <- sum(.d$estimate < 0)
        tibble::tibble(
          snorna = sno,
          pos = pos,
          neg = neg,
          mean = .mean
        )
      }
    )
  ) %>% 
  dplyr::select(-value) %>% 
  tidyr::unnest() -> meth_cor

names(meth_cor) <- c("Cancer Types", "snoRNA", "Positive", "Negative", "Mean Chip")

meth_cor %>% readr::write_csv(path = "meth_corr.csv")




