library(magrittr)

data_path <- "/home/liucj/tmp/snoric/clean_data/rna_splicing_succinct2"


rds <- list.files(data_path, pattern = "rna_splicing_pair")

rds %>% 
  purrr::map(
    .f = function(.x) {
      
      readr::read_rds(file.path(data_path, .x)) %>% 
        dplyr::filter(abs(r) > 0.3, fdr < 0.05) -> .d
    
      unique(.d$snorna) %>% length() -> .n_snorna
    
      .d %>% 
        dplyr::mutate(s = paste(gene_symbol, exons, sep = "_")) %>% 
        dplyr::pull(s) %>% unique() %>% length() -> .n_exons
    
      .d$gene_symbol %>% unique() %>% length() -> .n_gene
    
      sum(.d$r > 0) -> .pos
      sum(.d$r < 0) -> .neg
    
      list(`Cancer types` = unique(.d$dataset_id), snoRNA = .n_snorna, Gene = .n_gene, `Splice event` = .n_exons, Postive = .pos, Negative = .neg)
    }
  ) %>% 
  dplyr::bind_rows() -> splice_stat

splice_stat %>% readr::write_csv(path = "splice_stat.csv")
   



value <- readr::read_rds(file.path(data_path, "rna_splicing_value_ACC.rds.gz"))
