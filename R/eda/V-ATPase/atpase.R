library(magrittr)

# read gene list ----------------------------------------------------------
root <- file.path(getwd(), "eda", "V-ATPase")
atpase <- readr::read_tsv(file = file.path(root, "tabula-1-s2.0-S0925443909000039-main.tsv")) %>% 
  dplyr::pull(2) %>% 
  stringr::str_trim(side = "both")

# load expr data ----------------------------------------------------------
data_path <- "/data/liucj/project/06-autophagy/TCGA"
expr <- readr::read_rds(path = file.path(data_path, "pancan33_expr.rds.gz"))

expr %>% 
  dplyr::mutate(
    expr = purrr::map(
      .x = expr,
      .f = function(.x){
        .x %>% 
          dplyr::select(-2) %>% 
          dplyr::filter(symbol %in% atpase) -> .data
        
        names(.data)[-1] -> .barcode
        .barcode %>% purrr::map_lgl(
          .f = function(.b){
            if (stringr::str_sub(string = .b, start = 14, end = 14) != "1") TRUE else FALSE 
          }
        ) %>% 
          .barcode[.] -> .tumor_samples
        
        .data %>% 
          dplyr::select(1, .tumor_samples) %>% 
          dplyr::mutate(m = rowMeans(.[,-1])) %>% 
          dplyr::select(1, m)
      }
    )
  ) %>%  
  tidyr::unnest() %>% 
  tidyr::spread(key = cancer_types, value = m) -> gene_list_mean_expr


gene_list_mean_expr %>% 
  dplyr::mutate_if(.predicate = is.numeric, .funs = round, digits = 2) %>% 
  writexl::write_xlsx(path = file.path(root, "v-atpase-gene-list-mean-expr.xlsx"),col_names = TRUE)
