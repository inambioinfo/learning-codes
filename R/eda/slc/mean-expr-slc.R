library(magrittr)

# read gene list ----------------------------------------------------------

readr::read_csv(file = "slc-gene-list.txt", col_names = FALSE) %>% 
  tidyr::gather(key = "id", value = "gene_symbol") %>% 
  dplyr::select(gene_symbol) %>% 
  dplyr::distinct() %>% 
  dplyr::pull(1) ->
  slc
  
# load expr data ----------------------------------------------------------
data_path <- "/data/liucj/project/06-autophagy/TCGA"
expr <- readr::read_rds(path = file.path(data_path, "pancan33_expr.rds.gz"))


# gene symbol -------------------------------------------------------------

expr %>% 
  dplyr::mutate(
    expr = purrr::map(
      .x = expr,
      .f = function(.x){
        .x %>% 
          dplyr::filter(symbol %in% c(slc, "NHEDC1", "NHEDC2")) %>% 
          dplyr::mutate(symbol = ifelse(test = symbol == "NHEDC1", yes = "SLC9B1", no = symbol)) %>% 
          dplyr::mutate(symbol = ifelse(test = symbol == "NHEDC2", yes = "SLC9B2", no = symbol)) %>% 
          dplyr::select(-2) ->
          .data
        
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
  writexl::write_xlsx(path = "slc-gene-list-mean-expr.xlsx",col_names = TRUE)
